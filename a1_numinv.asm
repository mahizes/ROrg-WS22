	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

str_rowstart: .asciiz "\nnuminv von ( "
str_rowend: .asciiz "): "

	.align 2
.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

	# main durchlaeuft alle Permutationen in "inputs" (siehe unten) und ruft
	# jeweils numinv auf. Permutationen und Rueckgabewerte von numinv werden
	# ausgegeben.
main:
	la $s0, inputs

main_loop:
	lw $s1, 0($s0)
	beq $s1, $zero, main_end

	addi $a0, $s0, 4
	move $a1, $s1
	jal print_perm

	move $a1, $s1	
	addi $a0, $s0, 4
	jal numinv

	move $a0, $v0
	li $v0, SYS_PUTINT
	syscall
	
	sll $s1, $s1, 2
	add $s0, $s0, $s1
	addi $s0, $s0, 4
	j main_loop
	
main_end:
	li $v0, SYS_EXIT
	syscall
	
	# void print_perm(int *perm, int length):
	# Gibt Elemente einer Permutation durch Leerzeichen getrennt aus.
print_perm: 
	move $t1, $a0

	li $v0, SYS_PUTSTR
	la $a0, str_rowstart
	syscall
	
	move $t0, $a1
print_perm_loop:
	beq $t0, $zero, print_perm_end
	
	li $v0, SYS_PUTINT
	lw $a0, 0($t1)
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall
	
	addi $t0, $t0, -1
	addi $t1, $t1, 4
	j print_perm_loop
	
print_perm_end:
	li $v0, SYS_PUTSTR
	la $a0, str_rowend
	syscall
	
	jr $ra

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:	MAHMUD EMIN
	# Nachname:	CAKIR
	# Matrikelnummer: 483401
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

inputs:
	.word 4  # 1. Permutation (Laenge 4):
	.word 1, 2, 0, 3
	.word 4  # 2. Permutation (Laenge 4):
	.word 0, 1, 3, 2
	.word 4  # 3. Permutation (Laenge 4):
	.word 0, 1, 2, 3
	.word 10 # 4. Permutation (Laenge 10):
	.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
	.word 10 # 5. Permutation (Laenge 10):
	.word 1, 2, 0, 4, 5, 3, 7, 8, 9, 6
	.word 10 # 6. Permutation (Laenge 10):
	.word 9, 0, 1, 2, 3, 4, 5, 6, 7, 8
	.word 12 # 7. Permutation (Laenge 12):
	.word 2, 7, 4, 6, 9, 10, 5, 1, 0, 8, 3, 11
	.word 16 # 8. Permutation (Laenge 16):
	.word 4, 3, 2, 15, 5, 14, 11, 10, 1, 8, 0, 12, 9, 13, 7, 6
	.word 0 # Ende der Permutationen

.text

# int numinv(int *perm, int length)
# Calculates and returns the number of inversions in the given permutation.
# perm: pointer to the array containing the permutation
# length: length of the permutation
# returns: the number of inversions in the permutation

# numinv: calculate the number of inversions in a permutation

# registers used:
#   a0 - perm
#   a1 - length
#   t0 - loop counter
#   t1 - inner loop counter
#   t2 - number of inversions

# This function takes two arguments:
# $a0: A pointer to (the address of) the permutation array
# $a1: The length of the permutation array

# Return value:
# $v0: number of inversions
# It returns the inversion count as a result in $v0.

# ########################################################################################
#	int numinv(int* perm, int length) {
#		// Initialize a counter for the number of inversions
#  		int inversion_count = 0;
#
#		// Loop through the elements of the permutation
#  		for (int i = 0; i < length-1; i++) {
#		// For each element, check how many elements after it are smaller
#    	for (int j = i+1; j < length; j++) {
#		// If an element after the current element is smaller, increment the counter
#      	if (perm[i] > perm[j]) {
#        	inversion_count++;
#      	}
#    	}
#  	}
#	// Return the total number of inversions
#  	return inversion_count;
#	}
# ########################################################################################

# int numinv(int *perm, int length)
# Returns the number of inversions in perm.



# Calculate the inversion count of a permutation
#
# @param perm - a pointer to the first element of the permutation
# @param length - the length of the permutation
# @return the inversion count

# int numinv(int *perm, int length):
# Calculates and returns the number of inversions in the permutation.

# int numinv(int *perm, int length):
# Calculates and returns the number of inversions in the permutation.
# Calculates the inversion count of a permutation
#
# @param perm: pointer to the start of the permutation array
# @param length: length of the permutation array
#
# @return: inversion count of the permutation


numinv:
    # Initialize the counter to 0
    li $t0, 0

    # Initialize the loop variables
    li $t1, 0 # i = 0
    li $t2, 1 # j = 1

    # Start the outer loop to iterate through the permutation
    numinv_loop:
        beq $t1, $a1, numinv_end # If i >= length, end the loop

        # Start the inner loop to compare perm[i] with all elements after it
        numinv_inner_loop:
            beq $t2, $a1, numinv_inner_end # If j >= length, end the inner loop

            # Load perm[i] and perm[j] into registers
            sll $t3, $t1, 2 # Multiply i by 4 to get the correct offset
            add $t3, $t3, $a0 # Add the base address to get the correct memory address
            lw $t4, 0($t3) # Load perm[i] into $t4

            sll $t5, $t2, 2 # Multiply j by 4 to get the correct offset
            add $t5, $t5, $a0 # Add the base address to get the correct memory address
            lw $t6, 0($t5) # Load perm[j] into $t6

            # If perm[i] > perm[j], increment the counter
            bgt $t4, $t6, numinv_increment # If perm[i] > perm[j], increment the counter
            j numinv_inner_loop_continue # Otherwise, continue the inner loop

        numinv_increment:
            addi $t0, $t0, 1 # Increment the counter

        numinv_inner_loop_continue:
            addi $t2, $t2, 1 # Increment j
            j numinv_inner_loop # Continue the inner loop

        numinv_inner_end:
        	addi $t1, $t1, 1 # Increment i
        	addi $t2, $t1, 1 # Reset j to i+1
        	j numinv_loop # Continue the outer loop


    numinv_end:
        # Return the counter
        move $v0, $t0
        jr $ra # Return
