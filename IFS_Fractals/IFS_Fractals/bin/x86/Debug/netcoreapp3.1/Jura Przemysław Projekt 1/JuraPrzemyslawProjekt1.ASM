format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.text' code readable executable

start:

	clrscr
	wyswietl txt6
	ustaw_kursor 5,0
	wyswietl txt5
	wyswietl txt7
	wyswietl txt8
	ustaw_kursor 6,15
	mov cx, 0
 
wprowadzanie:
	pob_znak
	cmp al, 27	      ;ESC
	je koniec
	cmp cx, 0
	je wprowadzanie_zakres1
	cmp al, 13	      ;ENTER
	je ciag_dalszy

	cmp al, 8		   ;BACKSPACE
	jne wprowadzanie_zakres

	cmp cx, 0
	je wprowadzanie
 
	wysw_znak 8
	wysw_znak ' '
	wysw_znak 8
	shr [zm1], 3
 
	sub cx, 1
 
	jmp wprowadzanie

wprowadzanie_zakres1:

	cmp al, '0'
	jb wprowadzanie
	cmp al, '0'
	je znak1
	cmp al, '1'
	je znak2
	jmp wprowadzanie

znak1:
	wysw_znak al
	mov [zm2], 0
	add cx, 1
	jmp wprowadzanie

znak2:
	wysw_znak al
	mov [zm2], 1
	add cx, 1
	jmp wprowadzanie


wprowadzanie_zakres:
	cmp cx, 5
	je wprowadzanie

	cmp al, '0'
	jb wprowadzanie
	cmp al, '7'
	jbe wprowadzam_liczbe

	jmp wprowadzanie
 
wprowadzam_liczbe:
	wysw_znak al
	shl [zm1], 3
 
	sub ax, 48
	jmp wprowadzanie_dodawanie

wprowadzanie_dodawanie:
	add [zm1], ax
	add cx, 1
	jmp wprowadzanie
 
ciag_dalszy:
	wysw_znak 13
	wysw_znak 10


wysw_bin:
	ustaw_kursor 1,0
	wyswietl txt1

	cmp [zm2], 0
	je wysznak1
	cmp [zm2], 1
	je wysznak2

wysznak1:
	wysw_znak '0'
	jmp wysw_bin1
wysznak2:
	wysw_znak '1'
	jmp wysw_bin1


wysw_bin1:
	mov bx,[zm1]
	rcl bx,1
	mov ecx,15
ety1:

	push ecx
	rcl bx,1
	jc ety2
	mov dl,'0'
	jmp ety3


ety2:
	mov dl,'1'
ety3:
	wysw_znak dl
	pop ecx
	loop ety1

wysw_oct:
	wyswietl txt2

	cmp [zm2], 0
	je wysznak1oct
	cmp [zm2], 1
	je wysznak2oct

wysznak1oct:
	wysw_znak '0'
	jmp wysw_oct1
wysznak2oct:
	wysw_znak '1'
	jmp wysw_oct1

wysw_oct1:

	mov ax,[zm1]
	shl ax,1
	shr ax,13
	add ax,30h
	wysw_znak al

	mov ax,[zm1]
	shl ax,4
	shr ax,13
	add ax,30h
	wysw_znak al

	mov ax,[zm1]
	shl ax,7
	shr ax,13
	add ax,30h
	wysw_znak al

	mov ax,[zm1]
	shl ax,10
	shr ax,13
	add ax,30h
	wysw_znak al

	mov ax,[zm1]
	and ax,7
	add ax,30h
	wysw_znak al


wysw_dec:
	wyswietl txt3

	cmp [zm2], 0
	je wysznak1dec
	cmp [zm2], 1
	je wysznak2dec

wysznak1dec:
	wysw_znak '+'
	jmp wysw_dec1
wysznak2dec:
	wysw_znak '-'
	jmp wysw_dec1


wysw_dec1:
	mov ax,[zm1]
	mov dx,0
	mov cx,10
	div cx

	add dx,30h
	push edx

	mov dx,0
	div cx
	add dx,30h
	push edx

	mov dx,0
	div cx
	add dx,30h
	push edx

	mov dx,0
	div cx
	add dx,30h
	push edx

	mov dx,0
	div cx
	add dx,30h
	push edx

	pop edx
	wysw_znak dl
	pop edx
	wysw_znak dl
	pop edx
	wysw_znak dl
	pop edx
	wysw_znak dl
	pop edx
	wysw_znak dl
	pop edx

wysw_hex:
	wyswietl txt4


	cmp [zm2], 0
	je wysznak1hex
	cmp [zm2], 1
	je wysznak2hex

wysznak1hex:
	wysw_znak '0'
	jmp wysw_hex1
wysznak2hex:
	wysw_znak '1'
	jmp wysw_hex1



wysw_hex1:

	mov ax,[zm1]
	shl ax,4
	shr ax,12
	cmp ax,10
	jb ety6
	add ax,55
	jmp ety7
ety6:
	add al,30h
ety7:
	wysw_znak al

	mov ax,[zm1]
	shl ax,8
	shr ax,12
	cmp ax,10
	jb ety8
	add ax,55
	jmp ety9
ety8:
	add al,30h
ety9:
	wysw_znak al

	mov ax,[zm1]
	shl ax,12
	shr ax,12
	cmp ax,10
	jb ety10
	add ax,55
	jmp ety11
ety10:
	add al,30h
ety11:
	wysw_znak al

petla:
	ustaw_kursor 6,20
	pob_znak
	cmp al, 27
	je koniec
	mov [zm1],0
	jmp start

koniec:

	end_prog

section '.data' data readable writeable
	txt1 db 13,10,'wartosc BIN: ',NULL
	txt2 db 13,10,'wartosc OCT: ',NULL
	txt3 db 13,10,'wartosc DEC: ',NULL
	txt4 db 13,10,'wartosc HEX: ',NULL
	txt6 db 'e. osemkowy (znak, modul)',NULL
	txt5 db 13,10,'Linia polecen: ',NULL
	txt7 db 13,10,'Pierwszy liczba to znak: 1 to liczba ujemna, a 0 to liczba dodatnia',NULL
	txt8 db 13,10,'[ESC]-koniec, [ENTER]-zatwierdzenie, [BACKSPACE]-cofnij',NULL
	zm1  dw 0
	zm2  db 0