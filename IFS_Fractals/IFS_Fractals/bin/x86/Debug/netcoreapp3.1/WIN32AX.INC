		       format PE Console

entry start

include 'win32ax.inc'

start:
	xor	ecx, ecx
	xor	ebx, ebx	     
	mov	ecx, 17
	mov	edx, inputRepresent  

input:
	push	ebx		    
	push	ecx		    
	push	edx

	cinvoke system, <'cls'>     

	push	inputRepresent
	push	inputLine

	call	[printf]
	call	[getch]

	add	esp, 8		    

	pop	edx		    
	pop	ecx
	pop	ebx

	cmp	al, 08h 	    
	je	clearLastChar	    

	cmp	al, 1Bh 	    
	je	finishProg	    

	cmp	al, 0Dh 	   
	je	finishInput

	push	eax
	mov	[edx], al
	inc	edx
       

	and	al, 0Fh 	    
	shl	bx, 1
	or	bl, al		    

	loop	input

    
	call	[getch]
    
	jmp	finishProg

	clearLastChar:
	cmp	  cx, 6        
	je	  input

	inc	  cx
	shr	  bx, 1
	add	  esp, 2

	dec	  edx
	mov	  byte [edx], 0h    

	jmp	  input

finishInput:
	cmp	  cx, 17
	je	  input


       call	 toBinary
       push	 binNumb
       push	 binRep
       call	 [printf]


	call	  toOctal
	push	  octNumb
	push	  octRep
	call	  [printf]


	call	  toHex
	push	  hexNumb
	push	  hexRep
	call	  [printf]

	call	  toDecimal
	push	  decNumb
	push	  decRep
	call	  [printf]

finishProg:
	push	  closeMsg
	call	  [printf]

	call	  [getch]

	push	  0
	call	  [ExitProcess]



toBinary:


	mov	cl, 0
	mov	edx, binNumb
   convbin:
	mov	ax, bx
	shl	ax, cl
	shr	ax,  15
	add	ax, 30h
	mov	[edx], al

	add	cl, 1
	inc	edx

	cmp	cl, 16
	jne	convbin

	ret

toOctal:
	mov	cl, 1
	mov	edx, octNumb

    convOctalSymbol:
	xor	eax, eax

	mov	ax, bx
	shl	ax, cl
	shr	ax, 13
	add	ax, 30h
	mov	[edx], al

	add	cl, 3
	inc	edx


	cmp	cl,16
	jne	convOctalSymbol

	ret


toHex:
	mov	cl, 0
	mov	edx, hexNumb

    convHexSymbol:
	xor	eax, eax

	mov	ax, bx
	shl	ax, cl
	shr	ax, 12

	cmp	al, 9h
	jle	writeNumb

	cmp	al, 0Fh
	jle	writeLetter

    returnPoint:
	mov	[edx], al

	add	cl, 4
	inc	edx

	cmp	cl, 16
	jne	convHexSymbol

	ret

    writeNumb:
	    add     ax, 30h
	    jmp     returnPoint
    writeLetter:
	    add     ax, 37h
	    jmp     returnPoint

 toDecimal:

	mov ax,[ebx]
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

	ret

section '.data' data readable writable

inputRepresent rb 13

decNumb rb 5 + 1
binNumb rb 16 + 1
octNumb rb 3 + 1
hexNumb rb 4 + 1

inputLine db 'Podaj liczbe binarnie: %s', 0

binRep db 10, 10, 13,'[bin] = %s', 0
octRep db 10, 13,'[oct] = %s', 0
decRep db 10, 13,'[dec] = %s', 0
hexRep db 10, 13,'[hex] = %s', 0

closeMsg db 10, 10, 13,'Program has been finished.', 0

section '.idata' import data readable

	library kernel, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'

	import kernel, \
	       ExitProcess, 'ExitProcess'

	import msvcrt, \
	       printf, 'printf', \
	       scanf, 'scanf', \
	       getch, '_getch',\
	       system,'system'
