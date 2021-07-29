# Aviad kleinID 315552679
# Exe 5.2
# The program receives a 32-bit number from the user,
# Converts it to hexadecimal and does one of the following 4 logical operations: xor, or, and, move left.
.data 
input: .asciiz " \n enter a number "
a: .asciiz " input = "
bb: .asciiz  " result = "
error: .asciiz " error number "

.text 
li $t7,0x31    #code 1
li $t8,0x30    #code 2
li $a1,0x48    #code 3
li $a2,0x74    #code 4
main:
la $a0,input  # print "enter a number"
li $v0,4     
syscall 
li $v0,5
syscall 
beq $v0,$zero,end   #if equal to zero end the program.
srl $t0,$v0,24      #$t0 = 8 bits of msb - in t0 we have the code
beq $t0,$t7,code1   # if t0= 31 jump code_1
beq $t0,$t8,code2   # if t0= 30 jump code_2
beq $t0,$a1,code3   # if t0= 48 jump code_3
beq $t0,$a2,code4   # if t0= 74 jump code_4
la $a0,error        # error number
li $v0,4
syscall
j main

code1:
li $t2,195         # set the value in the bitwise: 0,1,6,7 from '0' to '1'
sll $t0,$v0,24     # move number left - now we have 8 digit in msb
srl $t0,$t0,24     # move nuber right - now we have 8 digit in lsb
or $t1,$t0,$t2     # change the value in the temp register
or $t2,$t1,$v0     # change the value in the original register
j print

code2:
li $t2,4294967100 # t0 contain zero in 0,1,6,7 for change '1' to '0'
li $t1,4294967040 # 8 bits in LSB are zero and the msb are 1  
sll $t0,$v0,24    # move number left - now we have 8 digit in msb
srl $t0,$t0,24    # move nuber right - now we have 8 digit in lsb
or $t3,$t0,$t1    # all the msb numbers we change to '1' .
and $t1,$t3,$t2   # 24 bits of msb are 1 and now we change the 8 lsb bits 
and $t2,$t1,$v0   # change the original number
j print

code3:
li $t3,4294967295  # all bits are 1
sll $t0,$v0,16     # move left the number
srl $t1,$t0,24     # then move right the number, 
sll $t8,$t1,8      # t8 - 8.....15 are original number and the rest are 0
xor $t0,$t8,$t3    # now we change the value using xor function.

sll $t1,$v0,24
srl $t3,$t1,24    #t3 - 24 msb bits are zero and 8 lsb bits are, 8 lsb bits of original number
li $t4,4294967040 # 8 bits in LSB is zero others are 1
or $t1,$t4,$t3    #t1 - 24 msb bits are 1 and 8 lsb bits are, 8 lsb bits of original number

li $t6,65535      # 16 lsb bits are 1 and 16 msb bits are zero
srl $t3,$v0,16
sll $t5,$t3,16    #t5 - 16 msb bits = 16 msb bits of original number, and 16 lsb bits are zero
or $t3,$t6,$t5    #t3 - 16 msb bits = 16 msb bits of original number, and 16 lsb bits are 1

and $t6,$t3,$t1   #t6 - take 16 bits msb($t3) and also take 8 bits lsb($t1)
and $t2,$t0,$t6   #t2 - take 8.....15 bits after change and adding t6

j print

code4:
sll $t0,$v0,7     #t0 started in bit 24 of original number
srl $t1,$t0,27    #t0 - 27 msb bits are 0 and 4 bits of msb are 20.....24 of original number
sllv $t2,$v0,$t1  #move $v0 in N places - (N = $t1)

print:
add $t1,$v0,$zero # put the input in $=t1 register.
la $a0,a # cout "before = "
li $v0,4 
syscall 
add $a0,$t1,$zero # cout the the number before the operation.
li $v0,1 
syscall 
la $a0,bb # cout " after = "
li $v0,4 
syscall 
add $a0,$t2,$zero # cout the the number after the operation.
li $v0,34
syscall 
j main
end: