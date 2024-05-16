assume cs:codesg

codesg segment
	start: mov  ax, 4240H	; 被除数的低16位
	       mov  dx, 000FH	; 被除数的高16位
	       mov  cx, 0AH  	; 除数

	       call divdw    	; 调用子程序
				 
	       mov  ax, 4c00H
	       int  21H


	divdw: 
	; X: 被除数，范围: [0,FFFFFFFF]
	; N: 除数, 范围: [0,FFFF]
	; H: X高16位，范围: [0,FFFF]
	; L: X低16位，范围: [0,FFFF]
	; int(): 描述性运算符，取商，比如 int(38/10)=3
	; rem(): 描述性运算符，取余数，比如 rem(38/10)=8
	; 公式: X/N = int(H/N)*65536 +  [rem(H/N)*65536+L]/N
	       mov  bx, ax
	       mov  ax, dx
	       mov  dx, 0
	       div  cx

	       mov  si, ax

	       mov  ax, bx
	       div  cx

	       mov  cx, dx
	       mov  dx, si

	       ret           	; pop IP

codesg ends

end start
