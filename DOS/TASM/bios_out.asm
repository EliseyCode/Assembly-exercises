comment * 
A .COM program that prints all ASCII-symbols.
through BIOS interruptions 
*

        .model     tiny
        .code
        org        100h                
start:
	    mov        ax, 0003h
	    int        10h               ; videomode 3h (clear screen and set cursor on 0, 0)
	    mov        dx, 0             ; DH and DL will be used to store cursor position
	    mov 	   si, 256           ; cycle counter
	    mov        al, 0             ; first symbol with code 00h
	    mov        ah, 9             ; number of videofunction "stdout symbol with attribute"
	    mov        cx, 1             ; to print one symbol for one time
	    mov        bl, 0001111b
                                     ; symbol attribute - white on blue
cloop:
	    int        10h               ; print symbol on screen
	    push       ax                ; save current symbol and function number
	    mov        ah, 2             ; function #2 - change position of the cursor
	    inc        dl                ; increment current column by 1
	    int        10h               ; change position of the cursor
	    mov        ax, 0920h
                                     ; AH = 09, AL = 20h (ASCII-key of space)
	    int        10h               ; print space
	    mov        ah, 2             ; function #2
	    inc        dl                ; increment column by 1
	    int        10h               ; change cursor position
	    pop        ax                ; restore function number in AH and current symbol in AL
	    inc        al                ; increment AL by 1 - next symbol
	    test       al, 0Fh           ; if  AL is not multiple of 16
	    jnz        continue_loop
                                     ; continue cycle if not zero
	    push       ax                ; or save number of a function and current symbol
	    mov        ah, 2             ; function #2
	    inc        dh                ; increment row by 1
	    mov        dl, 0             ; column = 0
	    int        10h               ; set cursor at the begining of next row
	    pop        ax                ; restore function number and current symbol

continue_loop:

	    dec        si                ; decrement SI by 1
	    jnz        cloop             ; CX is used inside cycle. Using LOOP is incorrect
	    ret
	    end        start             ; end of the program