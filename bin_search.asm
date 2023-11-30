.data
	prompt1: .asciiz "Enter the size of the array : "		# prompt to ask for n
	prompt2: .asciiz "Enter element : "				# prompt to ask for elements of the array
	prompt3: .asciiz "Search element : "				# prompt to ask for elements of the array	
	msg1: .asciiz"Yes at index "
	msg2: .asciiz"Not found"				

.text
.globl main

main:
    	# print the input prompt to get size of array
    	li $v0,4           						# system call code to print string
    	la $a0,prompt1     						# load address of the input prompt into $a0
    	syscall

    	# read the input integer for n (size of array)
    	li $v0,5           						# system call code to read int
    	syscall
    	move $t0,$v0       						# $t0 = n
	
	#check if 1 <= n <= 30
	blt $t0,1,end
	bgt $t0,30,end
	
    	# allocate memory on the heap to store the input int array
    	li $v0,9           						# sbrk system call
    	sll $t1,$t0,2         						# $t1 = n * 4
    	move $a0,$t1            					# request $t1 bytes of memory to store n integers
    	syscall
    	
    	move $t1,$v0       						# Save Ptr to heap
	move $t3,$t1							# copy Ptr to heap
	
    	# prompt user for array elements and store them in heap
    	li $t2,0          						# initialize the loop counter

	loop_1: 
	# loop to store elements in heap
    	beq $t2,$t0,exit_loop_1 					# if $t2 == n, exit the loop
    
   	# prints the input prompt for array elements
    	li $v0,4           
    	la $a0,prompt2  
    	syscall
    
    	add $a0,$t2,1     						# increment loop counter by 1 and load it into $a0
    	
    	#get array element
    	li $v0,5
    	syscall
    
    	sw $v0,($t1)       						# store the input value in heap
    	addi $t1,$t1,4    						# move the memory pointer to the next element
    	addi $t2,$t2,1    						# increment the loop counter
    	
    	j loop_1              						# jump back to store next element

	exit_loop_1 :
	# prints the input prompt to get x ( the element we need to search)
    	li $v0,4           						
    	la $a0,prompt3     						
    	syscall
    	
    	# read the input integer for x
    	li $v0,5           						
    	syscall
	
	move $s0,$v0							# $s0 = x
	move $a0,$t3							# pointer to heap
	jal binary
	
binary:
	#initialise low and high indices
	li $t4,0
	add $t5,$t0,-1
	
	loop_2:
	
	#if low > high then exit 
	bgt $t4,$t5,not_found
	
	# Calculate mid index 
        add $t6,$t4,$t5
        srl $t6,$t6,1
        
        # Load mid element into register
        sll $t7,$t6,2 							# t7 = 4 * mid
        add $t7,$t7,$a0
        lw $t8,0($t7)
        
	# Compare mid element to x
        beq $t8,$s0,found
        blt $t8,$s0,update_low
        bgt $t8,$s0,update_high
	
    	update_low:
    	# Update low index
        addi $t4,$t6,1
        j loop_2
        
    	update_high:
    	# Update high index
        addi $t5,$t6,-1
        j loop_2
    
    	found:
    	# If x is found, print "Yes at index " and the index
        li $v0,4
        la $a0,msg1
        syscall
        
        li $v0,1							# system call code to print integer
        move $a0,$t6							# index at which x found
        syscall
        
        j end
        
    	not_found:
    	# If x is not found, print "Not Found"
   	li $v0,4
   	la $a0,msg2
    	syscall
    	
    	j end
    	
    
end:
    	# End program
        li $v0, 10
        syscall
        
# We assume the array is sorted a1 <= a2 <= a3 <= a4 <= ………… an
# Time complexity : O(log n) as we follow binary search algorithm