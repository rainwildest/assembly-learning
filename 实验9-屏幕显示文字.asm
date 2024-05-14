assume cs:codesg,ds:datasg

datasg segment
	       db 'welcome to masm!'
	       db 00000010B         	;绿字
	       db 00100100B         	;绿底红色
	       db 01110001B         	;白底蓝字
datasg ends

codesg segment
	start: mov  ax, datasg
	       mov  ds, ax

	       mov  ax, 0b800H
	       mov  es, ax

	       mov  bx, 16

	;mov  bp, 280H
	       mov  bp, 160*10 + 32*2
	       mov  di, 0
	       mov  si, 0

	       mov  cx, 3
	color: push cx

	       mov  cx, 16
	       mov  di, 0
	       mov  si, 0
	chars: mov  al, ds:[di]      	;文字
	       mov  ah, ds:[bx]      	;颜色
	       mov  es:[bp + si], ax

	       inc  di
	       add  si,2
	       loop chars

	       add  bp, 160
	       pop  cx
	       inc  bx

	       loop color

	       mov  ax, 4c00H
	       int  21H
codesg ends

end start