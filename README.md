# Projeto de Implementação 2 - Gerenciamento de Memória XV6
## Task 4: Copy-on-Write (CoW) Fork

**Disciplina:** Sistemas Operacionais
**Grupo:** [INSERIR NÚMERO DO GRUPO]
**Membros:**
* Caio Marques Bertolucci
* Maurício Alonzo
* Pedro Leal Macedo
* Ricardo Yukio Hoshino Doi
* Vinicius Ferreira Araújo
* Vitor Rodrigues da Mata
* Yuri Arita de Carvalho

---

### 1. Descrição do Projeto
Este projeto implementa a otimização de gerenciamento de memória conhecida como **Copy-on-Write (CoW)** no sistema operacional XV6.

A implementação substitui o comportamento padrão do `fork()`, que copiava fisicamente todas as páginas de memória, por uma nova abordagem (`cowfork`) onde as páginas são compartilhadas entre pai e filho como "Somente Leitura" (Read-Only). A cópia física dos dados ocorre apenas sob demanda, quando um dos processos tenta escrever na memória, gerando uma interrupção (Page Fault) tratada pelo kernel.

### 2. Arquivos Modificados
Para realizar esta tarefa, os seguintes arquivos do kernel foram alterados:

* **`vm.c`**: Implementação da função `copyuvm_cow` (compartilhamento de páginas) e alteração de visibilidade da função `walkpgdir`.
* **`kalloc.c`**: Adição do array `ref_count` para contagem de referências, funções de manipulação (`inc_ref`, `dec_ref`) e ajuste no `kfree` para evitar liberar memória em uso. Inclui também correção para evitar *panic* durante o boot.
* **`trap.c`**: Adição do tratamento para a exceção `T_PGFLT` (14), que realiza a alocação tardia (Lazy Allocation) da página.
* **`mmu.h`**: Definição da flag `PTE_COW` (bit 8) e adição de *Header Guards* para evitar erros de redefinição.
* **`defs.h`**: Registro das novas funções globais (`cowfork`, `walkpgdir`, `inc_ref`, etc.).
* **`sysproc.c` / `syscall.h` / `syscall.c` / `user.h` / `usys.S`**: Registro da nova system call `cowfork`.
* **`Makefile`**: Adição do programa de usuário `teste_task4` na lista `UPROGS`.

### 3. Como Compilar

Certifique-se de estar no diretório raiz do projeto (onde está o `Makefile`).

1.  Limpe os arquivos de compilações anteriores para garantir uma build limpa:
    ```bash
    make clean
    ```

2.  Compile e inicie o emulador QEMU:
    ```bash
    make qemu
    ```

### 4. Como Executar os Testes

Foi desenvolvido um programa de teste específico chamado `cowtest` para validar a funcionalidade.

1.  Após iniciar o XV6 (quando aparecer o prompt `$`), execute:
    ```bash
    cowtest
    ```

2.  **Comportamento Esperado:**
    O teste executará cenários de leitura (memória compartilhada) e escrita (memória copiada/independente) entre processos pai e filhos. Se a implementação estiver correta, a saída será:

    ```text
    Iniciando verificacao do CoW Fork...

    --- Iniciando Teste Simples (CoW) ---
    [TESTE 1] Simples: OK (Memoria do pai preservada)

    --- Iniciando Stress Test (Multiplos Filhos) ---
    Filho 0 terminou. Valor local: ...
    ...
    [TESTE 2] Stress Test: OK (Contador de referencias funcionou)

    TODOS OS TESTES PASSARAM!
    ```

### 5. Notas de Implementação
* **Boot Safety:** O `kfree` foi modificado para verificar `kmem.use_lock`. Isso impede que o kernel entre em pânico ("unknown apicid") durante a inicialização, antes que as CPUs estejam configuradas.
* **Header Guards:** Foram adicionados guardas (`#ifndef MMU_H`) no `mmu.h` para corrigir conflitos de compilação cruzada.
* **Shell Padrão:** O shell do XV6 e comandos básicos (`ls`, `cat`) continuam funcionando normalmente utilizando o `fork` padrão, enquanto o `cowtest` utiliza explicitamente a nova syscall `cowfork`.

---
