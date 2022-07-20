; Program przyk³adowy ilustruj¹cy operacje SSE procesora
; Poni¿szy podprogram jest przystosowany do wywo³ywania
; z poziomu jêzyka C (program arytmc_SSE.c)
.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat

public _pm_jeden

.data
jeden dd 1.0, 1.0, 1.0, 1.0

.code
_pm_jeden PROC
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]

	movdqu xmm0, [esi]
	movups xmm1, jeden
	addsubps xmm0, xmm1
	movdqu [esi], xmm0 


	pop ebp
	ret
_pm_jeden ENDP
END


