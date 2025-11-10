;
; ContadorBinario.asm
;
; Created: 11/5/2025 10:24:07 PM
; Author : pedro
; Código 3

;O objetivo desse código é contar de 0 até 15 em binário usando LEDs associados a porta D.

INICIO:
	
	LDI R16, 0xFF
	OUT DDRD, R16

	LDI R16, 0b00000000 ; R16 será o registrador responsável por contar e registrar o número que deve sair.
;Assim, a ideia é começar com 0 e ir incrementando de um em um até 15.

PRINCIPAL:

	OUT PORTD, R16
	INC R16 ; O incremento mencionado à cima.
	RCALL ATRASO

	RJMP PRINCIPAL
;Note que, após ultrapassar 15 (00001111) as LEDs apagam. Isso ocorre, pois 0b00001111 + 0b1 = 0b00010000. Dessa forma, os LEDs ligados a PD 0-3
;são zerados, mas o registrador continua contando até atingir o valor 0b11111111. Para verificar isso, adicione mais LEDs no restante dos pinos da porta D.
;OBS: 0b11111111 + 0b1 = 0b00000000 (Overflow) e 0b00000000 -0b1 = 0b11111111 (Underflow).

;Exercício: No simulide, conecte outros 4 LEDs em pinos da porta B e os faça contar de 15 até 0 alterando esse código.(OBS: os LEDs da porta D devem
; continuar a contagem normalmente). Dica: Lembre-se que os registradores r17 até r19 estão sendo utilizados na rotina de atraso. 
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