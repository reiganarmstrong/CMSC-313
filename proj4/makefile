main: cFunctions.c main.asm ceasar.o
	nasm -f elf64 main.asm
	gcc -c cFunctions.c
	gcc -m64 -o main main.o cFunctions.o ceasar.o -lm
ceasar.o: ceasar.asm
	nasm -f elf64 ceasar.asm
run:
	./main
clean:
	rm main *.o