;
; BotaoLed.asm
;
; Created: 11/5/2025 11:18:19 PM
; Author : pedro
; Código 4

;O objetivo desse código é contar de 0 até 9 usando o 7 segment BCD presente no Simulide na aba Logic/Other Logic. 
;Será implementado nesse código instruções de branch (if/else)

INICIO:
	
	LDI R16, 0xFF
	OUT DDRD, R16

ZERARR16:	LDI R16, 0x00

PRINCIPAL:
	
	OUT PORTD, R16
	INC R16
	RCALL ATRASO

	CPI R16, 10 ; Essa função compara o registrador com o valor 10.
	BREQ ZERARR16 ; Se a comparação indicar que r16 == 10, então o código pula para L1: que zera o registrador antes que ele seja exibido no display.
	
	RJMP PRINCIPAL
;Exercício: modifique o código para contar até 13 e verifique o número exibido no display.
ATRASO:
	
	LDI R17, 78
L1:	LDI R18, 255
L2:	LDI R19, 255
L3:	DEC R19
	BRNE L3

	DEC R18
	BRNE L2

	DEC R17
	BRNE L1

	RET