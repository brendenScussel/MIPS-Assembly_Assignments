# Program to test solution to exercise 2.29

.data
newline: .asciiz "\n"
exitStr: .asciiz "exit\n"

.text
.globl main

main:
	# Read an integer from standard input and assign to $t0
	li $v0, 5
	syscall
	move $t0, $v0

	# print out the value read
	li $v0, 1
	move $a0, $t0
	syscall
    li $v0, 4
    la $a0, newline
    syscall

    # put parameter into $a0 and call fib procedure
    # "jump and link" value in $a0 to block "fib"
    move $a0, $t0
    jal fib

    # put value returned from fib into $t0
    move $t0, $v0

    # print out the value returned from fib
	li $v0, 1
	move $a0, $t0
	syscall
    li $v0, 4
    la $a0, newline
    syscall

	j exit


fib:
	# TODO: implement recursive fib procedure
 	addi	$t0, $zero, 0		# set $t0 as 0, to compare
 	addi	$t1, $zero, 1		# set $t1 as 1, to compare
	addi	$t2, $zero, 2		# set $t2 as 2, to compare

	beq		$t0, $a0, return0	#if $a0 == 0 then return
	beq		$t1, $a0, return0	#if $a0 == 1 then return
	bge		$a0, $t2, fib_recurse	# branch if input is >= 2
	
	return0: add 	$v0, $a0, $zero
	jr $ra
	j exit					#bs20250223


fib_recurse:
	# adjust the stack to save 3 words, $a0, $ra, and $s0
	addi	$sp, $sp, -12
	sw		$ra, 8($sp)			#return address
	sw		$a0, 4($sp)			#input value
	sw		$s0, 0($sp)			#result

	addi	$a0, $a0, -1
	jal 	fib					# call fib(n - 1)

	sw	 	$v0, 0($sp)			# save result to the stack
	lw		$a0, 4($sp)			# restore $a0 from the stack

	addi	$a0, $a0, -2		
	jal		fib					# call fib(n - 2)
	add		$t1, $v0, $zero		# save returned value in $t1
	
	lw		$s0, 0($sp)			# load fib(n - 1) value from stack into $s0
	lw		$a0, 4($sp)
	lw		$ra, 8($sp)			# restore $ra from the stack
	addi	$sp, $sp, 12		# restore stack pointer

	add		$v0, $s0, $t1		# return $s0 + $t1

	jr $ra						# return address

exit:
	li $v0, 4
	la $a0, exitStr
	syscall
	li $v0, 10
	syscall
