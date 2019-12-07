.text
main:
	li $a0 0x0000ff00
	jal modifyDisplay
	li $a0 0x000000ff
	jal modifyDisplay
	li $a0 0x00ff00ff
	jal modifyDisplay

	li $v0 10
	syscall

modifyDisplay: la $t0 0x10010000
	       la $t1 0x10090000
loop:		sw  $a0 0($t0)
		addi $t0 $t0 4
		bne $t0 $t1 loop
		jr $ra

		sw $a0 0($t0)
		sw $a0 4($t0)
		sw $a0 8($t0)
		sw $a0 12($t0)
		sw $a0 16($t0)
		sw $a0 20($t0)
		sw $a0 24($t0)
		sw $a0 28($t0)
