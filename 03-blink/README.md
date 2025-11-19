# Blink

## Obejetivo

Acender um LED durante um segundo e manter-lo apagado durante um segundo em loop

## Circuito

![Circuito blink](https://github.com/user-attachments/assets/d13af650-04ad-4bff-a884-9e9870b1d953)

## Estratégia

Primeiramente, iremos definir o DDRD para 0b11111111, para que todos os pinos de PORTD estejam na direção de output e também definir PORTD para 0b00000000, para garantir que todos os pinos comecem desligados.

```asm
INICIO:
    LDI R16, 0b11111111
    OUT DDRD, R16
    LDI R16, 0b00000000
    OUT PORTD, R16
```

Para a nossa rotina principal, iremos primeiramente utilizar a intrução SBI (Set Bit I/O) em (PORTD, PD0) para mudar o valor de PORTD de 0b00000000 para 0b00000001, ligando o LED ligado ao pino D0. Após isso, chamaremos uma rotina de atraso e depois utilizaremos a instrução CBI (Clear Bit I/O) em (PORTD, PD0) para mudar o valor de PORTD de 0b00000001 para 0b00000000 novamente. Por fim, utilizaremos a instrução RJMP na label PRINCIPAL para voltarmos ao início da rotina.

```asm
PRINCIPAL:
    SBI PORTD, PD0
    CALL ATRASO
    CBI PORTD, PD0
    CALL ATRASO
    RJMP PRINCIPAL
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
