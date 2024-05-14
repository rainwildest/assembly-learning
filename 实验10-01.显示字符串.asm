assume cs:codesg,ds:datasg

datasg segment
	       db 'Welcome to masm!',0
	;  db 00000010B         	;绿字
	;  db 00100100B         	;绿底红色
	;  db 01110001B         	;白底蓝字
datasg ends

codesg segment
	start:   mov  dh, 8           	; 行号（取值0~24）
	         mov  dl, 3           	; 列号（取值范围0~79）
	         mov  cl, 2           	; 颜色
	         mov  ax, datasg
	         mov  ds, ax
	         mov  si, 0

	         call show_str        	; 调用子程序
				 
	         mov  ax, 4c00H
	         int  21H


	show_str:
	         push ax
	         push bx
	         push cx
	         push es
	         push di

	         mov  ax, 0b800H
	         mov  es, ax

	         mov  ax, 0
	         mov  al, 160
	         mul  dh              	; 相乘后结果会放入 ax 中
	         mov  bx, ax          	; 处理行号

	         mov  ax, 0
	         mov  al, 2
	         mul  dl              	; 处理列
					 
	         add  bx, ax          	; 将行和列的积相加

	         mov  al, cl          	; 把颜色值给予 al
	         mov  di, 0

	display: 
	         mov  cx, 0
	         mov  cl, ds:[si]
	         jcxz done

	         mov  es:[bx+di], cl
	         mov  es:[bx+di+1], al
	         inc  si
	         add  di,2
	         jmp  short display

	done:    
	         pop  di
	         pop  es
	         pop  cx
	         pop  bx
	         pop  ax
	         ret                  	; pop IP

codesg ends

end start
