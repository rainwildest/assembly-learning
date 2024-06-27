assume cs:codesg, ds:datasg

datasg segment
	       db 10 dup(0)
datasg ends

codesg segment
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




codesg ends

end start
