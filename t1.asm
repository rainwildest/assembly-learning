assume cs:codesg, ds:datasg

datasg segment
	       db 10 dup(0)
datasg ends

codesg segment
<<<<<<< HEAD
	start:            
	;  call divide_error
	                  call copy_divide_error
	                  call set_int0

	                  int  0H
				 
	                  mov  ax, 4c00H
	                  int  21H


	; 设置 int0 中断跳转的CS和IP
	set_int0:         
	                  mov  ax,0
	                  mov  es,ax

	                  mov  word ptr es:[0*4+0], 200H                        	;低位IP
	                  mov  word ptr es:[0*4+2], 0                           	;高位CS
	                  ret

	copy_divide_error:
	                  mov  ax, cs
	                  mov  ds, ax
	                  mov  si, OFFSET divide_error

	                  mov  ax, 0
	                  mov  es, ax
	                  mov  di, 200H

	                  mov  cx, OFFSET divide_error_end - OFFSET divide_error

	                  cld                                                   	;DF 重置为零 让di和si可以同时增加1
	                  rep  movsb                                            	;重复移动

	                  ret


	divide_error:     
	                  jmp  short s
	                  db   'divide error!',0

	s:                mov  ax, 0
	                  mov  ds,ax
	                  mov  si,202H

	                  mov  ax, 0B800H
	                  mov  es, ax
	                  mov  di, 160*15 + 40*2

	                  mov  cx,0

	show_word:        mov  cl, ds:[si]
	                  jcxz done

	                  mov  es:[di+0], cl
	                  mov  byte ptr es:[di+1], 01110001B
	                  add  di, 2
	                  inc  si
	                  jmp  show_word
									 

	done:             
	                  mov  ax, 4c00H
	                  int  21H                                              	; pop IP

	divide_error_end: nop




=======
	start:      mov  ax, 12666
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
	            push di
	            push dx

	            mov  si, 0           	; 记录循环次数
	            mov  cx, ax          	; 记录刚开始的被除数
	modulus:    
	            mov  dx, 0
	            mov  di, 10
	            div  di
	        
	            sub  cx, dx          	; 取得当前余数减去原始的被除数，看是否等于0，如果是0则说明该值已经被全部转换完成

	;  mov  di, dx
	            add  dx, 30H
	            mov  ds:[si], dx     	;将字符串写入 ds 中

	            inc  si              	; 增加循环次数
	            jcxz modulus_end

	            mov  cx, ax          	; 没有得到0，则将当前的余数再次给到CX
	            jmp  modulus

	modulus_end:
	            mov  ax, si
	            mov  bl, 2
	            div  bl              	; 取到循环的次数
					 
	            mov  cx, 0
	            mov  cl, al
	            dec  si
	            mov  bx, 0
	reverse:    
	            jcxz dtoc_end

	            mov  di, si
	            sub  di, bx

	            mov  ah, ds:[bx]     	; 开头
	            mov  al, ds:[di]     	; 倒叙开头

	            mov  ds:[bx], al     	; 对调开头的位置
	            mov  ds:[di], ah     	; 对调尾部的位置

	            inc  bx
	            loop reverse
 
	dtoc_end:   
	            pop  dx
	            pop  di
	            pop  si

	            ret


	; 显示文字
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
>>>>>>> 5b4df5398af644fef00474397c8f840f88398acf
codesg ends

end start
