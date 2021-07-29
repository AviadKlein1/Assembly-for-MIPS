add $t0,$zero,$zero     #kga
  addi $t1,$zero,n  
  slti $t2,$t1,0x2 
  bne $t2,$zero,finish 
  srl $t1,$t1,0x1 
  addi $t0,$t0,0x1 
  j loop 
 add $v0,$t0,$zero 