.data

N: .word 5 6 7 8 9 10
sizeOfNs: 6

.text
	la $t1, sizeOfNs
	lw $t1, ($t1)
	la $s0, N
	
loop:
	beq $t1, $zero, done #decriment in the loop	
	
	#do smth with array value, here we print it
	lw $a0, ($s0)
	li $v0, 1
	syscall
	
	#offset pointer
	addi $s0, $s0, 4
	addi $t1, $t1, -1
	j loop
done:
	li $v0, 10
	syscall