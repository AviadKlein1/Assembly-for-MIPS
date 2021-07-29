#Aviad klein ID 315552679
#Exercise 1.1

.data
block: .word 11,12,13,14,15,15,16,17,18,19,0

.text
la $a0, block
li,$a1,0x10010000
loop: lw $t1,($a0)
sw $t1, ($a1)
beqz $t1,finish
add $a0,$a0,4
add $a1,$a1,4
add $v0, $v0,1
j loop
finish1: li,$v0,10
syscall
