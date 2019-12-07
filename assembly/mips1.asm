.data

const5: .float 5.0
const9: .float 9.0
const32: .float 32.0

temperature: .float 42.0

.text
main:
	la $t0 temperature
	lwc1 $f12 ($t0)
	jal f2c
	mov.s $f12 $f0
	li $v0 2
	syscall
	li $v0 10 #if this is not here, progran will loop
	syscall
	
f2c:
	la $t0 const5
	lwc1 $f16 ($t0)
	la $t0 const9
	lwc1 $f18 ($t0)
	div.s $f16 $f16 $f18
	la $t0 const32
	lwc1 $f18 ($t0)
	sub.s $f18 $f12 $f18
	mul.s $f0 $f16 $f18
	jr $ra