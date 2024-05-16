assume cs:codesg,ds:datasg

datasg segment
	       db 10 dup(0)
datasg ends

codesg segment
	start:   mov  ax, 12666
	         mov  bx, datasg
	         mov  ds, bx
	         mov  si, 0
	         call dtoc

	         mov  dh, 8
	         mov  dl, 3
	         mov  cl, 2
	         call show_str
				 
	         mov  ax, 4c00H
	         int  21H

	dtoc:    
	         push si
	         mov  si, 0           	; 记录循环次数
 
	         mov  cx, ax          	; 记录刚开始的被除数
	modulus: 
	         mov  dx, 0
	         mov  di, 10
	         div  di
	        
	         sub  cx, dx          	; 取得当前余数减去原始的被除数，看是否等于0，如果是0则说明该值已经被全部转换完成

	         mov  di, dx
	         add  di, 30H
	         mov  ds:[si], di     	;将字符串写入 ds 中

	         inc  si              	; 增加循环次数
	         jcxz over

	         mov  cx, ax          	; 没有得到0，则将当前的余数再次给到CX
	         jmp  modulus

	over:    
	         pop  si
	         ret


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
