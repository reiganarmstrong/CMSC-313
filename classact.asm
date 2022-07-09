 section .data
msg:    db      10, "You are at the start.",10
len:    equ     $-msg
msg2:   db      "Done!", 10
len2    equ     $-msg2
char:   db      0
        section .text
        global main
print:
        mov     rax, 1
        mov     rdi, 1
        syscall
        ret
main:
        xor     rax, rax
        xor     r9, r9
        mov     r9b, 255
        xor     r8b, r8b
label1:
        cmp     r9b, 0
        jae     label2
        mov     rsi, msg
        mov     rdx, len
        call    print
        jmp     done
label2:
        xor     rsi, rsi
        mov     rsi, 48
        add     rsi, r9
        mov     [char], rsi
        mov     rsi, char
        mov     rdx, 1
        call    print
        sub     r9b, 1
        jmp     label1
done:
        mov     rsi, msg2
        mov     rdx, len2
        call    print
        xor     rax, rax
        ret