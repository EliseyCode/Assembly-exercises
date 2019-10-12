COMMENT * 
A .COM calculation program.
INPUT: decimal number
OUTPUT: hexadecimal 
*

        .model     tiny
        .code
        .286
        org        100h
start:
        mov        dx, offset dec_in
        mov        ah, 9
        int        21h                ; enter value in decimal
        mov        dx, offset buffer
        mov        ah, 0Ah
        int        21h                ; read string of values in buffer
        mov        dx, offset crlf
        mov        ah, 9
        int        21h                ; change line
; tanslate value in  ASCII-format from buffer to binary number in AX
        xor        di, di             ; DI = 0 - byte number in buffer
        xor        ax, ax             ; AX = 0 - current result value
        mov        cl, blength
        xor        ch, ch
        xor        bx, bx
        mov        si, cx             ; SI - buffer lenght
        mov        cl, 10             ; CL = 10, factor for MUL
asc_to_hex:
        mov        bl, byte ptr bcontents[di]
        sub        bl, '0'            ; number = code number - character code "0"
        jb         asc_error          ; if character code below than "0"
        cmp        bl, 9              ; or greater than "9"
        ja         asc_error          ; exit program with error message
        mul        cx                 ; else: multiply current result by 10
        add        ax, bx             ; add to AX new number
        inc        di                 ; increment counter
        cmp        di, si             ; if counter + 1 less than buffer lenght -
        jb         asc_to_hex         ; continue
; print hexadecimal number
        push       ax                 ; save result of conversion
        mov        ah, 9
        mov        dx, offset hex_out
        int        21h
        pop        ax
; print number from AX
        push       ax
        xchg       ah, al             ; store in AL high byte
        call       print_al           ; print it
        pop        ax                 ; restore low byte
        call       print_al           ; print it

        ret

; print error message and exit program
asc_error:
        mov        dx, offset err_msg
        mov        ah, 9
        int        21h
        ret

; print_al - prints value from AL as hexadecimal value.
; Modify values AX and DX
print_al:
        mov        dh, al
        and        dh, 0Fh           ; DH - lower 4 bits
        shr        al, 4             ; AL - high
        call       print_nibble      ; print higherst number
        mov        al, dh            ; AL - lowest 4 bits

; procedure for printing 4 bits (hexadecimal form)
print_nibble:
        cmp        al, 10
        sbb        al, 69h
        das
        mov        dl, al
        mov        ah, 2
        int        21h
; this ret works twise - 1 return from print_nibble, than return from print_al
        ret

dec_in  db         "Enter number in decimal: $"
hex_out db         "Output hexadecimal number: $"
err_msg db         "Illegal symbol. Use only 0-9 numbers"
crlf    db         0Dh, 0Ah, '$'
buffer  db         6                 ; max buffer size
blength db         ?                 ; buffer size after reading 
bcontents:

        end        start