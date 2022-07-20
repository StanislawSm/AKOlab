.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat
public _dylatacja_czasu
public _szybki_max

.data
jeden dd 1.0
v dd ?
dt0 dd ?
vc dd 300000000.0

.code

_dylatacja_czasu PROC

	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push eax

	mov eax, [ebp + 8] ; dt0
	mov dt0, eax
	mov eax, [ebp + 12] ; v
	mov v, eax
; zmienne do dzia³ania s¹ zapisane w pamiêci
	finit
	fld v
	fld v
	fmulp st(1), st(0)
	
	fld vc
	fld vc
	fmulp st(1), st(0)

	fdivp st(1), st(0)
	
	fld jeden
	fsub st(0), st(1)
	
	fxch st(1)
	fstp st(0)

	fsqrt

	fild dt0
	fdiv st(0), st(1)

	fxch st(1)
	fstp st(0)

	pop eax
	pop ebp
	ret

_dylatacja_czasu ENDP

_szybki_max PROC
	push ebp
	mov ebp,esp
	push eax
	push ebx

	mov eax, [ebp + 8] ; t1
	mov ebx, [ebp + 12] ; t2

	movdqu xmm0, [eax]
	movdqu xmm1, [ebx]

	PMAXSB xmm0, xmm1

	pop ebx
	pop eax
	pop ebp
	ret

_szybki_max ENDP

END


