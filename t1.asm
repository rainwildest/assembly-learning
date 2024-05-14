assume cs:codesg,ds:datasg

datasg segment
	       db 'Welcome to masm!'
	;  db 00000010B         	;绿字
	;  db 00100100B         	;绿底红色
	;  db 01110001B         	;白底蓝字
datasg ends

codesg segment
	start:   mov  dh, 8     	;行号（取值0~24）
	         mov  dl, 3     	;列号（取值范围0~79）
	         mov  cl, 2     	;颜色
	         mov  ax, datasg
	         mov  ds, ax
	         mov  si, 0
				 
	         mov  ax, 4c00H
	         int  21H


	show_str:push ax
	         push bx
	         push cx

	         mov  ax, 0
	         mov  al, 160
	         mul  dh
	         mov  bx, ax

	         mov  ax, 0
	         mov  al, 2
	         mul  dl
					 
	         add  bx, ax

	         pop  cx
	         pop  bx
	         pop  ax
	         ret

	
	; ========
	;  mov ax, 0
	;  mov al, 160
	;  mul dh
	;  mov bx, ax
	;  =======
	     
codesg ends

end start