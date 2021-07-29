#Aviad Klein ID 315552679
#Exercise 1.2

.text
loop:  li $v0,5 # get number
syscall
beq $v0,$zero,finish #loops until 0 is received
add $s0, $v0, $zero
 sgt $t1, $s0, -99# bigger the -99
 sltiu $t0 ,$s0,99#smaller then 99
 mul  $t2, $t1, $t0# cheak power of two results
 bne $t2,$zero,good#if the sum is not zero means its under 99 and bigge then -99, jump to good label
j loop
good: add $a0, $a0, $s0  # sum
 bne $t2,$zero,loop # return to loop
finish : li $v0,1 # print
syscall 
li,$v0,10 #end
syscall
