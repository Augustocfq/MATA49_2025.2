;
; LigarBotao.asm
;
; Created: 11/5/2025 8:17:10 PM
; Author : Pedro Dias
;


.org 0x000
; Recomendo que o estudo do código seja realizado acompanhado pelo Instruction Set Summary, presente no Atmega328P Datasheet (primeiro link no google).
; Focarei a explicação na lógica do código e funcionamento do atmega328p.


INICIO:
	
	LDI R16, 0xFF
	OUT DDRD, R16 
	LDI R16, 0x00
	OUT PORTD, R16

PRINCIPAL:

; Analise o circuito do simulide para entender a próxima explicação.

	SBI PORTD, PD0 ; Essa linha ativa o LED aterrado passando uma voltagem 5V para o pino PD0 (pino zero do PORTD).
	RCALL ATRASO	; Chamda de rotina de atraso ( aproximadamente 200ms). Será explicado futuramente como calcular o tempo da rotina.

	CBI PORTD, PD0 ; Faz o contrário de SBI. Assim, atribui valor zero para PD0 (Desliga o LED).
	RCALL ATRASO

	RJMP PRINCIPAL  ; Entra em loop.

; Exercício: No simulide, conecte um novo LED em PD7 da mesma forma que o LED de PD0 e o faça piscar de maneira alternada ao LED de PB0. (Ou seja, PD0 = 1 ==> PD7 = 0)
; Restrições: Não altere o tempo total para piscar os LEDs.

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

