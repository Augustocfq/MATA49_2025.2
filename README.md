# Introdução

O **ATMEGA328P** é um microcontrolador (µC) RISC de 8 bits baseado na arquitetura **AVR RISC**, que por sua vez é uma implementação da arquitetura de Harvard, que separa a memória de Programa da memória de Dados. Por se tratar de um µC de arquitetura RISC, uma de suas principais caracteristicas é que apenas as instruções LOAD e STORE tem a capacidade de acessar registradores da Memória de dados.

![Arquitetura de Harvard no ATMEGA328P](https://github.com/user-attachments/assets/b414d850-6d50-433b-8f59-6eae86695313)

---

## Especificações Principais

* **Arquitetura:** AVR RISC de 8 bits
* **Instruções:** 131
* **Memória de Programa:** 32 KB
* **Memória de Dados:** 2304B
  * **SRAM (RAM):** 2 KB
  * **I/O Externo:** 160 B
  * **I/O Interno:** 64 B
  * **Registradores de propósito geral:** 32 B
* **EEPROM (ROM):** 1 KB
* **Pinos de I/O:** 23

### Registradores de proposito geral

Os registradores de propósito geral são nomeados de R0 à R31, sendo que os 6 últimos podem ser usados para simular registradores de 16 bits, chamados X, Y e Z, onde X[R27:R26] Y[R29:R28] e Z[R31:R30] (o registrador par armazena os 8 LSB e o impar os 8 MSB).

### REgistradores mais importantes do I/O interno

#### SREG (Status Register)

![Estrutura do SREG](https://github.com/user-attachments/assets/5f5a6eb4-3231-4c7d-9171-92d6ca150254)

Reporta em cada bit seu como foi a conclusão da última instrução executada, onde:

* **bit C:** Sinaliza a ocorrência de um unsigned overflow
* **bit Z:** Sinaliza se o resultado da operação é 0
* **bit N:** Sinaliza se o resultado de uma operação é negativo
* **bit V:** Sinaliza a ocorrência de um signed overflow
* **bit S:** Indica o sinal lógico do resultado de uma operação, mesmo que haja overflow, onde (0, +) e (1, -)
* **bit H:** Sinaliza um overflow do 1º para o 2º nibble
* **bit T:** Sinaliza que um registrador foi copiado
* **bit I:** Define a atividade do serviço de interrupção

#### SP (Stack Pointer)

![Estrutura do SP](https://github.com/user-attachments/assets/4afa1d16-930c-44a8-bc0a-2226e6b033c9)

Armazena o endereço da SRAM correspondente ao topo da pilha. No AVR, a estratégia de "Full Descending Stack", onde o SP aponta para o último endereço ocupado na pilha. O comportamento é:

* **Empilhamento (PUSH):** 1º Pré-decrementa o SP, 2º Armazena o dado
* **Desempilhamento (POP):** 1º Carrega o dado, 2º Pós-incrementa o SP

O SP é implementado como dois registradores de I/O (SPH e SPL), mas só endereça 12 bits.

---

## Pinagem Essencial (PDIP-28)

| Pino | Símbolo | Função Principal |
|------|---------|------------------|
| 7 | Vcc | Alimentação (+5V) para circuitos digitais |
| 20 | AVcc | Alimentação (+5V) para circuitos analógicos |
| 21 | AREF | Tensão de referência para o ADC |
| 8, 22 | GND | Aterramento |

![Diagrama de pinos no ATMEGA328P](https://github.com/user-attachments/assets/67864afa-1a18-4ace-b8e9-6695bd2efd5e)
![Diagrama de pinos na placa Arduino UNO](https://github.com/user-attachments/assets/802deeda-5b5d-425d-ac91-4b7f50bf74b9)

---

## Instruções de Controle de Fluxo

Assim como na arquitetura x86, podemos dividir as instruções de controle de fluxo em 2 grupos, as de desvio incondicional e condicional.

### Desvio Incondicional

Estas instruções forçam o salto para um novo endereço de memória independentemente do estado atual do processador.

* **JMP (Jump):** Realiza um salto direto para um endereço absoluto.
  * **Características:**
    * **Tamanho da Palavra:** 2 palavras (4 bytes)
    * **Clock:** 3 ciclos
  * **Aplicação:** Consegue endereçar toda a Memória de Programa, é a escolha necessária quando o destino do salto está muito distante da instrução atual.

* **RJMP (Relative Jump):** Realiza um salto relativo à posição atual do PC ($PC \leftarrow PC + k + 1$).
  * **Características:**
    * **Tamanho da Palavra:** 1 palavra (2 bytes)
    * **Clock:** 2 ciclos
  * **Aplicação:** Mais eficiente em memória que o JMP, porém tem alcance limitado ($\pm 2k$ palavras), a instrução ideal para loops curtos e estruturas de controle locais.

* **IJMP (Indirect Jump):** O salto é realizado para o endereço armazenado dinamicamente no registrador Z
  * **Características:**
    * **Tamanho da Palavra:** 1 palavra (2 bytes)
    * **Clock:** 2 ciclos
  * **Aplicação:** Permite calcular o endereço de destino em tempo de execução, essencial para jump tables, máquinas de estado complexas e ponteiros de função.

### Desvio Condicional

No fluxo condicional, o salto depende de uma verificação prévia (Comparação) e da análise do estado resultante (Branch).

#### 1. Instruções de Comparação

Antes de decidir o desvio, o microcontrolador avalia a relação entre valores para atualizar o SREG.

* **CPI (Compare with Immediate):** Compara o conteúdo de um registrador com uma constante numérica ($Rd - K$).
  * **Características:**
    * **Tamanho da Palavra:** 1 palavra (2 bytes)
    * **Clock:** 1 ciclo
  * **Aplicação:** Utilizada para verificar se uma variável atingiu um valor específico, apenas as flags são atualizadas; o resultado numérico é descartado.

* **CPC (Compare with Carry):** Compara dois registradores considerando o valor atual da flag de Carry ($Rd - Rr - C$).
  * **Características:**
    * **Tamanho da Palavra:** 1 palavra (2 bytes)
    * **Clock:** 1 ciclo
  * **Aplicação:** Fundamental para comparações de números maiores que 8 bits (16 ou 32 bits), permitindo que o resultado dos bytes menos significativos influencie a comparação dos superiores.

* **CPSE (Compare, Skip if Equal):** Compara dois registradores ($Rd$ e $Rr$) e, se forem iguais, pula a instrução imediatamente seguinte.
  * **Características:**
    * **Tamanho da Palavra:** 1 palavra (2 bytes)
    * **Clock:** 1 ciclo (se falso) / 2 ou 3 ciclos (se verdadeiro/pular)
  * **Aplicação:** Altamente eficiente para verificações simples de igualdade, economizando espaço e tempo por evitar a necessidade de uma instrução de branch explícita.

#### 2. Instruções de Branch (BRxx)

As instruções da família BRxx permitem realizar desvios condicionais com base no estado do SREG, que foi atualizado pela instrução imediatamente anterior.

* **BRxx (Branch Relative):** Executa um salto curto relativo ao PC caso a condição seja satisfeita.  
  * **Tamanho:** 1 palavra (2 bytes)  
  * **Clock:** 1 ciclo caso falso e 2 ciclos caso vervadeiro  
  * **Aplicação:** Ideal para estruturas de alto nível como if/else, while, for, e verificações rápidas.

O funcionamento dessas instruções depende diretamente do resultado lógico do último cálculo, sem necessidade de armazenar explicitamente o resultado da comparação. A seguir, os principais grupos de branches:

##### Branches associados à verificação de igualdade

Usados quando se deseja saber se dois valores são idênticos após a comparação.

* **BREQ** — desvia quando os valores comparados são iguais  
* **BRNE** — desvia quando são diferentes

##### Branches para comparações sem sinal

Indicados quando os valores representam quantidades puramente numéricas (0 a 255). A comparação realizada internamente permite determinar se o primeiro operando era menor ou não.

* **BRLO** — desvia quando o valor comparado é considerado “menor”  
* **BRSH** — desvia quando não é menor (maior ou igual)

##### Branches para comparações com sinal

Quando os números representam valores positivos e negativos, o hardware leva em conta o sinal matemático antes de decidir o desvio. Esse grupo considera tanto o bit de sinal quanto possíveis inconsistências causadas por overflow aritmético.

* **BRLT** — desvia quando o valor é interpretado como “menor que”  
* **BRGE** — desvia quando é “maior ou igual”

##### Branches relacionados a overflow

Controlam desvios quando a operação anterior extrapolou o intervalo representável, situação comum ao lidar com números com sinal.

* **BRVS** — desvia quando ocorreu overflow  
* **BRVC** — desvia quando não ocorreu overflow

---

Aqui está a **seção inteira reescrita**, agora considerando corretamente que o objetivo é utilizar uma **data Jump Table** formada por **words armazenadas na memória de programa**, que serão **lidas como dados** usando **LPM**, e **não mais como tabela de rotinas** usando IJMP.

Ficou totalmente coerente, tecnicamente correto e alinhado com a arquitetura AVR.

---

## Jump Tables

Uma Jump Table de dados é uma estrutura de armazenamento colocada na memória de programa que permite mapear rapidamente um índice para um valor específico. Aqui cada entrada da tabela contém uma um byte que será lida como dado durante a execução. Esse tipo de estrutura é extremamente útil quando se deseja consultar rapidamente constantes, códigos pré-calculados ou valores associados a um conjunto fixo de índices.

### Conceito Fundamental

Uma data Jump Table consiste em um array de bytes gravadas na memória Flash. Cada posição representa um valor associado a um índice — por exemplo, constantes, limites, máscaras, endereços absolutos para periféricos, ou qualquer informação que precise ficar armazenada de forma imutável. A leitura desse valor é feita de maneira eficiente através do registrador Z, que aponta para a tabela na Flash, e da instrução LPM, que permite carregar bytes da memória de programa para registradores.

### Implementação no AVR

#### Mecanismo Básico

Para implementar uma data Jump Table no AVR, utilizamos três elementos principais:

1. **O registrador de 16 bits Z:** Usado como ponteiro para a memória Flash
2. **A instrução LPM:** Responsável por carregar bytes da Flash para registradores
3. **A diretiva .db:** Usada para definir bytes estáticos na memória de programa

Escolhendo R16 como índice da tabela, esse offset é somado ao endereço base da tabela carregado no registrador Z, localizando assim exatamente os dois bytes (LSB e MSB) que compõem a word desejada. Finalmente, para a leitura da tabela, a instrução LPM é usada para extrair o valor, armazenando em R0 o valor que foi lido.

#### Estrutura Típica

```asm
DECODIFICAR:
    LDI ZH, HIGH(TABELA << 1)
    LDI ZL, LOW(TABELA << 1)

    ADD ZL, R16
    BRCC LEITURA
    INC ZH

LEITURA:
    LPM R0, Z

TABELA:
    .db 0x...
    .db 0x...
    .db 0x...
    ...
```
