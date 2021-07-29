#Aviad Klein 315552679
#Exs 3_2

.data 
.byte 
arr: 3, 6, 12, 24
 
.asciiz
str1: "Invoice series: first num: "
str2: "Engineering series: first num: "
str3:"no series"
str4:"  d= "
str5:"  q= "


.text 

      la $a0,arr
      li $a1,4         
      lb $t0,0($a0)
      lb $t1,1($a0)
      sub $t3,$t1,$t0  #$t3=d 
      li $t5,2  #counter
Invoice:   # check if Invoice
      beq $t5,$zero,print_1   #if counter= 0 jump to print
      addi $t5,$t5,-1       #$t5--
      addi $a0,$a0,1     
      lb $t0,0($a0)
      lb $t1,1($a0)
      sub $t4,$t1,$t0       #$t4=d 
      beq $t4,$t3,Invoice
      j pro
      
 pro:
      la $a0,arr
      li $a1,4
      li $t5,2  #counter
      lb $t0,0($a0)
      lb $t1,1($a0)
      div $t1,$t0  
      mflo $t3       #$t3=q
      j Engineer
      
  Engineer:   # check if Engineer
      beq $t5,$zero,print_2   #if counter= 0 jump to print
      addi $t5,$t5,-1       #$t5--
      addi $a0,$a0,1
      lb $t0,0($a0)
      lb $t1,1($a0)
      div $t1,$t0  
      mflo $t4       #$t4=q
      beq $t4,$t3,Engineer
      j  print_3
 
 
 
 print_1:
     li $v0,4    # print str1
     la $a0, str1
     syscall
     
     la $a0,arr
     
     lb $a0,0($a0) # print value first
     li $v0,1
     syscall
     
     li $v0,4       #print "d"
     la $a0, str4
     syscall
     
     add $a0,$t4,$zero   #print  value of d
     li $v0,1
     syscall
     
     j end
      
 print_2:
     li $v0,4    # print str2
     la $a0, str2
     syscall
     
     la $a0,arr
     
     lb $a0,0($a0) # print value first
     li $v0,1
     syscall
 
     
     li $v0,4       #print "q"
     la $a0, str5
     syscall
     
     
     add $a0,$t4,$zero   #print  value of q
     li $v0,1
     syscall
     
     j end
     
 print_3:    
      li $v0,4    # print str3
     la $a0, str3
     syscall
     
     j end
 end:    
