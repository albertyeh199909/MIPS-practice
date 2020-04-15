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


	.globl	main
	.globl	decideCell
	.globl  neighbours
    .text
	
main:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int i;
	addi	$sp, $sp, -12	# reset $sp to last pushed item
	
	
	
	li      $t0, 4
	li      $t1, 5
	move    $a0, $t0
	move    $a1, $t1
	jal     neighbours
	

	
	nop
	move    $t3, $v0
	
	move    $a0, $t3
	li      $v0, 1
	syscall
	
end_main:
        lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	
        


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
	li      $t0, 1          # reg[t0] is loop counter
	li      $s1, -1         # int x = -1
	li      $s2, -1         # int y = -1
	lw      $s3, N          # reg[s3] = N
loop1:
	bgt     $s1, $t0, end_loop1     # for (int x = -1; x <= 1)
loop2:        
        bgt     $s2, $t0, end_loop2     # for (int y = -1; y <= 1)

if_1:
        add     $t1, $a0, $s1           
        addi    $t2, $s3, -1
        blt     $t1, $zero, continue    # if (i + x < 0 || i + x > N - 1) continue
        bgt     $t1, $t2, continue         	

if_2:
        add     $t1, $a1, $s2
        addi    $t2, $s3, -1
        blt     $t1, $zero, continue    # if (j + y < 0 || j + y > N - 1) continue
        bgt     $t1, $t2, continue
if_3:            
        bne     $s1, $zero, if_4        # if (x == 0 && y == 0)
        bne     $s2, $zero, if_4
        
continue:
	addi    $s2, $s2, 1     # y++
	j       loop2
if_4:
        add     $t1, $a0, $s1           # i + x
        add     $t2, $a1, $s2           # j + y
        mul     $t3, $t1, $s3
        add     $t3, $t3, $t2
        
        
        la      $t4, board              # $t4 = addr of board
        add     $t4, $t4, $t3           # $t4 = addr of board + byte offset
        
        lb      $t5, ($t4)              # $t5 = board[i + x][j + y]
        

        
        li      $t6, 1
        bne     $t5, $t6, end_loop2    # if (board[i + x][j + y] == 1) nn++
        addi    $s0, $s0, 1
        
        
        
        j       continue       
end_loop2:
	addi    $s1, $s1, 1     # x++
	j       loop1
end_loop1:
        move    $v0, $s0
        lw      $s3  -20($fp)
        lw      $s2, -16($fp) 
        lw      $s1, -12($fp)
        lw	$s0, -8($fp)	# restore $s0 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame) 
	       
	jr	$ra                        
    
