.data
display: .space 0x40000 		# reserve space for 256x256 bitmap display
fname: .asciiz "wall-eImage.bin"	# filename of image to load 

.text
main:	jal loadImage
	jal touchDisplay
	jal processImage
	li $v0, 10		# exit
	syscall

############################################################
# int packARGB( int r, int g, int b, int a ) 
# arguments between 0 and 255, return a<<24 | r<<16 | g<<8 | b;
packARGB:	# TODO!
		sll $v0 $a3 24 #alga or a
		sll $t0 $a0 16 #red or r
		or $v0 $v0 $t0
		sll $t0 $a1 8 #green or g
		or $v0 $v0 $t0
		or $v0 $v0 $a2 #blue or b	
		jr $ra

############################################################
# int argb2abgr( int argb )
# $a0 has ARGB, $v0 will have ABGR
argb2abgr:	# TODO!
		andi $t0 $t0 0x0ff #get the b part
		sll $t0 $t0 16 #put it up in the 3rd byte
		sll $t1 $a0 8
		srl $t1 $t1 24 #now have  r in the lower byte
		sll $t2 $a0 16
		srl $t2 $t2 24 #for green
		sll $t2 $t2 8 #to isolate green byte
		andi $t2 $a0 0xff00 #get the green byte in its position
		jr $ra

###########################################################
# void loadImage()
# Loads 256x256 image data stored in file fname
# Does not close file or check for any errors
loadImage:	li $v0, 13    # open file
		la $a0, fname # address of null-terminated string containing filename 
		li $a1, 0     # flags (0: read, 1: write)
		li $a2, 0     # mode (unused)
		syscall       # v0 will contain file descriptor (negative if error)
		move $t0, $v0 
		li   $v0, 14         # system call for read from file
  		move $a0, $t0        # file descriptor 
  		la   $a1, 0x10010000 # address of buffer to which to write
  		li   $a2, 0x40000    # hardcoded buffer length
		syscall              # $v0 contains number of bytes read (0 if end-of-file, negative if error).
		jr $ra

############################################################
# void touchDisplay()		
# The bitmap display doesn't update properly on load, so this
# function touches (loads and saves) each memory address to 
# refresh the 256x256 display	
touchDisplay:	li $t0, 0x10010000
		li $t1, 0x10050000
loadloop:	lw $t2 ($t0)
		sw $t2, ($t0)
		lw $t2, 4($t0)
		sw $t2, 4($t0)
		lw $t2, 8($t0)
		sw $t2, 8($t0)
		lw $t2, 12($t0)
		sw $t2, 12($t0)
		addi $t0, $t0, 16
		bne $t0, $t1, loadloop
		jr $ra

############################################################
# void processImage()
# calls argb2abgr on every pixel in the 256x256 display	
processImage:	addi $sp, $sp, -12 	# make space on stack
		sw $s0, 0($sp)    	# put $S0 on stack	
		sw $s1, 4($sp)		#put $s1 on stack
		sw $ra, 8($sp)		# save return address		
		la  $s0, 0x10010000  	# start address
		la  $s1, 0x10050000 	# end address
Loop:		lw  $a0, ($s0) 
		jal argb2abgr
		sw $v0, ($s0)
		addi $s0, $s0, 4    	# go to next pixel
		bne $s0, $s1, Loop
		lw $s0, 0($sp)   	# restore $S0
		lw $s1, 4($sp)  	 	# restore $S1
		lw $ra, 8($sp)   	# restore return address
		addi $sp, $sp, 12 	# restore stack pointer
		jr  $ra
