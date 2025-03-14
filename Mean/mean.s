
.data
newline: .asciiz "\n"
exitStr: .asciiz "exit\n"
array: .word 10, 20, 30, 40

.text
.globl compute_mean

compute_mean:
	ble		$a1, $zero, compute_mean_zero	#if size [$a1] is zero, return zero
	li		$t0, 0				# Initialize sum $t0
	li		$t1, 0				# Initialize loop index $t1
compute_mean_loop:
	sll		$t2, $t1, 2			# index * 4
	add		$t2, $a0, $t2		# load array starting at $t2
	lw		$t2, 0($t2)			# load current base address, overwrite $t2
	add		$t0, $t0, $t2		# sum = sum + array[i]
	addi	$t1, $t1, 1			# i++
	blt		$t1, $a1, compute_mean_loop		# if i < size; loop
compute_mean_done:
	div		$t0, $a1			# divide sum by size
	mflo	$v0					# lo register is quotent
	jr		$ra
compute_mean_zero:
    li		$v0, 0
    jr		$ra					#bscussel20250306

# Function: print_array
# Parameters:
# $a0 - Pointer to the array of integers
# $a1 - Size of the array (number of elements)
# Prints:
# Elements of the array, one per line

print_array:
    li $t1, 0          # $t1 = index (i)

print_array_loop:
    # Check if index < size ($t1 < $a1)
    bge $t1, $a1, print_array_done

    # Load array[i] into $t2
    sll $t3, $t1, 2    # $t3 = i * 4 (byte offset for int)
    add $t4, $a0, $t3  # $t4 = address of array[i]
    lw $t2, 0($t4)     # $t2 = array[i]

    move $t5, $a0      # Save original $a0

    # Print array[i]
    move $a0, $t2      # Move value to $a0 for printing
    li $v0, 1          # Print integer syscall
    syscall

    # Print newline
    li $v0, 4          # Print string syscall
    la $a0, newline
    syscall

    move $a0, $t5      # Restore original $a0

    # Increment index (i++)
    addi $t1, $t1, 1

    # Loop back
    j print_array_loop

print_array_done:
    jr $ra

# Example usage in main:
.globl main

main:
    # Example array: {10, 20, 30, 40}
    la $a0, array      # Load address of array
    li $a1, 4          # Size of the array

    jal print_array    # Call print_array

    la $a0, array      # Load address of array
    li $a1, 4          # Size of the array

    jal compute_mean   # Call compute_mean

    # Print result
    move $a0, $v0      # Move result to $a0 for printing
    li $v0, 1          # Print integer syscall
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

exit:
	li $v0, 4
	la $a0, exitStr
	syscall
	li $v0, 10
	syscall
