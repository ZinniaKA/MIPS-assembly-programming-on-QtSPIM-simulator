.data
	msg1: .asciiz "Enter x : "			# prompt to ask for x (base)
	msg2: .asciiz "Enter n : "			# prompt to ask for n (exponent)
	msg3: .asciiz "x to the power n is : "		# prompt to print the output

.text
main:	
	# prints the input prompt for x
	li $v0,4				# system call code to print string
    	la $a0,msg1				# load address into $a0
    	syscall
    	
    	# read the input integer for x
    	li $v0,5				# system call code to read integer
    	syscall
    	
    	jal check_constraint			#checks if 0 <= x <= 10000
    	move $t0,$v0				#$t0 = x
    
    	# prints the input prompt for n
    	li $v0,4
    	la $a0,msg2
    	syscall
    
    	# read the input integer for n
   	li $v0,5
    	syscall
    
    	jal check_constraint			#checks if 0 <= n <= 10000
    	move $a1,$v0    			#$a1 = n		
        move $a0, $t0    			#$a0 = x

    	jal fast_power

    	move $s0,$v0				#$s0 = x^n
    	
    	# prints the output prompt
        li $v0,4
        la $a0,msg3
    	syscall
    	
    	#print the result
    	move $a0,$s0				# $a0 = x^n
    	li $v0,1				# system call code to print integer
    	syscall
    
    	jal exit

fast_power:
	addi $sp,$sp,-4				# allocate space on stack
        sw $ra,0($sp)				# save return address
        
        bne $a1,$zero,check_if_n_equals_1	#if n != 0
        addi $v0,$zero,1			# base case: n == 0
        	
        addi $sp, $sp,4				# deallocate space on stack
        jr $ra
        
check_if_n_equals_1:    
	bne $a1,1,start_recursion		#if n != 1
        add $v0,$zero,$a0			# base case: n == 1
        addi $sp,$sp,4
        
        jr $ra

start_recursion:   
	#check if n is even or odd 
	move $t1,$a1
        andi $t0,$t1,1
                			
        bne $t0,$zero,n_odd   			#if n is odd goto n_odd
        
        #n is even
        srl $a1, $a1,1        			#compute n/2
        jal fast_power
        
        mul $v0,$v0,$v0        			# x^n/2 * x^n/2
        
        lw $ra, 0($sp)				# restore return address
        addi $sp,$sp,4				# deallocate space on stack
        jr $ra

n_odd:    
	addi $a1,$a1,-1        			#x * x^n-1 ,n is odd
        jal fast_power
        
        lw $ra, 0($sp)
        addi $sp,$sp,4
        
        mul $v0,$v0,$a0
        
        jr $ra
        
check_constraint:
 	bltz $v0,exit       			# check if int less than 0
 	bgt $v0,10000,exit			# check if int more than 10000
 	jr $ra
 	
 exit:	#exit the program
 	li $v0,10
 	syscall

#time complexity O(logn) as it follows fast power approach
#this code assumes that the output doesn't overflow i.e. it is a 31 bit integer otherwise we get an incorrect answer (We don't assume 32 bit since one bit is considered for sign)
