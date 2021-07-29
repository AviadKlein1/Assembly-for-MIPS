#Aviad Klein 315552679
# Exs 3_1
.data 
.word
 arr:   5, 4, 2, 1, 9, 3, 5, 1, 3, 2
 str: .asciiz "The list after bubble sort: "
 s: " "
 
 
.text
     li $a1,10 # אורך המערך
     li $t0,1    # $t0=i           for(i=1;i<10;i++)
      
 for: la $a0,arr           #$a0= כתובת arr
      beq $t0,$a1, print   # i<10
      li $t1,10            #           for(j=10-i;j<0;j--)
      sub $t1,$t1,$t0      # $t1=10-$t0
      addi $t0,$t0,1       #i++
      
     for_in: beq $t1,$zero,for #if($t1==0) finish for_in
            addi $t1,$t1,-1   #j--
            lw $t2,0($a0)     #$t2= [$a0]
            lw $t3,4($a0)     #$t3= [$a0+4]
            
            slt $t4,$t3,$t2   #if($t3<$t2) jump to swap  השוואה
            bne $t4,$zero,swap   
          
            addi $a0,$a0,4    #address++
            j for_in
            
   
  swap: 
  add $t5,$t2,$zero   #temp=$t2
  sw $t3 ,0($a0)      #t3=adress
  sw $t5 ,4($a0)      #t4=address+4
  
  addi $a0,$a0,4    #address++
  j for_in
  
  
  print: 
      li $v0,4       # print str
      la $a0, str
      syscall
      
      la $a2,arr  
      li $t0,10             #counter=#t0
      
     loop:                 #print arr
        beq $t0,$zero,end  # if(counter==0) jump end
        
        li $v0,1        #print    
        lw $a0,0($a2)
        syscall
        
        li $v0,4     #print " "
        la $a0,s
        syscall
        
        addi $a2,$a2,4   #address ++
        addi $t0,$t0,-1  #counter--
        j loop
 
   end: nop