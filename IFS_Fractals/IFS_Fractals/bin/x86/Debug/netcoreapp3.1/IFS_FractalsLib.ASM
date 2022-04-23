format PE GUI 4.0 DLL

include 'win32a.inc'

section '.text' code readable executable

square:

	finit
     ;	 push eax
     ;	 mov  eax, [esp + 8]
     ;	 fld qword [eax]
    ;	 mov  eax, [esp + 8]
     ;	 fld qword [eax]
     ;	 fld qword [eax]



	mov  eax, [esp + 4]
	fld qword [eax]
	mov  eax, [esp + 4]
	fld qword [eax]
      ;  fld qword [eax]

	fmulp

	mov  eax, [esp + 8]
	fld qword [eax]
	mov  eax, [esp + 8]
	fld qword [eax]
     ;	 fld qword [eax]


	fmulp
	fsubp

	fstp qword[temp]

	fld [a]
	mov  eax, [esp + 4]
	fld qword [eax]
	mov  eax, [esp + 8]
	fld qword [eax]

	fmulp
	fmulp

	mov eax, [esp + 8]
	fstp qword[eax]

	fld [temp]
	mov eax, [esp + 4]
	fstp qword[eax]

	mov eax, [esp]
	add esp, 8
	mov [esp], eax

	ret

add_dod:


      ;  push eax
	mov  eax, [esp + 4]
	fld qword [eax]
	mov  eax, [esp + 8]
	fld qword [eax]

	mov eax, [esp + 4]

	faddp
	fstp qword[eax]

	mov  eax, [esp + 12]
	fld qword [eax]
	mov  eax, [esp + 16]
	fld qword [eax]

	mov eax, [esp + 12]

	faddp
	fstp qword[eax]

      ;  mov eax, [esp]
      ;  add esp, 16
      ;  mov [esp], eax

	ret


magnitude:


     ;	 push eax

	fld qword [esp + 12]
	fld qword [esp + 12]

	fmulp

	fld qword [esp + 4]
	fld qword [esp + 4]

	fmulp
	faddp
	fsqrt

	mov eax, [esp + 20]
	fstp qword[eax]

      ;  mov eax, [esp]
      ;  add esp, 16
      ;  mov [esp], eax

	ret



section '.data' data readable writeable

	temp dq 0



	a dq 2.0




section '.idata' import data readable writeable

 library kernel, 'kernel32.dll',\
	 msvcrt, 'msvcrt.dll',\
	 user32, 'USER32.DLL'

	import kernel, \
	       ExitProcess, 'ExitProcess'

	import msvcrt, \
	       printf, 'printf', \
	       scanf, 'scanf', \
	       getch, '_getch',\
	       system,'system'

	import user32,\
	       MessageBoxA,'MessageBoxA'




section '.edata' export data readable

	export 'IFS_FractalsLib.DLL',\
	       square, 'square',\
	       add_dod, 'add_dod',\
	       magnitude, 'magnitude'



section '.reloc' fixups data readable discardable
