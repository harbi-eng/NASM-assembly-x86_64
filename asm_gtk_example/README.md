to run:
	 use nasm -f elf64 main.asm -o main.o && gcc -no-pie main.o -o main `pkg-config --cflags --libs gtk4` && ./main 
