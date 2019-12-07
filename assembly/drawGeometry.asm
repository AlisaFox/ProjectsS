##
##  Alisa Gagina 260770497
##

.data  # start data segment with bitmapDisplay so that it is at 0x10010000
.globl bitmapDisplay # force it to show at the top of the symbol table
bitmapDisplay:    .space 0x80000  # Reserve space for memory mapped bitmap display
bitmapBuffer:     .space 0x80000  # Reserve space for an "offscreen" buffer
width:            .word 512       # Screen Width in Pixels, 512 = 0x200
height:           .word 256       # Screen Height in Pixels, 256 = 0x100

lineCount   :     .space 4        # int containing number of lines
lineData:         .space 0x4800   # space for teapot line data
lineDataFileName: .asciiz "teapotLineData.bin"
errorMessage:     .asciiz "Error: File must be in directory where MARS is started."

# TODO: declare other data you need or want here!
testMatrix: .float
1.0 2.0 3.0 4.0
5 6 7 8.0
9 10 11 12
13 14 15 16
testVec1: .float 1 0 0 0
testVec2: .float 0 1 0 0
testVec3: .float 0 0 1 0
testVec4: .float 2 20 0 1
testResult: .space 16
spaceString:  .asciiz " "
newlineString:  .asciiz "\n"

M: .float
331.3682, 156.83034, -163.18181, 1700.7253
-39.86386, -48.649902, -328.51334, 1119.5535
0.13962941, 1.028447, -0.64546686, 0.48553467
0.11424224, 0.84145665, -0.52810925, 6.3950152
Mp: .space 16

R: .float
0.9994 0.0349 0 0
-0.0349 0.9994 0 0
0 0 1 0
0 0 0 1

.text
##################################################################
# main entry point
# We will use save registers here without saving and restoring to
# the stack only because this is the main function!  All other 
# functions MUST RESPECT REGISTER CONVENTIONS
main:	la $a0 lineDataFileName
	la $a1 lineData
	la $a2 lineCount
	jal loadLineData
	la $s0 lineData 	# keep buffer pointer handy for later
	la $s1 lineCount
	lw $s1 0($s1)	   	# keep line count handy for later

	# TODO: write your test code here, as well as your final 
	# animation loop.  We will likewise test individually 
	# the functions that you implement below.

#test clearBuffer
	#li $a3 0x000fff00
	#jal clearBuffer

#test copyBuffer
	#jal copyBuffer

#test drawPoint	
	#li $a0 500
	#li $a1 0
	#jal drawPoint

#test drawLine
	#li $a0 30
	#li $a1 92
	#li $a2 500
	#li $a3 2
	#jal drawLine

#test mulMatrixVec		
	#la $a0 testMatrix
	#la $a1 testVec4
	#la $a2 testResult
	#jal mulMatrixVec

#test point2Display		
#	la $a0 testVec4
#	jal point2Display
#	la $a0, ($v0)
#	la $a1, ($v1)
#	jal drawPoint


#test draw3DLines
#	la $a0, ($s0)
#	la $a1, ($s1)
#	jal draw3DLines

#everything test, uncomment $t9 if want limited amount of rotations, set at inf currently
	#li $t9 9
	mainloop:
		li $a0 0x00000000
		jal clearBuffer
		la $a0 ($s0)
		la $a1 ($s1)
		jal draw3DLines
		jal copyBuffer
		la $a0 ($s0)
		la $a1 ($s1)
		jal rotate3DLines
		#addi $t9, $t9, -1
		#bne $0 $t9 mainloop
		beq $0 $0 mainloop
		
	li $v0, 10      # load exit call code 10 into $v0
	syscall         # call operating system to exit
        
      

###############################################################
# void clearBuffer( int colour )
clearBuffer:
	la $t0 0x10090000
	la $t1 0x10110000
	loopa:	sw $a0 0($t0)
		addi $t0 $t0 4
		bne  $t0 $t1 loopa
		jr $ra

###############################################################
# copyBuffer()
copyBuffer:
	la $t2 bitmapBuffer
	la $t0 bitmapDisplay
	li $t1 0
	loopb:
		lw $t1 ($t2)	
		sw $t1 ($t0)
		addi $t2 $t2 4
		addi $t0 $t0 4
		bne $t0, 0x10090000, loopb
		jr $ra

###############################################################
# drawPoint( int x, int y ) 
drawPoint: 
	li $t2 0x10090000 #base address (replace 9 with 1 for live updates)
	#$a0 is width, $a1 is height
	# base address + 4(x+wy)
	li $t0,0
	# if width is out of bounds, throws to exit
	bgt $a0, 511, exit
	bltz $a0, exit
	# if height is out of bounds, throws to exit
	bgt $a1, 255, exit
	bltz $a1, exit
	#find the address
	li $t3, 0
	sll  $t3, $a1, 9
	add $t3, $t3, $a0
	sll $t3, $t3, 2
	add $t3, $t3, $t2
	
	#colour in with green
	li $t1, 0x0000ff00
	sw $t1, 0($t3)
	exit:		jr $ra

###############################################################
# void drawline( int x0, int y0, int x1, int y1 )

drawLine:
	# $a0 is x0, 1 is y0, 2 is x1, 3 is y1
	li $t6, 1 #offsetX
	li $t7, 1 #offsetY
	la $t2, ($a0) #x
	la $t3, ($a1) #y
	sub $t4, $a2, $a0 #dx
	sub $t5, $a3, $a1  #dy
	bgez $t4, skipx  # if dx is bigger or equal to zero skip
		sub $t4, $0, $t4 #reverse dx
		li $t6, -1 #set offsetX to -1
	skipx:
	bgez $t5, skipy  # if does not fit source code condition, skip
		sub $t5, $0, $t5 #reverse dy
		li $t7, -1 #set offsetY to -1		
	skipy:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s2 4($sp)    # save x 
	add  $s2 $t2 $0 
	sw $s3 8($sp)    # save y 
	add  $s3 $t3 $0 
	la $a0 ($s2)
	la $a1 ($s3)
	jal drawPoint
	bge $t5 $t4 else
		la $t8, ($t4) # $t8 is error 
		xloop:
			beq $s2 $a2 done #if x == x1 don't go into the while loop
			sub $t8, $t8, $t5
			sub $t8, $t8, $t5
			bgez $t8 xloopskip
				add $s3 $s3 $t7
				add $t8 $t8 $t4
				add $t8 $t8 $t4
			xloopskip:
			add $s2 $s2 $t6
			la $a0 ($s2)
			la $a1 ($s3)
			jal drawPoint
			bne $s2 $a2 xloop	
			j done #needs to be here as we don't want to go into the else loop
	else:
		la $t8, ($t5) # $t8 is error 
		yloop:
			beq $s3 $a3 done #if y == y1 don't go into the while loop
			sub $t8, $t8, $t4
			sub $t8, $t8, $t4
			bgez $t8 yloopskip
				add $s2 $s2 $t6
				add $t8 $t8 $t5
				add $t8 $t8 $t5
			yloopskip:
			add $s3 $s3 $t7
			la $a0 ($s2)
			la $a1 ($s3)
			jal drawPoint
			bne $s3 $a3 yloop
	done:		
	lw $s2 4($sp)
	lw $s3 8($sp)
	lw $ra 0($sp)
	addi $sp $sp 12
	jr $ra
			
###############################################################
# void mulMatrixVec( float* M, float* vec, float* result )
mulMatrixVec:
	#a0 will be the matrix
	# a1 multiplier, a2 result
	
	# I did not want to think, so I just hard coded the matrix multiplication. 
	#(Hey, assignment spec said that we could try to do this without a loop)
	
	#for 0($a2)
		lwc1 $f4, 0($a0)         #load first entry of matrix
		lwc1 $f6, 0($a1)         #load first entry of multplier
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 4($a0)
		lwc1 $f6, 4($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 8($a0)
		lwc1 $f6, 8($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 12($a0)
		lwc1 $f6, 12($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
	swc1 $f10, 0($a2)         #update result vector     
	neg.s $f12, $f10          #need to reset the result of the add / mult back to 0
	add.s $f10, $f10, $f12

#for 4($a2)
		lwc1 $f4, 16($a0)
		lwc1 $f6, 0($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 20($a0)
		lwc1 $f6, 4($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 24($a0)
		lwc1 $f6, 8($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 28($a0)
		lwc1 $f6, 12($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
	swc1 $f10, 4($a2)
	neg.s $f12, $f10
	add.s $f10, $f10, $f12
#for 8($a2)
		lwc1 $f4, 32($a0)
		lwc1 $f6, 0($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 36($a0)
		lwc1 $f6, 4($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 40($a0)
		lwc1 $f6, 8($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 44($a0)
		lwc1 $f6, 12($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
	swc1 $f10, 8($a2)
	neg.s $f12, $f10
	add.s $f10, $f10, $f12
	
#for 12($a2)
		lwc1 $f4, 48($a0)
		lwc1 $f6, 0($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 52($a0)
		lwc1 $f6, 4($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 56($a0)
		lwc1 $f6, 8($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
		lwc1 $f4, 60($a0)
		lwc1 $f6, 12($a1)
		mul.s $f8, $f4, $f6
	add.s $f10, $f8, $f10
	swc1 $f10, 12($a2)
	neg.s $f12, $f10
	add.s $f10, $f10, $f12

#algorithm to print the result matrix copied from class
#comment the below command if want to print the result of the matrix
beq $t0 $t0 donem
printFloatVector:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s5, 4($sp)
	la $s5, 0($a0) 
	lwc1 $f12, 0($s5)
	jal printFloat 
	jal printSpace
	lwc1 $f12, 4($s5)
	jal printFloat
	jal printSpace
	lwc1 $f12, 8($s5)
	jal printFloat
	jal printSpace
	lwc1 $f12, 12($s5)
	jal printFloat
	jal printNewLine
	lw $ra, 0($sp)
	lw $s5, 4($sp)
	addi $sp, $sp, 8
printSpace:
	li $v0, 4
	la $a0, spaceString
	syscall
	jr $ra
printNewLine:
	li $v0, 4 
	la $a0, newlineString
	syscall
	jr $ra
printFloat: # in $f12
	li $v0, 2
	syscall
	jr $ra
donem:	
		jr $ra
        
###############################################################
# (int x,int y) = point2Display( float* vec )
point2Display:  
 
		lwc1 $f4, 0($a0)   #x
		lwc1 $f6, 4($a0)   #y
		lwc1 $f8, 12($a0)  #w
		div.s $f10, $f4, $f8
		cvt.w.s $f0, $f10
		mfc1 $v0, $f0  #x/w in int
		div.s $f10, $f6, $f8
		cvt.w.s $f0, $f10
		mfc1 $v1, $f0  #y/w in int
	        jr $ra
        
###############################################################
# draw3DLines( float* lineData, int lineCount )

#READ ME	READ ME		READ ME		READ ME		READ ME		READ ME
#Sooooo the teapot is messed up once you run this method. Some of the lines are out of places, 
#slightly longer than they need to be, etc
#I am unsure as to what causes this, there is a bug either in the drawLine method or point2Display method
#Another possibilty is that I messed up with using the stack pointer in one of these methods somewhere
#I'm also pretty sure that the single horizontal line that appears comes from a bug in drawLine

draw3DLines:
		addi $sp $sp -20 #stack
		sw $ra 0($sp)
		sw $s4, 4($sp)
		add  $s4 $a0 $0
		la $t0 16($a0)
		sw $s5, 8($sp) 
		add  $s5 $t0 $0
		sw $s6, 12($sp)
		add $s6 $a1, $0
		sw $s7, 16($sp)
		li $s7, 0 #counter
	loop3D:
		la $a0 M
		la $a1 ($s4)
		la $a2 Mp
		jal mulMatrixVec
		la $a0 Mp
		jal point2Display
		la $t1, ($v0) #first x
		la $t2, ($v1) #first y
		la $a0 M
		la $a1 ($s5)
		la $a2 Mp
		jal mulMatrixVec
		la $a0 Mp
		jal point2Display
		la $t3, ($v0) #second x
		la $t4, ($v1) #second y
		la $a0, ($t1)
		la $a1, ($t2)
		la $a2, ($t3)
		la $a3, ($t4)
		jal drawLine 
		addi $s7 $s7 1
		addi $s4 $s4 32
		addi $s5 $s5 32
		bne  $s7 $s6 loop3D
	lw $s7, 16($sp)
	lw $s6, 12($sp)
	lw $s5, 8($sp)
	lw $s4, 4($sp)
	lw $ra 0($sp)
	addi $sp $sp 20
                jr $ra

###############################################################
# rotate3DLines( float* lineData, int lineCount )

#this one works perfectly if we discount the ugly teapot

rotate3DLines:
	sub $t1, $0, $a1 #counter (have to start with negative line count as loop increases with 16, 32
	addi $sp $sp -8
	sw $ra 0($sp)
	sw $s0, 4($sp) 
	add $s0 $a0 $0
	loopr:
		beq $t1 $a1 doner
		la $a1 ($s0)
		la $a2 ($s0) #load result back into lineData
		la $a0, R
		jal mulMatrixVec
		addi $t1 $t1 1
		addi $s0, $s0, 16
		bne $t1 $s1 loopr	
	doner:
		lw $ra 0($sp)
		lw $s0, 4($sp)
		addi $sp $sp 8
			jr $ra        
        
        
        
        
        
###############################################################
# void loadLineData( char* filename, float* data, int* count )
#
# Loads the line data from the specified filename into the 
# provided data buffer, and stores the count of the number 
# of lines into the provided int pointer.  The data buffer 
# must be big enough to hold the data in the file being loaded!
#
# Each line comes as 8 floats, x y z w start point and end point.
# This function does some error checking.  If the file can't be opened, it 
# forces the program to exit and prints an error message.  While other
# errors may happen on reading, note that no other errors are checked!!  
#
# Temporary registers are used to preserve passed argumnets across
# syscalls because argument registers are needed for passing information
# to different syscalls.  Temporary usage:
#
# $t0 int pointer for line count,  passed as argument
# $t1 temporary working variable
# $t2 filedescriptor
# $t3 number of bytes to read
# $t4 pointer to float data,  passed as an argument
#
loadLineData:	move $t4 $a1 		# save pointer to line count integer for later		
		move $t0 $a2 		# save pointer to line count integer for later
			     		# $a0 is already the filename
		li $a1 0     		# flags (0: read, 1: write)
		li $a2 0     		# mode (unused)
		li $v0 13    		# open file, $a0 is null-terminated string of file name
		syscall			# $v0 will contain the file descriptor
		slt $t1 $v0 $0   	# check for error, if ( v0 < 0 ) error! 
		beq $t1 $0 skipError
		la $a0 errorMessage 
		li $v0 4    		# system call for print string
		syscall
		li $v0 10    		# system call for exit
		syscall
skipError:	move $t2 $v0		# save the file descriptor for later
		move $a0 $v0         	# file descriptor (negative if error) as argument for write
  		move $a1 $t0       	# address of buffer to which to write
		li  $a2 4	    	# number of bytes to read
		li  $v0 14          	# system call for read from file
		syscall		     	# v0 will contain number of bytes read
		
		lw $t3 0($t0)	     	# read line count from memory (was read from file)
		sll $t3 $t3 5  	     	# number of bytes to allocate (2^5 = 32 times the number of lines)			  		
		
		move $a0 $t2		# file descriptor
		move $a1 $t4		# address of buffer 
		move $a2 $t3    	# number of bytes 
		li  $v0 14           	# system call for read from file
		syscall               	# v0 will contain number of bytes read

		move $a0 $t2		# file descriptor
		li  $v0 16           	# system call for close file
		syscall		     	
		
		jr $ra        
