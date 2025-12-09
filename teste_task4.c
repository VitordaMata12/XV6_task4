#include "types.h"
#include "stat.h"
#include "user.h"

// Variável global para teste
int global_val = 50;

void
test_simple()
{
  printf(1, "\n--- Iniciando Teste Simples (CoW) ---\n");
  
  int local_val = 100;
  int pid = cowfork();

  if(pid < 0){
    printf(1, "Erro no cowfork\n");
    exit();
  }

  if(pid == 0){
    // PROCESSO FILHO
    // Tenta ler os valores (deve ser permitido e igual ao pai)
    if(global_val != 50 || local_val != 100){
      printf(1, "ERRO: Filho leu valores incorretos antes da escrita.\n");
      exit();
    }

    // Tenta ESCREVER (Aqui deve ocorrer o Page Fault tratado pelo CoW)
    printf(1, "Filho: Tentando modificar valores...\n");
    global_val = 55;
    local_val = 155;

    printf(1, "Filho: Valores modificados. Global=%d, Local=%d\n", global_val, local_val);
    exit();
  } else {
    // PROCESSO PAI
    wait(); // Espera o filho terminar
    
    // Verifica se a memória do pai foi afetada (NÃO DEVE SER)
    if(global_val == 50 && local_val == 100){
      printf(1, "[TESTE 1] Simples: OK (Memoria do pai preservada)\n");
    } else {
      printf(1, "[TESTE 1] FALHA: Memoria do pai foi alterada pelo filho!\n");
      printf(1, "Esperado: 50/100. Recebido: %d/%d\n", global_val, local_val);
    }
  }
}

void
test_stress()
{
  printf(1, "\n--- Iniciando Stress Test (Multiplos Filhos) ---\n");
  
  int i;
  int pid;
  int *shared_mem = (int*)malloc(sizeof(int));
  *shared_mem = 10;

  for(i = 0; i < 5; i++){
    pid = cowfork();
    if(pid == 0){
      // Filho modifica a memória alocada
      // Isso deve forçar a cópia apenas para este filho
      *shared_mem = *shared_mem + (i + 1);
      printf(1, "Filho %d terminou. Valor local: %d\n", i, *shared_mem);
      exit();
    }
  }

  // Pai espera todos os filhos
  for(i = 0; i < 5; i++){
    wait();
  }

  // O valor do pai deve permanecer intocado
  if(*shared_mem == 10){
    printf(1, "[TESTE 2] Stress Test: OK (Contador de referencias funcionou)\n");
  } else {
    printf(1, "[TESTE 2] FALHA: Valor do pai alterado para %d\n", *shared_mem);
  }
  
  free(shared_mem);
}

int
main(int argc, char *argv[])
{
  printf(1, "Iniciando verificacao do CoW Fork...\n");

  test_simple();
  test_stress();

  printf(1, "\nTODOS OS TESTES PASSARAM!\n");
  exit();
}
