; Name: Reagan Armstrong
; user_id: GX74574
; Description: This program takes in a user input of size 30 characters or greater and
;              prints out the message encrypted with the ceasar cipher with a user
;              specified shift value between 0 and 25


        section .data
; shift message prompt
shift_prompt: db "Enter shift value (0-25): "
shift_prompt_len: equ $-shift_prompt
; original message prompt
original_mess_prompt: db "Enter original message (must be greater than 30 characters): "
original_mess_prompt_len: equ $-original_mess_prompt
; current message prompt
curr_mess: db "Current message:  "
curr_mess_len: equ $-curr_mess
; encryption message prompt
enc_mess: db "Encryption:  "
enc_mess_len: equ $-enc_mess


        section .bss
; used to hold shift 
shift_resp: resb 3
; used to hold response
original_resp: resb 255
; used to clear input buffer
clear_char: resb 1


        section .text
        global main
main:
; handles getting shift input
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

; handles getting original message and prints original message
original:
        mov rax, 1 ; print original text prompt 
        mov rdi, 1
        mov rsi, original_mess_prompt
        mov rdx, original_mess_prompt_len
        syscall
        mov rax, 0 ; get user input
        mov rdi, 0
        mov rsi, original_resp
        mov rdx, 255
        syscall
        mov r8, rax
        cmp r8, 31
        JBE original ; reprompt if there are less than or equal to 31 characters including the \n
        mov rax, 1 ; print original
        mov rdi, 1
        mov rsi, curr_mess
        mov rdx, curr_mess_len
        syscall
        mov rax, 1 ;print original
        mov rdi, 1
        mov rsi, original_resp
        mov rdx, r8
        syscall
        xor r9,r9
        mov r9, r8 ; size of the original response for iteration
        xor r11, r11
        mov r11b, 26 ; size of the alphabet to divide by
        
; handles encrytion
encrypt:
        sub r9, 1 ; decrement each time until r9=-1
        CMP r9, 0
        JL exit
        CMP byte [original_resp+r9], 65 ; make sure char is not less than 'A'
        JB encrypt
        CMP byte [original_resp+r9], 122 ; make sure char is not more than 'z'
        JA encrypt
        CMP byte [original_resp+r9], 90 ; if char is above 'Z'
        JA lowerCase
        JMP upperCase


; handles lower case char encryption
lowerCase:
        CMP byte [original_resp+r9],97 
        JB encrypt ; if the character is less than 'a' go back to encrypt
        add byte [original_resp+r9], r10b ; shift the character by r10b which holds shift
        sub byte [original_resp+r9], 97 ; subtract 97 so that we are dealing with 0-25
        xor rdx,rdx
        xor rax, rax
        mov al, byte [original_resp+r9]
        div r11 ; divide by 26
        mov byte [original_resp+r9], dl ; use the remainder for the shifted character
        add byte [original_resp+r9], 97 ; add back the subracted 97 so we print apropriate ascii char
        JMP encrypt

; handles upper case char encryption
upperCase:
        add byte [original_resp+r9], r10b ; shift the character by r10b which holds shift
        sub byte [original_resp+r9], 65 ; subtract 65 so that we are dealing with 0-25
        xor rdx,rdx
        xor rax, rax
        mov al, byte [original_resp+r9]
        div r11
        mov byte [original_resp+r9], dl ; use the remainder for the shifted character
        add byte [original_resp+r9], 65 ; add back the subracted 65 so we print apropriate ascii char
        JMP encrypt

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
        JMP original

; handles checking a 1 digit shift
check_ones_shift: ; makes sure ones digit is valid for a 1 digit number
        cmp byte [shift_resp], 48
        JB shift
        cmp byte [shift_resp], 57
        JA shift
        add r10b, byte [shift_resp]
        sub r10b, 48 ; 1s place so sub by 48
        JMP original

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
        JMP original

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
        mov rsi, original_resp
        mov rdx, r8
        syscall
        ; exit system call
        mov rax, 60
        xor rdi, rdi
        syscall