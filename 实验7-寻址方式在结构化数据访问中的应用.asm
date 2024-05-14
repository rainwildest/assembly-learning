assume cs:codesg,ds:datasg


; stacksg segment
; 	        dw 0,0,0,0,0,0,0,0
; stacksg ends

datasg segment
	       db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
	       db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
	       db '1993', '1994', '1995'
	;  以上是表示21年的21个字符串
	       dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
	       dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
	; 以上是表示21年公司总收入的21个dword型数据
	       dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
	       dw 11542, 14430, 15257, 17800
	; 以上是表示21年公司雇员人数的21个word型数据
datasg ends

table segment
	      db 21 dup ('year sumn ne ?? ')
table ends

codesg segment
	start:  mov  ax, datasg
	        mov  ds, ax

	        mov  ax, table
	        mov  es, ax

	        mov  bp, 0
	        mov  di, 0
	        mov  si, 0

	        mov  cx, 21
	t:      push cx
	        push si

	        mov  cx, 2
	        mov  si, 0
	setData:mov  ax, ds:[di]
	; 设置年份
	        mov  es:[bp + si], ax

	; 设置收入
	        mov  ax, ds:[di + 84]
	        mov  es:[bp + si + 5], ax

	        add  si, 2
	        add  di, 2
	        loop setData

	;  设置雇员
	        pop  si
	        mov  ax, ds:[si + 168]
	        mov  es:[bp + 10], ax
	        add  si, 2

	; 人均收入
	        mov  ax, es:[bp + 5]
	        mov  dx, es:[bp + 7]
	        div  word ptr es:[bp + 10]
	        mov  es:[bp + 13], ax

	        add  bp, 16
	        pop  cx
	       
	        loop t


	        mov  ax, 4C00H
	        int  21H
codesg ends

end start