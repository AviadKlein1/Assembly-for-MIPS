#Aviad klein ID 315552679
#Exe 5.1
#The program receives a 6-digit base code and checks whether it is on the block.

.data 
.byte
block:	5 6 8 1 1 1 4 5 2 4 5 6 8 5 2 4 5 1 8 7 9 5 6 9 4 3 5 6 4 5 2 4 #size of block 32 bytes
basic_code:
.asciiz
enter_value:"Enter 6 numbers\n"
The_code:"\n The code is:\n"
message_found:"\n The code found! \n"
message_not_found:"\n The code not found!\n"

.text 
	la $a0 enter_value                	#print Enter 6 numbers
	li $v0 4 		      	
	syscall
	la $a0 block                      	#we load the address of the begining the block
	la $a1 basic_code                 	#we load the address of the place to put the basic code
	li $t0 0                          	#$t0 counter from 0
	li $t1 6                          	#$t1 == 6 , the number of index in the code

#input the basic_code of 6 numbers
input_basic_code:
	beq $t0 $t1 cheacking_basic_code  	#if $t0 == 6, we finish to receive the code
	li $v0 5                          	#input the current number in the code
	syscall                           
	sb $v0 0($a1)                     	#store the num in the memory
	addi $a1 $a1 1
	addi $t0 $t0 1                    	#the counter -> $t0++
	j input_basic_code


cheacking_basic_code:
	la $a1 basic_code                 	#load the basic code's address into $a1
	la $t2 block                      	#saves the number that we start to check from 
	li $t0 32                         	#temp register to cheack if we finish the block

over32bits:
	beq $t1 $zero found               	#if $t1 == 0,jump to found -> we found the basic code in the block
	beq $t0 $zero notFound            	#if $t0 == 0,jump to notFound -> we not found the basic code in the block
	lb $t4 0($a0)                     	#we keep the num from block
	lb $t5 0($a1)                     	#we keep the num from code
	beq $t5 $t4 equal                 	#if $t5 == $t4 jump to equal
                    				#if the numbert are different
	addi $t2 $t2 1                    	#$t2++, $t2 is a pointer to the num that we start to cheack from
	addi $a0 $t2 0                    	#we update $a0 to one after we start to cheack
	li $t1 6                          	#$t1 = 6 
	la $a1 basic_code                 	#if the numbers are different-> the code back to start
	addi $t0 $t0 -1                   	#$t0--
	j over32bits

equal:
	addi $t1 $t1 -1                   	#counter--, because we find one that the numbera are equal 
                    				#we update the block and code to next 
	addi $a0 $a0 1                    	#$t1++
	addi $a1 $a1 1                    	#$t2++ 
	j over32bits

found:
	la $a0 The_code                   	#print The code is:
	li $v0 4                          
	syscall
	li $t1 6                          	#counter $t1 = 6
	la $a1 basic_code                 	#load the basic code's address into $a1
	
print_the_found_code:
	beq $t1 $zero print_message_found 	#if $t1 == 0, we finish to print the code, jump to print_message_found
	lb $a0 0($a1)                     	#load the current num to $a0
	li $v0 1                          	#print int print the value in $a0
	syscall
	addi $a1 $a1 1                 	        #$a1++
	addi $t1 $t1 -1                         #$t1 -> the counter--
	j  print_the_found_code 

print_message_found:
	la $a0 message_found                    #print The code found!
	li $v0 4 
	syscall
	j exit                                  #finish the program

notFound:
	la $a0 The_code                         #print The code is:
	li $v0 4 
	syscall
	li $t1 6                                #counter $t1 = 6
	la $a1 basic_code                       #load the basic code's address into $a1
	
print_the_notFound_code:
	beq $t1 $zero print_message_not_found   #if $t1 == 0 we finish to print the code, jump to print_message_not_found
	lb $a0 0($a1)                           #load the num to a0  
	li $v0 1                                #print the current number
	syscall
	addi $a1 $a1 1                          #$a1++
	addi $t1 $t1 -1                         #$t6--
	j  print_the_notFound_code 

print_message_not_found:
	la $a0 message_not_found                #print The code not found!
	li $v0 4 
	syscall

exit: