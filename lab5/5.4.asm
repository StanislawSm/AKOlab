; Program przyk³adowy ilustruj¹cy operacje SSE procesora
; Poni¿szy podprogram jest przystosowany do wywo³ywania
; z poziomu jêzyka C (program arytmc_SSE.c)
.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat

public _int2float

.data
integers xmmword ?
floats xmmword ?

.code


_int2float PROC
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]

	cvtpi2ps xmm5, qword PTR [esi]
	movdqu  [edi], xmm5

	pop ebp
	ret
_int2float ENDP


END


