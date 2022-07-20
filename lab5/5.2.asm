.686
.model flat
public _nowyExp
.data
	
	jeden dd 1.0
	x dd 0.0
	zmienna dd 0

.code

_nowyExp PROC

	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP

	mov ebx, [ebp + 8]
	mov x, ebx

	finit
	fld jeden
	mov ecx, 18
mainLoop:
	; w st(0) jest wartosc poprzedniego wyrazu w ciagu

	mov edx, 20
	sub edx, ecx ; w edx jest numer wyrazu
	push ecx

; petla do obliczenia dolnego wyrazu
	fld jeden
	mov ecx, edx
loopDiv:
	mov zmienna, ecx
	fild zmienna
	fmulp st(1), st(0)
	loop loopDiv



; petla do obliczania gornego wyrazu
	mov ecx, edx
	dec ecx
	fld x
loopExp:
	fld x
	fmulp st(1), st(0)
	loop loopExp
	pop ecx
; st(0) exp st(1) div

	fxch 
	fdivp st(1), st(0)
	faddp st(1), st(0)

	loop mainLoop

	fld x
	faddp st(1), st(0)
	
	pop ebp
	ret

_nowyExp ENDP
END



