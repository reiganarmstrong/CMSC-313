; Name: Reagan Armstrong
; user_id: GX74574
; Description: Project 4 of CMSC 313. This file is the ceasar asm file for the project.
;              it contains the ceasar subroutine and its dependencies. It takes in a string
;              and preforms the ceasar cipher on it.

        section .data
; shift message prompt
shift_prompt: db "Enter shift value (0-25): "
shift_prompt_len: equ $-shift_prompt
; original message prompt
format_current: db "%s",10,0
new_line: db 10
; current message prompt
curr_mess: db "Current message:  "
curr_mess_len: equ $-curr_mess
; encryption message prompt
enc_mess: db "Caesar encryption:  "
enc_mess_len: equ $-enc_mess


        section .bss
; used to hold shift 
shift_resp: resb 3
; used to clear input buffer
clear_char: resb 1


        section .text
        global ceasar
ceasar:
        ; puts the string into r12
        mov r12, rdi
        JMP shift
        ret
shift:
        mov rax, 1 ; print shift prompt 
        mov rdi, 1
        mov rsi, shift_prompt
        mov rdx, shift_prompt_len
        syscall
        mov rax, 0 ; get user input
        mov rdi, 0
        mov rsi, shift_resp
        mov rdx, 3
        syscall
        mov r8, rax
        cmp byte [shift_resp], 0xa ; rerun if nothing entered
        JE shift
        cmp byte [shift_resp+r8-1], 0xa ; checks if the last character in the string is a \n
        JNE clear_shift ; clears input buffer if this is the case
        JMP check_shift
        ret


find_length:
        add r8, 1
        cmp byte[r12+r8], 0
        JNE find_length
        JMP original
        ret
; handles getting original message and prints original message
original:
        mov rax, 1 ; print original
        mov rdi, 1
        mov rsi, curr_mess
        mov rdx, curr_mess_len
        syscall
        mov rax, 1 
        mov rdi, 1
        mov rsi, r12
        mov rdx, r8
        syscall
        ; print new line
        mov rax, 1 
        mov rdi, 1
        mov rsi, new_line
        mov rdx, 1
        syscall
        xor r9,r9
        mov r9, r8 ; size of the original response for iteration
        xor r11, r11
        mov r11b, 26 ; size of the alphabet to divide by
        JMP encrypt
        ret
; handles encrytion
encrypt:
        sub r9, 1 ; decrement each time until r9=-1
        CMP r9, 0
        JL exit
        CMP byte [r12+r9], 65 ; make sure char is not less than 'A'
        JB encrypt
        CMP byte [r12+r9], 122 ; make sure char is not more than 'z'
        JA encrypt
        CMP byte [r12+r9], 90 ; if char is above 'Z'
        JA lowerCase
        JMP upperCase
        ret


; handles lower case char encryption
lowerCase:
        CMP byte [r12+r9],97 
        JB encrypt ; if the character is less than 'a' go back to encrypt
        add byte [r12+r9], r10b ; shift the character by r10b which holds shift
        sub byte [r12+r9], 97 ; subtract 97 so that we are dealing with 0-25
        xor rdx,rdx
        xor rax, rax
        mov al, byte [r12+r9]
        div r11 ; divide by 26
        mov byte [r12+r9], dl ; use the remainder for the shifted character
        add byte [r12+r9], 97 ; add back the subracted 97 so we print apropriate ascii char
        JMP encrypt
        ret

; handles upper case char encryption
upperCase:
        add byte [r12+r9], r10b ; shift the character by r10b which holds shift
        sub byte [r12+r9], 65 ; subtract 65 so that we are dealing with 0-25
        xor rdx,rdx
        xor rax, rax
        mov al, byte [r12+r9]
        div r11
        mov byte [r12+r9], dl ; use the remainder for the shifted character
        add byte [r12+r9], 65 ; add back the subracted 65 so we print apropriate ascii char
        JMP encrypt
        ret

; handles clearing input buffer
clear_shift:
        mov rax, 0 ; get a character from input buffer
        mov rdi, 0
        mov rsi, clear_char
        mov rdx, 1
        syscall

        cmp byte [clear_char], 0xa ; if the clear chracter is not \n then keep on looping
        JNE clear_shift
        JMP shift
        ret

; handles checking if the shift inputted is valid
check_shift:
        xor r10, r10
        xor r11, r11
        mov r11, 10 ; used to multiply 10s place by 10
        mov r9, r8
        sub r9, 1
        cmp r9, 2
        JNE check_ones_shift
        cmp byte [shift_resp], 48 ; makes sure the 10s digit is not less than 0
        JB shift
        cmp byte [shift_resp], 50 ; makes sure the 10s digit is 2 or less
        JE check_twenties_shift ; if the 10s digit is 2
        JA shift
        ; handles 2 digit shift <20
        cmp byte [shift_resp+1], 48 ; makes sure ones digit is valid for a 2 digit number <20
        JB shift
        cmp byte [shift_resp+1], 57
        JA shift
        add r10b, byte [shift_resp+1]
        sub r10b, 48 ; 1s place so sub by 48
        xor rax, rax
        xor rdx, rdx
        mov al, byte [shift_resp] ; multiply 10s place by 10
        sub al, 48
        mul r11
        add r10b, al ; add n 10s place
        xor r8, r8
        JMP find_length
        ret

; handles checking a 1 digit shift
check_ones_shift: ; makes sure ones digit is valid for a 1 digit number
        cmp byte [shift_resp], 48
        JB shift
        cmp byte [shift_resp], 57
        JA shift
        add r10b, byte [shift_resp]
        sub r10b, 48 ; 1s place so sub by 48
        xor r8, r8
        JMP find_length
        ret

; handles checking a 2 digit shift in the twenties
check_twenties_shift:
        cmp byte [shift_resp+1], 48 ; ones place is not a valid number (below 0)
        JB shift
        cmp byte [shift_resp+1], 53 ; ones place is not a valid number (above 5)
        JA shift
        add r10b, byte [shift_resp+1]
        sub r10b, 48 ; 1s place so sub by 48
        xor rax, rax
        xor rdx, rdx
        mov al, byte [shift_resp] ; multiply 10s place by 10
        sub al, 48
        mul r11
        add r10b, al ; add n 10s place
        xor r8, r8
        JMP find_length

        ret
; prints encrypted message and ends program
exit:
        ; encryption message
        mov rax, 1 
        mov rdi, 1
        mov rsi, enc_mess
        mov rdx, enc_mess_len
        syscall
        ; encrypted message
        mov rax, 1 
        mov rdi, 1
        mov rsi, r12
        mov rdx, r8
        syscall
        ; print new line
        mov rax, 1 
        mov rdi, 1
        mov rsi, new_line
        mov rdx, 1
        syscall
        ret