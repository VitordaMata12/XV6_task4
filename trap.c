#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  // Dentro do switch(tf->trapno)
  case T_PGFLT: // Valor 14
    {
      uint va = rcr2(); // Endereço virtual que causou o erro
      pte_t *pte;
      uint pa;
      char *mem;
      
      // Verifica se é um endereço válido do processo
      if(va >= KERNBASE || (pte = walkpgdir(myproc()->pgdir, (void*)va, 0)) == 0 || !(*pte & PTE_P) || !(*pte & PTE_U)) {
          cprintf("Segmentation Fault\n");
          myproc()->killed = 1;
          break;
      }

      // Verifica se a falha foi por causa do mecanismo COW
      if(*pte & PTE_COW) {
          pa = PTE_ADDR(*pte);
          
          // Caso 1: Se o contador de referência for 1, apenas tornamos gravável novamente
          // (Ninguém mais está compartilhando, então a página é "minha")
          if(get_ref(pa) == 1) {
              *pte |= PTE_W;
              *pte &= ~PTE_COW;
          } 
          // Caso 2: Contador > 1. Precisamos alocar nova página e copiar.
          else {
              if((mem = kalloc()) == 0) {
                  cprintf("CoW: Out of memory\n");
                  myproc()->killed = 1;
                  break;
              }
              
              // Copia o conteúdo da página antiga para a nova
              memmove(mem, (char*)P2V(pa), PGSIZE);
              
              // Decrementa referência da página antiga
              dec_ref(pa);
              
              // Atualiza o PTE para apontar para a NOVA página física
              // Define como Gravável (W) e remove marcação COW
              uint flags = PTE_FLAGS(*pte);
              flags |= PTE_W;
              flags &= ~PTE_COW;
              
              // Mapeia novo endereço físico na tabela
              *pte = V2P(mem) | flags;
          }
          
          // IMPORTANTE: Flush do TLB conforme o enunciado
          uint cr3_val;
          asm volatile("movl %%cr3, %0" : "=r" (cr3_val));
          asm volatile("movl %0, %%cr3" :: "r" (cr3_val));
          
          break; // Falha tratada com sucesso
      }
      
      // Se não for COW e deu page fault, é erro legítimo
      cprintf("Page fault legítimo (não COW)\n");
      myproc()->killed = 1;
    }
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
