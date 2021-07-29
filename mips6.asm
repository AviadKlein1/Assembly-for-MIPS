#Aviad klein ID 315552679

.data
a: .asciiz "enter data for "
a1: .asciiz "enter a number: "
dim: .asciiz "enter dim data for "
matrixA: .asciiz "matrix A: "
matrixB: .asciiz "matrix B: "
matrixC: .asciiz "matrix C: "
row: .asciiz "Please enter dim of row: "
col: .asciiz "Please enter dim of col: "
space: .asciiz "\t"
newRow: .asciiz "\n"
inputError: .asciiz "Error row A not equal to column B!"
again: .asciiz "give dimensiononal again: "
.byte
A: .space 100
B: .space 100
C: .space 100
.text

main:
jal input
la $a0 A
la $a1 B
la $a2 C
jal multMatrix
jal printMatrixC
j enddd

input: 
addi $sp $sp -4
sw $ra 0($sp)     # save ra
jal inputDim      #read the dim of two matrix
la $a0 A          #save pointer to matrix A
add $a1 $s0 $zero #a1 = rows of A
add $a2 $s1 $zero #a2 = column of A
la $a3 matrixA    #for print matrix A
jal EnterToMatrix
la $a0 A           #save pointer to matrix A
add $a1 $s0 $zero  #a1 = rows of A
add $a2 $s1 $zero  #a2 = column of A
jal printTheMatrix #print matrix A

la $a0 B            #save pointer to matrix B
add $a1 $s2 $zero   #a1 = rows of B
add $a2 $s3 $zero   #a2 = column of B
la $a3 matrixB      #for print matrix B
jal EnterToMatrix
la $a0 B           #save pointer to matrix B
add $a1 $s2 $zero  #a1 = rows of B
add $a2 $s3 $zero  #a2 = column of B
jal printTheMatrix #print matrix B

lw $ra 0($sp)      #restore from stack
addi $sp $sp 4
jr $ra

inputDim:
 li   $v0, 4
 la   $a0, dim
 syscall
 la   $a0, matrixA
 syscall	
 la   $a0, newRow
 syscall	
 la   $a0, space
 syscall
 # get matrix A's row number.
 la   $a0, row
 syscall
 # get integer and store in register s0.
 li   $v0, 5
 syscall
 add  $s0 $v0 $zero 
 li   $v0, 4
 la   $a0, space
 syscall
 # get matrix A's col number.
 la   $a0, col
 syscall
 # get integer and store in register s1.
 li   $v0, 5
 syscall
 add  $s1 $v0 $zero 
 li   $v0, 4
 la   $a0, dim
 syscall
 la   $a0, matrixB
 syscall
 la   $a0, newRow
 syscall
 la   $a0, space
 syscall
 # get matrix B's row number.
 la   $a0, row
 syscall
 # get integer and store in register s2.
 li   $v0, 5
 syscall
 add  $s2 $v0 $zero 
 li   $v0, 4
 la   $a0, space
 syscall
 # get matrix B's col number.
 la   $a0, col
 syscall
 # get integer and store in register s3.
 li   $v0, 5
 syscall
 add  $s3 $v0 $zero
 li   $v0, 4
 la   $a0, newRow
 syscall
 bne $s1 $s2 notEqual
 jr $ra # return from recorsive
 notEqual:
  # bad input error message.
  la   $a0, inputError
  syscall
  # go to new line.
  la   $a0, newRow
  syscall
  # ask user to repeat input again.
  la   $a0, again
  syscall
  # go to new line.
  la   $a0, newRow
  syscall
  j inputDim
 
EnterToMatrix:  
 addi $sp $sp -24 # save 6 place
 sw $t5 20($sp)
 sw $t4 16($sp)
 sw $t3 12($sp)
 sw $t2 8($sp)
 sw $t1 4($sp)
 sw $t0 0($sp)	
 add $t0 $a0 $zero #t0 = pointer matrix 
 add $t1 $a1 $zero #t1 =  row number
 add $t2 $a2 $zero #t2 =  column number
 addi $t3 $zero 0  # i index
 addi $v0 $zero 4  
 la $a0 a          #print enter: "enter data for "
 syscall
 add $a0 $a3 $zero
 syscall
 la $a0 newRow
 syscall
 loopI: 
  beq $t3 $t1 endInsert # if (i== row of matrix) then jump insert_end
  addi $t4 $zero 0	# j index 
  loopJ:
   beq $t4 $a2 endRow   # if (j == column of matrix) then jump row_end
   li $v0, 4
   la $a0 a1	
   syscall            #print "Please enter a number"						
   li   $v0, 5        # read integer and store in register v0.
   syscall
   mul $t5 $t3 $a2	# t5 = index i * column size
   add $t5 $t5 $t4	# add to t5 number of index j(column)
   add $t5 $t5 $t0	# t5 = pointer to matrix in location[i,j]
   sb $v0 0($t5)	# add input to matrix in location[i,j]
   addi $t4 $t4 1	# j index++.
   j loopJ
  endRow: 
  addi	$t3, $t3, 1      # i++ (next row) - byte (+1)			
  j loopI
 endInsert:              # after finish all rows, then restore from stack all arguments to registers
 lw $t5 20($sp)
 lw $t4 16($sp)
 lw $t3 12($sp)
 lw $t2 8($sp)
 lw $t1 4($sp)
 lw $t0 0($sp)
 addi $sp $sp 24
 jr $ra
		
printTheMatrix:    #print a matrix 
 addi $sp $sp -24
 sw $t4 20($sp)
 sw $t3 16($sp)
 sw $t2 12($sp)
 sw $t1 8($sp)
 sw $t0 4($sp)
 sw $ra 0($sp)
 add $t0 $a0 $zero #t0 = pointer matrix 
 add $t1 $a1 $zero #t1 = row number matrix
 add $t2 $a2 $zero #t2 = column number matrix
 addi $t3 $zero 0	# i index
 forI:
  beq $t3 $t1 print_end #if(i == row number) then jump print_end
  addi $t4 $zero 0	# j index 
  forJ:
   beq $t4 $t2 endOfRow #if(j == column number) then jump print_end
   li $v0, 4
   la $a0, space	# go 1 tap forward
   syscall
   add $a0 $t0 $zero    #a0 = point to matrix
   add $a1 $t3 $zero    #a1 = index i
   add $a2 $t4 $zero    #a2 = index j
   add $a3 $t2 $zero    #a3 = number of column
   jal returnValue	# get the cell data using get cell function.
   add $a0 $v0 $zero    #a0 = the value in matrix[i,j]
   addi $v0 $zero 1 
   syscall              # printing the data we got from the cell.
   addi $t4 $t4 1       # j index++.
   j forJ
  endOfRow:        # inner loop ended so we need to finish the outer loop with i++ and loop back jump command.
  addi $t3, $t3, 1 # i++ (next row) - byte (+1)
  li $v0, 4
  la $a0 newRow	   # start a new line.
  syscall
  syscall
  j forI
 print_end:         # after finish all rows, then restore from stack all arguments to registers
  lw $t4 20($sp)
  lw $t3 16($sp)
  lw $t2 12($sp)
  lw $t1 8($sp)
  lw $t0 4($sp)
  lw $ra 0($sp)
  addi $sp $sp 24
  jr $ra	
multMatrix:        #mult between two matrix
 addi $sp $sp -44
 sw $ra 40($sp)
 sw $t9 36($sp)
 sw $t8 32($sp)
 sw $t7 28($sp)
 sw $t6 24($sp)
 sw $t5 20($sp)
 sw $t4 16($sp)
 sw $t3 12($sp)
 sw $t2 8($sp)
 sw $t1 4($sp)
 sw $t0 0($sp)
 add $t0 $a0 $zero 	#t0 = pointer to A
 add $t1 $a1 $zero 	#t1 = number row A
 add $t2 $a2 $zero      #t2 = number column A
 add $t3 $s3 $zero      #t3 = number columns of B
 li $t4 0	        # i index of row.
 loop1:                 # run on every rows
 beq $t4 $s0 finishMult #if i == number of rows
 li $t5 0	        # j index of col = 0.
 loop2: 		# run on column
 li $t6 0		# sum variable.
 beq $t5 $s3 finishColumn #if j == number of columns B
 li $t7 0		# index w for row iteration
 loop3:			#run on two values in matrix A,B and mult
 beq $t7 $s1 finishSum #if we done the current row
 add $a0 $t0 $zero 	#pointer to matrix A
 add $a1 $t4 $zero 	#current i (index)
 add $a2 $t7 $zero 	#current w - index that run in one row
 add $a3 $s1 $zero 	#number of columns of A
 jal returnValue
 add $t8 $v0 $zero 	# cell from matrix A at index: [i,k] ([ROW,INNER])
 add $a0 $t1 $zero 	# a0 = number of row matrix A
 add $a1 $t7 $zero 	# a1 = index w in row iteration
 add $a2 $t5 $zero 	# a2 = j index
 add $a3 $s3 $zero 	# a3 = number of column matrix B
 jal returnValue
 mul $t9 $v0 $t8 	# multification between cell in matrix A to Cell in matrix B
 add $t6 $t6 $t9 	# t6 = sum of product
 addi $t7 $t7 1
 j loop3		#jump to next number in row 
 finishSum:
 mul $t8 $t4 $s3	# add to t8 the value of: [i index] * [col size].
 add $t8 $t8 $t5 	# add to t8 the value of: [[i index] * [col size]] + [j index].
 add $t8 $t8 $t2 	# add to t0 the value of: [[[i index] * [col size]] + [j index]] + [address of the matrix].
 sb $t6 0($t8) 		#insert the number to matrix C[i,j]
 addi $t5 $t5 1
 j loop2		#jump to next row
 finishColumn:
 addi $t4 $t4 1
 j loop1
 finishMult: 		#restore from stack
 lw $ra 40($sp)
 lw $t9 36($sp)
 lw $t8 32($sp)
 lw $t7 28($sp)
 lw $t6 24($sp)
 lw $t5 20($sp)
 lw $t4 16($sp)
 lw $t3 12($sp)
 lw $t2 8($sp)
 lw $t1 4($sp)
 lw $t0 0($sp)
 addi $sp $sp 44
 jr $ra
	  
returnValue:		 #return value from matrix[i,j]
 addi $sp $sp -4
 sw $t0 0($sp) 		#save in stack
 mul $t0 $a1 $a3 	# t0 = index i * column size
 add $t0 $t0 $a2 	# add to t0 number of index j(column)
 add $t0 $t0 $a0 	# t0 = pointer to matrix in location[i,j]
 lb $v0 0($t0)   	# load the data from cell of index i,j in the given matrix (byte size).
 lw $t0 0($sp)          # restore from stack 	
 addi $sp $sp 4
 jr $ra 		# go back to the calling function.
printMatrixC:
 addi $sp $sp -4
 sw $ra 0($sp)
 la $a0 matrixC
 li $v0 4
 syscall
 la $a0 newRow		# start a new line.
 syscall
 la $a0 C
 add $a1 $s0 $zero
 add $a2 $s3 $zero
 jal printTheMatrix 	#print matrix C
 lw $ra 0($sp)	
 addi $sp $sp 4
 jr $ra
enddd:
 li $v0 10
 syscall
