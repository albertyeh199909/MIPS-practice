# board2.s ... Game of Life on a 15x15 grid

	.data

N:	.word 15  # gives board dimensions

board:
	.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
	.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0
	.byte 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0
	.byte 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0
	.byte 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1
	.byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0
	.byte 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0

        newBoard: .space 225
        
        print1: .asciiz "# Iterations: "
        print2: .asciiz "=== After iteration "
        print3: .asciiz "===\n" 

	.globl	main
	.globl	decideCell
	.globl  neighbours
        .text
main:
        sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int i;
	sw	$s1, -12($fp)	# save $s1 to use as ... int prod;
	sw      $s2  -16($fp) 
	sw      $s3  -20($fp) 
	sw      $s4  -24($fp) 
	addi	$sp, $sp, -28	# reset $sp to last pushed item
	
	        
        la      $a0, print1   # load the argument string
        li      $v0, 4        # printf("# Iterations: ")
        syscall
        
        li      $v0, 5     # scanf ("%d", &maxiters);
        syscall
        move    $s0, $v0   #s0 = maxiters
        
        
        li      $s1, 1     # int n = 1;
        li      $s2, 0     # int i = 0;
        li      $s3, 0     # int j = 0; 
        lw      $s4, N     # $s4 = N   
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
        move    $t1, $v0          # int nn = neightbours (i, j);
        
        la      $t2, board        # load address board[0]
        mul     $t3, $s2, $s4     # t3 = i * N
        add     $t4, $t3, $s3     # t4 = t3 + j
        add     $t5, $t2, $t4     # t5 = board[0+(i*N+j)]
        lb      $t6, 0($t5)        
        
        move    $a0, $t6          # newBoard[i][j] = decideCell (board[i][j], nn)
        move    $a1, $t1
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
        lw      $s4  -24($fp) 
	lw      $s3  -20($fp)
        lw	$s2, -16($fp)	# restore $s2 value
	lw	$s1, -12($fp)	# restore $s1 value
	lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	
        li      $v0, 0
        jr      $ra
        


decideCell:
        sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int i;
	addi	$sp, $sp, -12	# reset $sp to last pushed item

IF:	
	li      $t0, 1          
	bne     $a0, $t0, ELSE_1        #
	li      $t1, 2
	bge     $a1, $t1, else_1
	li      $s0, 0
	j       END
else_1:
        li      $t1, 2
        li      $t2, 3
        beq     $a1, $t1, if
        bne     $a1, $t2, else_2
if:
        li      $s0, 1
        j       END
else_2:
        li      $s0, 0
        j       END
ELSE_1:        
        li      $t1, 3
        bne     $a1, $t1, ELSE_2
        li      $s0, 1
        j       END
ELSE_2:
        li      $s0, 0        
END:
        move    $v0, $s0
        
        lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	
        jr      $ra 
        
neighbours:
        sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int i;
	sw      $s1, -12($fp)
	sw      $s2, -16($fp)
	sw      $s3, -20($fp)
	addi	$sp, $sp, -24	# reset $sp to last pushed item
	 
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
        lw      $s3  -20($fp)
        lw      $s2, -16($fp) 
        lw      $s1, -12($fp)
        lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame) 
	       
	jr	$ra 

	.data
copy_print1:
        .asciiz "."
copy_print2:
        .asciiz "#"
copy_print3:
        .asciiz "\n"
        .text
copyBackAndShow:
        sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int i;
	sw      $s1, -12($fp)
	sw      $s2, -16($fp)
	addi	$sp, $sp, -20	# reset $sp to last pushed item
	
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
        sb      $t4, 0($t2)              # board[i][j] = newBoard[i][j]
c_if:
        lb      $t5, 0($t2)
        bne     $t5, $zero, c_else
        la      $a0, copy_print1        # load the argument string
        li      $v0, 4                  # putchar ('.');
        syscall
        j       c_if_jump 
c_else:
        la      $a0, copy_print2        # load the argument string
        li      $v0, 4                  # putchar ('#');
        syscall   
c_if_jump:
        addi    $s1, $s1, 1             # j++
        j       c_loop_2
c_end_loop2:
        addi    $s0, $s0, 1             # i++
        la      $a0, copy_print3        # load the argument string
        li      $v0, 4                  # putchar ('\n');
        syscall        
        j       c_loop_1         	
c_end_loop1:
        lw      $s2, -16($fp) 
        lw      $s1, -12($fp)
        lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame) 
	       
	jr	$ra 
                  
    
