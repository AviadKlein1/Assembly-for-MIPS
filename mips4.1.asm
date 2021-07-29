#Aviad Klein 315552679
#Exe 4
#The program receives two numbers and performs account operations on them using the functions .


.data 
.asciiz
enter_numbers: "enter two numbers\n"
enter_operator: "enter an operator\n"

.text
	li $t0 '+'                                             
	li $t1 '*'
	li $t2 '^'
	li $v0 4                             #print "enter two numbers"
	la $a0 enter_numbers
	syscall
	li $v0 5                             #input the first number
	syscall
	add $t3 $zero $v0                    #we save the value of the first number at $t3
	slt $s1 $t3 $zero                    #if $t3 < 0, $s1 = 1. else $s1 = 0.
	li $v0 5                             #input the second number
	syscall
	add $a1 $zero $v0                    #we save the value of the second number at $a1
	slt $s2 $a1 $zero                    #if $a1 < 0, $s2 = 1. else $s2 = 0.
	li $v0 4                             #print "enter an operator"
	la $a0 enter_operator
	syscall
	li $v0 12                            #input the operator
	syscall
	add $a0 $zero $t3                    #we save the first number at 4a0
	
        #the left operant is $a0 and the right operand is $a1
	                                                          
	beq $v0 $t0  go_to_add_function      #if the operator is '+' jump to go_to_add_function 
	beq $v0 $t1  go_to_mult_function     #if the operator is '*' jump to go_to_mult_function
	beq $v0 $t2  go_to_pow_fanction      #if the operator is '^' jump to go_to_pow_fanction
	j exit
	
go_to_add_function:
	jal add_function                     #go to  add_fanction
	add $a0 $v0 $zero                    #we save the result (that exist $v0) at $a0
	li $v0 1                             #print the add result
	syscall
	j exit                               #end the program -> jump to exit
	
add_function:
	addi $sp $sp -4                      #save the registers at the stack 
	sw $ra 0($sp)
	
	add $v0 $a0 $a1                      #$v0=$a0+$a1
	
	lw $ra 0($sp)                        #put the registers out of the stack
	addi $sp $sp 4
	
	jr $ra
	
go_to_mult_function:
	jal mult_function                     #go to  add_fanction
	add $a0 $v0 $zero                    #we save the result (that exist $v0) at $a0
	li $v0 1                             #print the add result
	syscall
	j exit       

mult_function:

	addi $sp $sp -4                      #save the registers at the stack 
	sw $ra 0($sp)
	
	add $t6 $a1 0
	
	jal loop
	add $v0 $t5 $zero
	sub $t6 $t6 1
	bne $t6 0 loop
			
	lw $ra 0($sp)                        #put the registers out of the stack
	addi $sp $sp 4
	
	jr $ra                                              
loop:
	add $t5 $t5 $a0
	jr $ra
	
go_to_pow_fanction:
	jal pow_fanction                    #jump to pow_fanction 
	add $a0 $v0 $zero                   #we save the result (that exist $v0) at $a0
	li $v0 1                            #print the result
	syscall
	j exit                              #end the program -> jump to exit
	
pow_fanction:
	addi $sp $sp -4                     #save the registers at the stack                                
	sw $ra 0($sp)
	addi $sp $sp -4
	sw $t0 0($sp)
	
	beq $a1 $zero print1                #if $a1=0 jump to print1
	li $t0 1                            #$t0=1
	beq $a1 $t0 print_num               #if $a1=1 jump to print_num
	add $a2 $a1 $zero                   #$a2 retains possession value
	add $a1 $zero $a0                   #$a1=$a0 -> base of possession
	
	jal rec_pow                         #jump to the fanction rec_pow 
	lw $t0 0($sp)                       #put the registers out of the stack
	addi $sp $sp 4
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra

print1:	
	li $v0 1                            #print the number 1
	li $a0 1
	syscall
	j exit                              #end the program -> jump to exit

print_num:
	li $v0 1                            #print the number -> $a0
	syscall
	j exit                              #end the program -> jump to exit
	
rec_pow:
	addi $sp $sp -4                     #save the registers at the stack 
	sw $ra 0($sp)
	addi $sp $sp -4
	sw $a2 0($sp)
	
	li $v0 0
	add $a1 $a1 $v0	                    #$a1=#a1+$v0 -> we add the result to $a1

internal_rec_pow:	
	jal mult_function                   #jump to mult_fanction
	addi $a2 $a2 -1                     #the counter --
	li $t3 1                            #the counter -> $t2--
	bne $a2 $t3 internal_rec_pow        #if $t2=0 (the counter is ended) continue. else return to internal_rec_pow 
	
	lw $a2 0($sp)                       #put the registers out of the stack
	addi $sp $sp 4
	lw $ra 0($sp)
	addi $sp $sp 4
	
	jr $ra


exit:

