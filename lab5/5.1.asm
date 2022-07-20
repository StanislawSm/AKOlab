.686
.model flat
public _sredniaHarm
.data
	wsp_a dd +2.0
	wsp_b dd -1.0
	wsp_c dd -15.0
	dwa dd 2.0
	cztery dd 4.0
	jeden dd 1.0
	zero dd 0.0
	n dd 0.0
	x2 dd ?

.code

_sredniaHarm PROC

	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP

	mov ebx, [ebp + 8]
	mov ecx, [ebp + 12]
	mov eax, 0
	finit
	fld zero

mainLoop:
	
	fld jeden
	fld dword PTR [ebx + 4 * eax]
	inc eax
	fdivp st(1), st(0)
	faddp st(1), st(0)
	loop mainLoop

	mov ecx, [ebp + 12] 
	mov n, ecx
	fild n
	fdiv st(0), st(1)

	pop ebp
	ret

_sredniaHarm ENDP
END



