; Name: Reagan Armstrong
; user_id: GX74574
; Description: Project 4 of CMSC 313 which encompases
;              a ceasar cipher, a string array that must be displayable and manipulatable,
;              and a frequency analysis decryption algroithm. This is the main assembly file
extern display
extern read
extern free
extern ceasar
extern decrypt
        section .data
; easter egg
troll_face: db "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⠟⠛⠛⠛⠛⠛⣛⣻⣿⣿⣿⣿⣿⣟⣛⣛⣛⠛⠒⠲⠶⠦⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠏⠁⠀⠀⢀⣤⠶⣛⣩⣥⠤⠤⠤⠤⢤⣤⣤⣭⣭⣉⣉⣛⣛⣻⣭⣥⠬⡍⠛⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠃⠀⠀⣠⡶⢋⡵⢛⡩⠵⠒⠒⠒⠒⠢⡀⠀⠀⠀⠀⠀⢀⣠⠤⠤⠤⢤⣄⠀⠀⠀⠉⠻⣆⠀⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⢀⣿⠃⠀⠀⠘⢁⡴⢋⣴⢿⠒⠈⠉⣏⠉⠐⠒⡾⣄⠀⠀⠀⠀⠀⡠⠀⠀⢀⣀⣈⣙⣆⡀⠀⠀⢹⡆⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⣠⣾⠃⠀⠀⠀⠀⠀⢀⠟⣁⠀⠁⢀⣤⣦⣤⡀⠘⠀⢈⣷⡄⠀⠀⠀⣇⠖⠉⠙⠅⠀⠀⠉⠉⠑⢦⡈⣷⡀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⢠⣾⢿⣧⠤⠤⠤⠄⠀⠖⣿⠀⠃⠀⠀⣿⣿⣿⣿⡗⠀⠐⠁⢸⡇⠀⣀⣰⠉⠠⠀⠀⣰⣶⣷⣶⠀⠀⠀⢱⡈⢻⣦⠀⠀⠀",10,"⠀⠀⠀⣠⡿⣱⠋⢀⣴⠶⠚⠻⢶⣤⡘⢧⣄⠆⠂⠀⡉⠉⣉⣀⣀⠉⣠⡟⠁⠀⠉⢻⣆⠀⠀⠀⠘⠛⠟⠛⠀⠀⢈⡿⢍⢢⢹⡇⠀⠀",10,"⠀⠀⢠⣿⠁⡇⢠⣿⠁⠀⢰⣦⡀⠉⠉⠀⠈⠙⠲⠾⠾⠶⠶⠶⠚⠋⠉⠀⠀⠀⠀⢸⣯⡑⠢⢤⣀⣂⣀⣨⠤⠒⠛⠃⠘⡆⡇⡧⠀⠀",10,"⠀⠀⢸⣿⠀⡇⢸⡇⢠⣴⣾⠋⠛⢷⣦⣀⠀⠀⠀⠠⠤⠤⠴⢠⠶⠒⠀⠀⠀⠀⠀⠀⠉⢿⣦⡀⠀⠀⠀⠀⢸⣷⠀⠀⡼⢡⢣⡇⠀⠀",10,"⠀⠀⠀⢿⡇⣧⠘⠿⠀⠀⠸⣧⡀⠀⠈⢻⡿⢶⣦⣄⡀⠀⠀⠸⣆⠐⠟⠻⠷⠀⠀⠀⢀⣾⠛⠃⠑⠤⠀⢀⣼⣿⡇⢀⠤⢂⣾⠃⠀⠀",10,"⠀⠀⠀⠈⢻⣌⠑⠦⠀⠀⠀⢿⣿⣷⣤⣸⣷⡀⠀⠈⠙⠻⢿⣶⣤⣄⣀⡀⠀⠀⠙⠿⠟⠁⠀⠀⢀⣠⡴⣿⠉⣿⣿⠀⠀⣼⠁⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠙⣷⡀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣶⣤⣀⣀⣼⠁⠀⠈⠉⠙⣿⠛⠛⠻⢿⠿⠛⠛⢻⡇⠀⢸⡀⣹⣿⠀⠀⡏⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠈⢿⡀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣤⣄⣀⣿⣄⣀⣀⣸⣄⣀⣠⣴⣿⣶⣿⣿⣿⣿⡇⠀⡇⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠈⢷⡄⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⡇⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣦⠀⠘⣿⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣷⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⠘⢷⡀⠘⡟⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⡀⠻⣾⡃⠀⠀⠈⠙⢿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣄⠈⠻⣦⡀⠀⠀⡼⠀⠀⠈⠙⠻⣿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⢿⡿⣹⠇⠀⣿⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⣄⠈⠛⠷⣼⣇⡀⠀⠀⠀⠀⣿⠀⠀⠀⢸⡇⠀⠀⡿⠀⢸⠇⣘⣧⠟⠀⢀⡿⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⣄⡀⠀⠙⠻⠷⠶⣶⣾⣿⣤⣀⣠⣿⣄⣀⣴⠷⠶⠿⠿⠟⠋⠀⢀⣾⠃⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⣶⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣤⡤⠞⠁⠀⠀⠀⠀⠀",10,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀",10
troll_face_len: equ $-troll_face
; prompt message
prompt: db 10,"Encryption menu options:",10,"s - show current messages",10,"r - read new message",10,"c - caesar cipher",10,"f - frequency decrypt",10,"q - quit program",10,"enter option letter -> "
prompt_len: equ $-prompt
invalid: db "Invlaid input, please try again!",10,10
invalid_len: equ $-invalid
bye: db "Goodbye!",10
bye_len: equ $-bye
easter_egg: db "EASTER EGG!!!!!!!!! (give extra credit plz and thank you)",10
easter_egg_len: equ $-easter_egg
format_current: db "%s",10,0
egg_counter: db 1
msg1: db "This is the original message.",0
msg2: db "This is the original message.",0
msg3: db "This is the original message.",0
msg4: db "This is the original message.",0
msg5: db "This is the original message.",0
msg6: db "This is the original message.",0
msg7: db "This is the original message.",0
msg8: db "This is the original message.",0
msg9: db "This is the original message.",0
msg10: db "This is the original message.",0
string_location_prompt: db "Enter string location : "
string_location_prompt_len: equ $-string_location_prompt
free_counter: dd 0
free_floor: dd 72

        section .bss
clear_char: resb 1
input_char: resb 1
string_arr: resq 10
numOriginal: resd 1
curr: resd 1

        section .text
        global main
main:
        ; initializes numOriginal, for memory allocaton/deallocation purposes
        mov dword[numOriginal], 10
        ; initializes curr used to keep track of the current string
        mov dword[curr], 1
        ; initializes the array
        mov qword[string_arr],msg1
        mov qword[string_arr+8],msg2
        mov qword[string_arr+16],msg3
        mov qword[string_arr+24],msg4
        mov qword[string_arr+32],msg5
        mov qword[string_arr+40],msg6
        mov qword[string_arr+48],msg7
        mov qword[string_arr+56],msg8
        mov qword[string_arr+64],msg9
        mov qword[string_arr+72],msg10
        JMP menu_input

; handles reading in a new message
read_in:
        xor rax, rax
        mov rdi, string_arr
        mov rsi, [numOriginal]
        mov rdx, [curr]
        call read
        cmp rax, 1
        ; if message was valid then go to valid_read_in, otherwise repormpt menu
        JE valid_read_in
        JMP menu_input

; updates numOriginal and curr
valid_read_in:
        call dec_original_rec
        call inc_curr_rec
        JMP menu_input

; decrements numOriginal until it is 0
dec_original_rec:
        cmp dword [numOriginal], 0
        JG dec_original
        ret

; helper for dec_original_rec
dec_original:
        sub dword [numOriginal], 1
        ret

; increments current and resets past 10
inc_curr_rec:
        cmp dword [curr], 10
        JB inc_curr
        JE reset_curr
        ret

; helper for inc_curr_rec, increments
inc_curr:
        add dword [curr],1
        ret

; helper for inc_curr_rec, resets
reset_curr:
        mov dword [curr], 1
        ret

; displays menu option
menu_options:
        mov rax, 1
        mov rdi, 1
        mov rsi, prompt
        mov rdx, prompt_len
        syscall
        ret

; handles getting menu input
menu_input:
        call menu_options
        mov rax, 0 ; get user input
        mov rdi, 0
        mov rsi, input_char
        mov rdx, 1
        syscall
        ; this part takes out the \n or invalidates the input
        mov rax, 0 ; get a character from input buffer
        mov rdi, 0
        mov rsi, clear_char
        mov rdx, 1
        syscall
        cmp byte [clear_char], 0xa
        ; handles clearing input buffer if incorrect input, else checks input further
        JNE clear_in
        JMP check_in
        
; prints invalid input text
invalid_in:
        mov rax, 1 ; prints invalid input
        mov rdi, 1
        mov rsi, invalid
        mov rdx, invalid_len
        syscall
        JMP menu_input

; displays all of the string in string_arr
display_messages:
        mov rdi, string_arr
        call display
        xor rax, rax
        JMP menu_input

; handles decrypt processes
decrypt_processes:
        mov rax, 1
        mov rdi, 1
        mov rsi, string_location_prompt
        mov rdx, string_location_prompt_len
        syscall 
        mov rax, 0 ; get user input
        mov rdi, 0
        mov rsi, input_char
        mov rdx, 1
        syscall
        ; this part takes out the \n or invalidates the input
        mov rax, 0 ; get a character from input buffer
        mov rdi, 0
        mov rsi, clear_char
        mov rdx, 1
        syscall
        cmp byte [clear_char], 0xa
        JNE clear_in
        ; if valid input, call check string location which sets up params for decrypt
        call check_string_location
        call decrypt
        JMP menu_input

; checks the option letter
check_in:
        cmp byte [input_char], 83 ; checks if S
        JE display_messages
        cmp byte [input_char], 115 ; checks if s
        JE display_messages
        cmp byte [input_char], 82 ; checks if R
        JE read_in
        cmp byte [input_char], 114 ; checks if r
        JE read_in
        cmp byte [input_char], 67 ; checks if C
        JE ceasar_cipher_processes
        cmp byte [input_char], 99 ; checks if c
        JE ceasar_cipher_processes
        cmp byte [input_char], 70 ; checks if F
        JE decrypt_processes
        cmp byte [input_char], 102 ; checks if f
        JE decrypt_processes
        cmp byte [input_char], 81 ; checks if Q
        JE exit_processes
        cmp byte [input_char], 113 ; checks if q
        JE exit_processes
        cmp byte [input_char], 122 ; checks if z
        JE easter_egg_processes
        JMP invalid_in

; handles easter egg
easter_egg_processes:
        ; if the egg_counter is 4 print easter egg, else increment the counter
        cmp byte[egg_counter], 4
        JB inc_easter_egg
        mov byte[egg_counter], 1
        mov rax, 1 
        mov rdi, 1
        mov rsi, easter_egg
        mov rdx, easter_egg_len
        syscall
        mov rax, 1 
        mov rdi, 1
        mov rsi, troll_face
        mov rdx, troll_face_len
        syscall
        JMP menu_input

; increment the counter for 'z'
inc_easter_egg:
        add byte[egg_counter], 1
        JMP invalid_in

; handles clearing input buffer
clear_in:
        mov rax, 0 ; get a character from input buffer
        mov rdi, 0
        mov rsi, clear_char
        mov rdx, 1
        syscall

        cmp byte [clear_char], 0xa ; if the clear chracter is not \n then keep on looping
        JNE clear_in
        JMP invalid_in

; preform ceasar cipher on a string in the string arr
ceasar_cipher_processes:
        mov rax, 1
        mov rdi, 1
        mov rsi, string_location_prompt
        mov rdx, string_location_prompt_len
        syscall 
        mov rax, 0 ; get user input
        mov rdi, 0
        mov rsi, input_char
        mov rdx, 1
        syscall
        ; this part takes out the \n or invalidates the input
        mov rax, 0 ; get a character from input buffer
        mov rdi, 0
        mov rsi, clear_char
        mov rdx, 1
        syscall
        cmp byte [clear_char], 0xa
        JNE clear_in
        ; calls check_string_location which sets up the params for ceasar
        call check_string_location
        call ceasar
        JMP menu_input

; makes sure a valid string index is input and puts the 
; address of that string into rdi
check_string_location:
        cmp byte [input_char], 48
        JB invalid_in
        cmp byte [input_char], 57
        JA invalid_in
        xor r8, r8
        mov  r8b, byte [input_char]
        ; makes sure its an int between 0 and 9
        sub r8b, 48
        xor rax, rax
        mov rax, 8
        xor rdx, rdx
        ; rax=8*r8
        mul r8b
        xor r8, r8
        xor rdi, rdi
        ; sets up ceasar or decrypt
        mov rdi, qword[string_arr+rax]
        xor rax, rax
        ret

; prints goodbye and clears dynamically allocated data
exit_processes:
        mov rax, 1
        mov rdi, 1
        mov rsi, bye
        mov rdx, bye_len
        syscall ; prints goodbye
        cmp dword [numOriginal], 0
        JNE free_unfilled_arr
        xor r9, r9
        mov r9, 0
        xor r11, r11
        mov r11, 72
        JMP free_arr

; sets up free_arr for an array with some indexes with non freeable memory
free_unfilled_arr:
        mov r8, 0
        mov r8d, 9
        sub r8d, dword[numOriginal]
        mov rdi, 0
        mov rdx, 0
        mov rax, 0
        mov rax, 8
        mul r8
        ; r8=(9-[numOriginal])*8
        mov dword[free_floor], eax
        xor r9, r9
        JMP free_arr

; frees dynamically allocated memory
free_arr:
        ; while r9<=r8 free [string_arr+r9] and r9+=8
        ; else exit
        xor r9, r9
        mov r9d, dword[free_counter]
        cmp r9d, dword[free_floor]
        JG exit
        mov r10, 0
        mov r10, string_arr
        add r10, r9
        mov rdi,0
        ; free [string_arr+r9]
        mov rdi, qword[r10]
        xor rax, rax
        call free
        add dword[free_counter], 8
        xor r9, r9
        mov r9d, dword[free_counter]
        cmp r9d, dword[free_floor]
        JLE free_arr
        JMP exit

; exit command
exit:
        mov rax, 60
        xor rdi, rdi
        syscall