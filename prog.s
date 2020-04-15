
# COMP1521 19t2 ... Game of Life on a NxN grid
#
# Written by <<Tai-Jung>>, June 2019

## Requires (from `boardX.s'):
# - N (word): board dimensions
# - board (byte[][]): initial board state
# - newBoard (byte[][]): next board state

## Provides:
    
	.globl	main
	.globl	decideCell
	.globl	neighbours
	.globl	copyBackAndShow


########################################################################
# .TEXT <main>
# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $s4, $sp
# Uses:		$s0, $s1, $s2, $s3, $s4, $a0, $a1, $v0, $t1, $t2, $t3, $t4, $t5, $t6
# Clobbers:	$a0, $t2, $t3, $t4, $t5, $t6
        

# Locals:	
#	- `maxiters' in $s0 (from user input)
#	- `n' in $s1 
#	- `i' in $s2
#	- `j' in $s3
#       - `N' in $s4 (from #include)
# Structure:
#	main
#	-> [prologue]
#	-> loop1
#               -> loop2
#                       -> loop3
#                       => end_loop3
#               => end_loop2
#       => end_loop1
#	-> [epilogue]
        .data
print1: .asciiz "# Iterations: "
print2: .asciiz "=== After iteration "
print3: .asciiz "===\n" 
	.text
main:
        sw	$fp, -4($sp)	# setup stackframe
	la	$fp, -4($sp)	
	sw	$ra, -4($fp)	
	sw	$s0, -8($fp)	
	sw	$s1, -12($fp)	
	sw      $s2  -16($fp) 
	sw      $s3  -20($fp) 
	sw      $s4  -24($fp)
	sw      $s5  -28($fp) 
	addi	$sp, $sp, -32	
	
	        
        la      $a0, print1   # load the argument string
        li      $v0, 4        # printf("# Iterations: ")
        syscall
        
        li      $v0, 5     # scanf ("%d", &maxiters);
        syscall
        move    $s0, $v0   #s0 = maxiters
        
        
        li      $s1, 1     # int n = 1;
        li      $s2, 0     # int i = 0;
        li      $s3, 0     # int j = 0; 
        lw      $s4, N     # s4 = N   
loop1:
        bgt     $s1, $s0, end_loop1     # for (int n = 1; n <= maxiters)
        li      $s2, 0     # int i = 0;   
loop2:   
        bge     $s2, $s4, end_loop2     # for (int i = 0; i < N)
        li      $s3, 0     # int j = 0; 
loop3:
        bge     $s3, $s4, end_loop3     # for (int j = 0; j < N)
        
        move    $a0, $s2
        move    $a1, $s3
        jal     neighbours
        move    $s5, $v0          # int nn = neightbours (i, j);
        
        la      $t2, board        # load address board[0]
        mul     $t3, $s2, $s4     # t3 = i * N
        add     $t4, $t3, $s3     # t4 = t3 + j
        add     $t5, $t2, $t4     # t5 = board[0+(i*N+j)]
        lb      $t6, 0($t5)        
        
        move    $a0, $t6          # newBoard[i][j] = decideCell (board[i][j], nn)
        move    $a1, $s5
        jal     decideCell 
        la      $t2, newBoard
        add     $t5, $t2, $t4
        sb      $v0, 0($t5)

        addi    $s3, $s3, 1      # j++;
        j       loop3
end_loop3:       
        addi    $s2, $s2, 1      # i++
        j       loop2
end_loop2:
        la      $a0, print2   # printf("=== After iteration")
        li      $v0, 4
        syscall       
         
        move    $a0, $s1    # printf("%d", n) 
        li      $v0, 1
        syscall
         
        la      $a0 print3    # printf("===\n")
        li      $v0 4
        syscall 
         
        jal     copyBackAndShow  # copyBackAndShow();
        nop
         
        addi    $s1, $s1, 1     # n++;
         
        j loop1
end_loop1:
        #tear down the stack frame
        lw      $s5  -28($fp)
        lw      $s4  -24($fp) 
	lw      $s3  -20($fp)
        lw	$s2, -16($fp)	
	lw	$s1, -12($fp)	
	lw	$s0, -8($fp)	
	lw	$ra, -4($fp)	
	la	$sp, 4($fp)	
	lw	$fp, ($fp)	
	
        li      $v0, 0
        jr      $ra
        
# Frame:	$fp, $ra, $s0, $sp
# Uses:		$s0, $s1, $s2, $s3, $s4, $a0, $a1, $v0, $t1, $t2, $t3, $t4, $t5, $t6
# Clobbers:	$t0, $t1, $t2

# Locals:	
#	- `ret' in $s0 


# Structure:
#	main
#	-> [prologue]
#	-> IF
#               -> if_1
#               -> else_1
#               -> if_or
#               -> else_2
#       -> ELSE_1
#       -> ELSE_2
#	-> [epilogue]

# Code:

	# Your main program code goes here.  Good luck!

decideCell:
        sw	$fp, -4($sp)	        # setup stackframe
	la	$fp, -4($sp)	
	sw	$ra, -4($fp)	
	sw	$s0, -8($fp)	
	addi	$sp, $sp, -12	
	
IF:
	li      $t0, 1          
	bne     $a0, $t0, ELSE_1        # if (old == 1)
if_1:
	li      $t1, 2
	bge     $a1, $t1, else_1        # if (nn < 2)
	li      $s0, 0                  # ret = 0
	j       END
else_1:                                
        li      $t1, 2                  
        li      $t2, 3
        beq     $a1, $t1, if_or         # else if (nn == 2 || nn == 3)
        bne     $a1, $t2, else_2        
if_or:
        li      $s0, 1                  # ret = 1
        j       END
else_2:                                 # else
        li      $s0, 0                  # ret = 0
        j       END
ELSE_1:        
        li      $t1, 3          
        bne     $a1, $t1, ELSE_2        # else if (nn == 3)
        li      $s0, 1                  # ret = 1
        j       END 
ELSE_2:                                 # else
        li      $s0, 0                  # ret = 0
END:
        move    $v0, $s0
        
        lw	$s0, -8($fp)	        # tear down stackframe
	lw	$ra, -4($fp)	
	la	$sp, 4($fp)	
	lw	$fp, ($fp)	
	
        jr      $ra                         
# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $sp
# Uses:		$s0, $s1, $s2, $s3, $a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $t5
# Clobbers:	$t0, $t1, $t2, $t3, $t4, $t5
        

# Locals:	
#	- `nn' in $s0 
#	- `x' in $s1 
#	- `y' in $s2
#       - `N' in $s3 (from #include)
# Structure:
#	main
#	-> [prologue]
#	-> n_loop1
#               -> n_loop2
#                       -> n_if_1
#                       -> n_if_2
#                       -> n_if_3
#                       -> continue
#                       -> n_if_4
#               => n_end_loop2
#       => n_end_loop1
#	-> [epilogue]    
	

neighbours:
        sw	$fp, -4($sp)	# setup stackframe
	la	$fp, -4($sp)	
	sw	$ra, -4($fp)	
	sw	$s0, -8($fp)	
	sw      $s1, -12($fp)
	sw      $s2, -16($fp)
	sw      $s3, -20($fp)
	addi	$sp, $sp, -24	
	 
	li      $s0, 0          # int nn = 0
	li      $t0, 1          # t0 is loop stopper
	li      $s1, -1         # int x = -1
	li      $s2, -1         # int y = -1
	lw      $s3, N          # s3 = N
n_loop1:
	bgt     $s1, $t0, n_end_loop1   # for (int x = -1; x <= 1)
	li      $s2, -1                 # int y = -1
n_loop2:        
        bgt     $s2, $t0, n_end_loop2   # for (int y = -1; y <= 1)

n_if_1:
        add     $t1, $a0, $s1           # t1 = i + x
        addi    $t2, $s3, -1            # t2 = N - 1
        blt     $t1, $zero, continue    # if (i + x < 0 || i + x > N - 1) continue
        bgt     $t1, $t2, continue         	

n_if_2:
        add     $t1, $a1, $s2           # t1 = j + y
        addi    $t2, $s3, -1            # t2 = N - 1
        blt     $t1, $zero, continue    # if (j + y < 0 || j + y > N - 1) continue
        bgt     $t1, $t2, continue
n_if_3:            
        bne     $s1, $zero, n_if_4      # if (x == 0 && y == 0)
        bne     $s2, $zero, n_if_4
        
continue:
	addi    $s2, $s2, 1     # y++
	j       n_loop2
n_if_4:
        add     $t1, $a0, $s1           # t1 = i + x
        add     $t2, $a1, $s2           # t2 = j + y
        mul     $t3, $t1, $s3           # t3 = (i+x)*N
        add     $t3, $t3, $t2           # t3 = (i+x)*N + j + y
        
        
        la      $t4, board              # $t4 = addr of board
        add     $t4, $t4, $t3           # $t4 = addr of board + byte offset
        
        lb      $t5, ($t4)              # $t5 = board[i + x][j + y]
        

        
        li      $t6, 1
        bne     $t5, $t6, continue      # if (board[i + x][j + y] == 1) nn++
        addi    $s0, $s0, 1
        
        
        j       continue      
n_end_loop2:
	addi    $s1, $s1, 1     # x++
	j       n_loop1
n_end_loop1:
        move    $v0, $s0
        lw      $s3  -20($fp)           #tear down stackgrame
        lw      $s2, -16($fp) 
        lw      $s1, -12($fp)
        lw	$s0, -8($fp)	
	lw	$ra, -4($fp)	
	la	$sp, 4($fp)
	lw	$fp, ($fp)	
	       
	jr	$ra 
	
	.data
copy_print1:
        .asciiz "."
copy_print2:
        .asciiz "#"
copy_print3:
        .asciiz "\n"
        .text

# Frame:	$fp, $ra, $s0, $s1, $s2, $sp
# Uses:		$s0, $s1, $s2, $a0, $v0, $t1, $t2, $t3, $t4, $t5
# Clobbers:	$a0, $t1, $t2, $t3, $t4, $t5, 
        

# Locals:	
#	- `maxiters' in $s0 (from user input)
#	- `n' in $s1 
#	- `i' in $s2
#	- `j' in $s3
#       - `N' in $s4 (from #include)
# Structure:
#	main
#	-> [prologue]
#	-> c_loop1
#               -> c_loop2
#                       -> c_if
#                       -> c_else
#                       -> c_if_jump
#               => c_end_loop2
#       => c_end_loop1
#	-> [epilogue]
copyBackAndShow:
        sw	$fp, -4($sp)	# setup stackframe
	la	$fp, -4($sp)	
	sw	$ra, -4($fp)	
	sw	$s0, -8($fp)	
	sw      $s1, -12($fp)
	sw      $s2, -16($fp)
	addi	$sp, $sp, -20	
	
	li      $s0, 0                  # int i = 0
	li      $s1, 0                  # int j = 0
	lw      $s2, N                  # s2 = N
c_loop_1:
        bge     $s0, $s2, c_end_loop1
        li      $s1, 0          
c_loop_2:
        
        bge     $s1, $s2, c_end_loop2
        
        mul     $t1, $s0, $s2           # t1 = i * N
        add     $t1, $t1, $s1           # t1 = i * N + j
        
        la      $t2, board
        la      $t3, newBoard
        add     $t2, $t2, $t1           # board[i*N+j]
        add     $t3, $t3, $t1           # newBoard[i*N+j]
        
        lb      $t4, 0($t3)              
        sb      $t4, 0($t2)             # board[i][j] = newBoard[i][j]
c_if:
        lb      $t5, 0($t2)
        bne     $t5, $zero, c_else     # if (board[i][j] == 0)
        la      $a0, copy_print1    
        li      $v0, 4                  # putchar ('.');
        syscall
        j       c_if_jump 
c_else:
        la      $a0, copy_print2        # else
        li      $v0, 4                  # putchar ('#');
        syscall   
c_if_jump:
        addi    $s1, $s1, 1             # j++
        j       c_loop_2
c_end_loop2:
        addi    $s0, $s0, 1             # i++
        la      $a0, copy_print3        
        li      $v0, 4                  # putchar ('\n');
        syscall        
        j       c_loop_1         	
c_end_loop1:
        lw      $s2, -16($fp)           # tear down stackframe
        lw      $s1, -12($fp)
        lw	$s0, -8($fp)	
	lw	$ra, -4($fp)	
	la	$sp, 4($fp)	
	lw	$fp, ($fp)	
	       
	jr	$ra 
        jr      $ra	

	# Put your other functions here
