
;By³o jedno zadanie - na inpucie 2 liczby w systemie dwunastkowym (<= BB) i wyœwietliæ ich iloraz w dziesiêtnym z dok³adnoœci¹ do 3 miejsc po przecinku


.686 
.model flat 
extern __write : PROC 
extern __read : PROC
extern _ExitProcess@4 : PROC 
public _main 


.data 

;wyswietl_EAX
znaki   db 12 dup (?)

;wczytaj_do_EAX
obszar db 12 dup (?) 
osiem   dd 8 ; mno¿nik 

;main
num1 dd 0
num2 dd 0
result dd 0
sign db '-', 0


.code 

wczytaj_do_EAX_oct PROC

	push ebx
	push ecx

	
	; wczytywanie liczby dziesiêtnej z klawiatury – po 
	; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter 
 
	; liczba po konwersji na postaæ binarn¹ zostaje wpisana 
	; do rejestru EAX 
	; max iloœæ znaków wczytywanej liczby 
	push  dword PTR 12 
  
	push  dword PTR OFFSET obszar  ; adres obszaru pamiêci 
	push  dword PTR 0; numer urz¹dzenia (0 dla klawiatury) 
	call  __read ; odczytywanie znaków z klawiatury 
		; (dwa znaki podkreœlenia przed read) 
	add   esp, 12 ; usuniêcie parametrów ze stosu 
 
 
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest 
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹ 
	mov ebp, 0
	mov   eax, 0   
	mov   ebx, OFFSET obszar  ; adres obszaru ze znakami 
 
pobieraj_znaki: 
	mov   cl, [ebx] ; pobranie kolejnej cyfry
	inc   ebx   ; zwiêkszenie indeksu 
	cmp   cl,10 ; sprawdzenie czy naciœniêto Enter 
	je  byl_enter ; skok, gdy naciœniêto Enter 
	cmp cl, '-'
	je minus
	jmp wasDigit
minus:
	mov ebp, 1 ;edx jest flag¹ ze znakiem
	jmp pobieraj_znaki

wasDigit:
	sub   cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry 
save:
	movzx ecx, cl ; przechowanie wartoœci cyfry w 
	; rejestrze ECX 
 
	 ; mno¿enie wczeœniej obliczonej wartoœci razy 10 
	mul   dword PTR osiem         
	add   eax, ecx  ; dodanie ostatnio odczytanej cyfry 
	jmp   pobieraj_znaki ; skok na pocz¹tek pêtli 
 
byl_enter:
	cmp ebp, 1
	jne koniec
	neg eax 

koniec:
	; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX 

	pop ecx
	pop ebx

	ret
wczytaj_do_EAX_oct ENDP
 
wyswietl_EAX PROC 
	pusha
 
	bt	eax, 31
	jnc dalej
	neg eax
	
	pusha
	push  1 ; liczba wyœwietlanych znaków 
	push  dword PTR OFFSET sign ; adres wyœw. obszaru 
	push  dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call  __write  ; wyœwietlenie liczby na ekranie
	add esp, 12
	popa



	
dalej:	
	mov   esi, 10  ; indeks w tablicy 'znaki' 
	mov   ebx, 10  ; dzielnik równy 10 
 
konwersja: 
	mov   edx, 0 ; zerowanie starszej czêœci dzielnej 
	div   ebx   ; dzielenie przez 10, reszta w EDX, iloraz w EAX 
	add   dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	mov   znaki [esi], dl; zapisanie cyfry w kodzie ASCII 
	dec   esi    ; zmniejszenie indeksu 
	cmp   eax, 0  ; sprawdzenie czy iloraz = 0 
	jne   konwersja  ; skok, gdy iloraz niezerowy 
 
; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 
wypeln: 
	or  esi, esi 
	jz  wyswietl   ; skok, gdy ESI = 0 
	mov   byte PTR znaki [esi], 0 ; kod spacji 
	dec   esi    ; zmniejszenie indeksu 
	jmp   wypeln 
  
wyswietl: 
	mov   byte PTR znaki [0], 0 ; kod nowego wiersza 
	mov   byte PTR znaki [11], 0 ; kod nowego wiersza 
 
	; wyœwietlenie cyfr na ekranie 
	push  dword PTR 12 ; liczba wyœwietlanych znaków 
	push  dword PTR OFFSET znaki ; adres wyœw. obszaru 
	push  dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call  __write  ; wyœwietlenie liczby na ekranie 
	add   esp, 12  ; usuniêcie parametrów ze stosu
	popa
	ret 
wyswietl_EAX ENDP 

 
_main PROC 
;czytanie
	call wczytaj_do_EAX_oct
	mov num1, eax
	call wczytaj_do_EAX_oct
	mov num2, eax
	
	mov eax, num1
	mov ebx, num2
	add eax, ebx

	call wyswietl_EAX	

    push 0 
    call _ExitProcess@4 
_main ENDP 
END