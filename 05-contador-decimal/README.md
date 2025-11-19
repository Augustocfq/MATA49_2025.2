# Contador decimal de 7 segmentos

## Obejetivo

Contar de 0 à 9 em um display de 7 segmentos

## Circuito

![Circuito contador](https://github.com/user-attachments/assets/0b3f522a-9b5c-44e0-bab6-b4e2e915b9f3)

## Estratégia

Primeiramente, iremos definir o DDRB para 0b11111111, para que todos os pinos de PORTB estejam na direção de output e limpar o registrador R16, que será utilizado como o contador principal.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRB, R16
    LDI R16, 0b00000000
```

Para a nossa rotina principal, iremos primeiramente chamar a rotina decodificação do número armazenado em R16 para logo em seguida realizar o output em PORTB do código BCD armazenado em R0. Após isso as rotinas de atraso e incrementar são chamadas e por fim RJMP é utilizado para manter a rotina em loop.

```asm
PRINCIPAL:
    CALL DECODIFICAR
    OUT PORTB, R0
    CALL ATRASO
    CALL INCREMENTAR
    RJMP PRINCIPAL
```

Para a rotina de decodificação é utilizada uma jump table de dados com os códigos BCD armazenados em binário

```asm
DECODIFICAR:
    LDI ZH, HIGH(TABELA << 1)
    LDI ZL, LOW(TABELA << 1)
    ADD ZL, R16
    BRCC LEITURA
    INC ZH
    LEITURA:
        LPM R0, Z
    RET

TABELA: 
    .db 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
```

Para implementar a rotina de atraso utilizaremos a informação de que o µC ATmega328P opera a 16 MHz, ou seja, para gerarmos um atraso próximo de 1 s precisamos ocupar cerca de 16.000.000 ciclos de clock. Para isso utilizamos a instrução `DEC Rx`, que decrementa um registrador em 1 ciclo de clock, e o desvio condicional `BRNE Lx`, que retorna ao rótulo enquanto o registrador ainda não for zero, consumindo 2 ciclos de clock quando o salto ocorre. Com a escolha dos valores iniciais `R17 = 82`, `R18 = 255` e `R19 = 255`, formamos três laços aninhados cuja execução completa acumula aproximadamente 15.996.150 (`255 * 255 * 82 * 3`) ciclos de clock, produzindo assim um atraso de aproximadamente 1 segundo.

```asm
ATRASO:
    LDI R17, 82 
    L17:
        LDI R18, 255
    L18:
        LDI R19, 255
    L19:
        DEC R19
        BRNE L19
        DEC R18
        BRNE L18
        DEC R17
        BRNE L17
    RET 
```

(**Observação:** `BRNE Lx`, nesse caso, não precisa de uma instrução como `CPI Rx, 0` antes pois ele, como dito na introdução, verifica sempre a Flag Z do SREG, então ele voltará para Lx sempre que o decremento não resultou em 0.)

Para implementar a rotina de incrementar R16, iremos primeiramente verificar se ele já está em seu valor limite, se sim, a rotina de zerar R16 será utilizada, se não, R16 será incrementado m 1.

```asm
INCREMENTAR:
    CPI R16, 15
    BREQ ZERAR
        INC R16
        RET
    ZERAR:
        LDI R16, 0
        RET
```
