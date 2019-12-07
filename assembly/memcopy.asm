# Open the Data Cache Simulator (under Tools), and connect to MIPS 
# (Direct Mapping, with 8 blocks, block size of 4 words, for 128 bytes)
# Open the Memory Reference Visualization, and connect to MIPS
# (Base address is 0x10010000

.data
A: .space 64
C: .space 64
B: .space 64

# Consider the following memory copy calls:
#
# - copying C to A, direct map works well because the addresses map to 
#   different blocks
#
# - copying B to A, direct map has B[0] and A[0] mapping to the same block
#   so we never get a cache hit (loading B[0] brings in memory to block 0,
#   but then writing to A[0] needs to write to different memory that also
#   maps to block 0.
#
# - Copying B to A with direct mapped cache, but with a partially unrolled
#   loop allows us to avoid the conflicts between the two memory spaces that
#   map to the same block.  The trick is to read several words from the block
#   before trying to write to a different block.  See memcopy2 and memcopy4 
#
# In these examples, A, B, and C all start nicely at the first address of a 
# a block, but that need not be the case, which can influence the performance
# of the memory copy with a direct mapped cache.  Try adding small amounts of 
# space (multiples of 4) between A and B, or between B and C and observe what 
# happens.  What do the memory access patterns look like?  What is the Cache 
# Hit Rate shown in the simulator?  

.text
	la $a0 A
	la $a1 C
	li $a2 16 # number of words to copy
	jal memcopy
	li $v0 10
	syscall

#############################################
# void memcopy( int* A, int* B, int count )  
# copy B to A one word at a time, count words
memcopy:		beq $zero $a2 done
		lw $t0 0($a1)
		sw $t0 0($a0)
		addi $a0 $a0 4
		addi $a1 $a1 4
		addi $a2 $a2 -1
		j memcopy
done:		jr $ra
		
#############################################
# void memcopy( int* A, int* B, int count )  
# copy B to A two words at a time, count words must be multiple of 2
memcopy2:	beq $zero $a2 done2
		lw $t0 0($a1)
		lw $t1 4($a1)
		sw $t0 0($a0)
		sw $t1 4($a0)
		addi $a0 $a0 8
		addi $a1 $a1 8
		addi $a2 $a2 -2
		j memcopy2
done2:		jr $ra

#############################################
# void memcopy( int* A, int* B, int count )  
# copy B to A two words at a time, count words must be multiple of 4
memcopy4:	beq $zero $a2 done4
		lw $t0 0($a1)
		lw $t1 4($a1)
		lw $t2 8($a1)
		lw $t3 12($a1)
		sw $t0 0($a0)
		sw $t1 4($a0)
		sw $t2 8($a0)
		sw $t3 12($a0)
		addi $a0 $a0 16
		addi $a1 $a1 16
		addi $a2 $a2 -4
		j memcopy4
done4:		jr $ra
