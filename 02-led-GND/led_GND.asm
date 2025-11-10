;
; 1.1-LigarLedNEG.asm
;
; Created: 11/5/2025 9:44:48 PM
; Author : pedro
; Código 1.1 (implementação)


INICIO:
	
	LDI R16, 0xFF
	OUT DDRD, R16

	LDI R16, 0b11111110 ; Diferente do primeiro código, o LED será ligado quando o pino tiver valor 0. Isso ocorre pois o circuito não é o mesmo.
;No código anterior (1-LigarLed), o pino PD0 era responsável por fornecer corrente positiva para o LED. 
;Já nesse novo circuito, o pino deve funcionar como TERRA (voltagem 0V) para que a LED acenda, pois o LED já está conectado numa fonte com 5V.
	OUT PORTD, R16

;Exercício: No simulide, conecte dois LEDs, um em PD3 da mesma forma que foi conectado o LED de PB0 
;e outro em PB7 da forma que foi implementado no primeiro circuito. Compare o comportamento dos novos LEDs e explique seu funcionamento.


