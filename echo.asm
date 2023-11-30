.data
	prompt: .asciiz "Enter a string :"    # prompt to ask for the input string
	text: .space 100                      # allocate 100 bytes of memory to store the input string

.text	
main:	
	# print the input prompt
	li $v0,4			# system call code to print string
	la $a0,prompt			# load address of the input prompt into $a0
	syscall
	
	# read the input string
	li $v0,8			# system call code to read string
	la $a0,text			# load address of the memory location where the input string will be stored
	li $a1,100			# maximum length of the input string
	syscall
	
	# allocate memory on the heap to store the input string
	li $a0,100			# request 100 bytes of memory
	li $v0,9			# system call code for sbrk
	syscall
	
	move $a0,$v0			# Save Ptr to dynamically allocated string
	la $a1,text			# Sal = source pointer 
	jal loop

loop:
	lb $t0,0($a1)			# Get a character
	sb $t0,0($v0)			# Store in heap
	addi $a1,$a1,1			# Increment pointers
	addi $v0,$v0,1
	bnez $t0,loop			# Branch to loop if not at end of s tring
	
	li $v0,4			# Print contents of heap
	syscall
	
	#exit the program
	li $v0,10
	syscall	
	
	
