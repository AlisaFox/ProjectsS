.data 
N: .word 5

.text

main:
	la $s0, N
	lw $a0, ($s0)
	jal ifact
	
	#print return value
	move $a0, $v0
	li $v0, 1
	syscall
	
	#exit
	li $v0, 10
	syscall
	
ifact:
	#init accumulator
	li $v0, 1
	#loop template
	li $t0, 1
loop:
	#enter loop
	bgt $t0, $a0, done		
	mul $v0, $v0, $t0 #body of loop
	addi $t0, $t0, 1
	j loop #jump to loop	
done:
	jr $ra	
