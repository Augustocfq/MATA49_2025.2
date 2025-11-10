;
; 7-Relogio9Seg.asm
;
; Created: 11/7/2025 10:13:14 AM
; Author : pedro
; Código 7 


; O objetivo deste código é implementar um relógio que conta 9 segundos, conforme o circuito do simulide.
; Como o circuito utiliza um 7displaysegment, precisaremos utilizar a códificação BCD, que utiliza 7 bits.
;
; Revisão: o código BCD serve para indicar quais segmentos do display devem ser ativados para formar um número.
; Exemplo) 1 = 0110000, 2 = 1101101, 3 = 1111001, 4 = 0110011, 5 = 1011011 ...  (recomendo tentar escrever os próximos números utilizando o 7SegDisplay
; como referência).

; Exemplo)  4 = 0110011		   a         
;				abcdefg		f|    |b
;							 |_g__|
;							e     |c
;							   d  |
				

INICIO:
	
	LDI R16, 0xFF
	OUT DDRD, R16
	LDI R16, 0b01111110
	OUT PORTD, R16 ; Como o circuito está configurado PD0 = g, PD1 = f, PD2 = e, PD3 = d, ..., PD6 = a, vou preencher o último pino sempre
; com 0 por preferência estética, pois esse pino sequer será utiliazdo.
; OBS: a ordem do código BCD não é implementado sempre desse jeito, depende da forma que o display foi ligado na porta. Se invertemos a ordem,
; o exemplo 4 ficaria 1100110 = gfedcba
	RJMP ATRASO
;_________________
;Sobre a lógica: (1º) Buscar a codificação BCD do próximo número a ser exibido (2º) Exibir o código (3º) Chamar uma rotina de atraso para manter o número durante 1 segundo aproximado.
; (4º) repetir tudo de novo.

; Sobre (1º): para buscar a codifição, será utilizado uma estrutura parecida com o switch-case do java, que na verdade é um if/else mais legível.
;		(2º): o bloco responsável por exibir os números vão ser implementados dentro da rotina de atraso e será atualizado 60 vezes por segundo. Explicação no fim do código. 
SWITCH:
		CPI R16, 0b01111110
		BREQ CASE_0

		CPI R16, 0b00110000
		BREQ CASE_1

		CPI R16, 0b01101101
		BREQ CASE_2

		CPI R16, 0b01111001
		BREQ CASE_3

		CPI R16, 0b00110011
		BREQ CASE_4

		CPI R16, 0b01011011
		BREQ CASE_5

		CPI R16, 0b01011111
		BREQ CASE_6

		CPI R16, 0b01110010
		BREQ CASE_7

		CPI R16, 0b01111111
		BREQ CASE_8

		CPI R16, 0b01111011
		BREQ CASE_9

THEN:
	
	CASE_0:
		LDI R16, 0b00110000	; Como o switch/case só é chamado para pegar o próximo número, esses blocos vão carregar o próximo código BCD
		RJMP VOLTA
	CASE_1:
		LDI R16, 0b01101101
		RJMP VOLTA
	CASE_2:
		LDI R16, 0b01111001
		RJMP VOLTA
	CASE_3:
		LDI R16, 0b00110011
		RJMP VOLTA
	CASE_4:
		LDI R16, 0b01011011
		RJMP VOLTA
	CASE_5:
		LDI R16, 0b01011111
		RJMP VOLTA
	CASE_6:
		LDI R16, 0b01110010
		RJMP VOLTA
	CASE_7:
		LDI R16, 0b01111111
		RJMP VOLTA
	CASE_8:
		LDI R16, 0b01111011
		RJMP VOLTA		
	CASE_9:
		LDI R16, 0b01111110
		RJMP VOLTA	



ATRASO:
	LDI R17, 40
L1:	LDI R18, 5
L2:	LDI R19, 100
L3:	LDI R20, 200
	
L4: DEC R20
	NOP
	BRNE L4

	DEC R19
	BRNE L3

	DEC R18
	BRNE L2
	
	DEC R17
	BRNE L1
	
	RJMP SWITCH

VOLTA:
	OUT PORTD, R16

	RJMP ATRASO
	
	






; No futuro, será necessário trabalhar com 2 telas conectadas na mesma porta e cada tela deve exibir um número diferente da outra. Dessa forma, mesmo que seja apenas uma tela,
; vou implementar como se tivesse usando mais de uma para já discutir um pouco sobre taxa de atualização.