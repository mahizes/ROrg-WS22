	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

str_rowstart: .asciiz "\nErgebnis fuer ( "
str_rowend: .asciiz "): "

	.align 2
alle_fruechte:
	.ascii "Apfel ----------"
	.ascii "Birne ----------"
	.ascii "Clementine -----"
	.ascii "Drachenfrucht --"
	.ascii "Erdbeere -------"
	.ascii "Feige ----------"
	.ascii "Granatapfel ----"
	.ascii "Himbeere -------"
	.ascii "Ingwer ---------"
	.ascii "Johannisbeere --"
	.ascii "Kirsche --------"
	.ascii "Limette --------"
	.ascii "Mango ----------"
	.ascii "Nektarine ------"
	.ascii "Orange ---------"
	.ascii "Pfirsich -------"
	
	.space 128
fruechte_aktuell:
	.space 512

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

	# main durchlaeuft alle Permutationen in "inputs" (siehe unten) und ruft
	# jeweils permutate auf. Permutationen und das Array objects nach
	# Funktionsaufruf werden ausgegeben.
main:
	la $s0, inputs

main_loop:
	lw $s1, 0($s0)
	beq $s1, $zero, main_end

	addi $a0, $s0, 4
	move $a1, $s1
	jal print_perm

	la $a0, fruechte_aktuell
	la $a1, alle_fruechte
	sll $a2, $s1, 2
	jal wcpyz

	la $a0, fruechte_aktuell
	addi $a1, $s0, 4
	move $a2, $s1
	jal permutate

	la $a0, fruechte_aktuell
	jal print_fruechte

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

	# void print_fruechte(char *objects):
	# Gibt das Array von Fruechten objects aus.
print_fruechte:
	move $t0, $a0
	li $t1, '-' # ignore this char

print_fruechte_loop:
	lb $a0, 0($t0)
	addi $t0, $t0, 1
	
	beq $a0, $zero, print_fruechte_end
	beq $a0, $t1, print_fruechte_loop
	
	li $v0, SYS_PUTCHAR
	syscall

	j print_fruechte_loop
print_fruechte_end:
	jr $ra
	
	# void wcpyz(int *dst, int *src, int size_words):
	# Kopiert size_words Woerter von src zu dst und fuegt Nullterminator hinzu. 
wcpyz: 
	beq $a2, $zero, wcpyz_end
	lw $t0, 0($a1)
	sw $t0, 0($a0)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	j wcpyz	
wcpyz_end:
	sb $zero, 0($a0) # zero termination
	jr $ra

	# void swap(char *objects, int k, int l):
	# Hilfsfunktion: Tauscht im Array objects die Elemente mit Indizes k und l.
swap: 
	sll $a1, $a1, 4	
	sll $a2, $a2, 4	
	add $a1, $a1, $a0
	add $a2, $a2, $a0
	li $t0, 4
swap_loop:
	lw $t1, 0($a1)
	lw $t2, 0($a2)
	sw $t2, 0($a1)
	sw $t1, 0($a2)
	add $a1, $a1, 4
	add $a2, $a2, 4
	addi $t0, $t0, -1
	bne $t0, $zero, swap_loop
	jr $ra

	# int cycle_head(int *perm, int idx):
	# Hilfsfunktion: Gibt zurueck, ob es sich bei dem Element idx der 
	# Permutation perm um einen Zyklenkopf handelt.
	# Rueckgabewert: 1, falls Zyklenkopf, sonst 0.
cycle_head: 
	move $t0, $a1 # $t0: cur
	move $t1, $a1 # $t1: initial
	move $v0, $zero
find_least_loop:
	bge $t0, $a1, not_lower
	jr $ra
not_lower:
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $t0, 0($t0)
	bne $t0, $t1, find_least_loop
	li $v0, 1
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

# ###########################################################################
#			void permutate(char* objects, int* perm, int perm_len) {
#  			// Iterate over the elements of the permutation array
#  				for (int i = 0; i < perm_len; i++) {
#    		// If the current element is a cycle head
#    			if (cycle_head(perm, i)) {
#      		// Set j to the index of the element that the current element should be swapped with
#      			int j = perm[i];
 #     	// Keep swapping until we reach the cycle head again
#      			while (j != i) {
#        // Swap elements i and j
#        		swap(objects, i, j);
#        // Update j to be the index of the element that the new element at index i should be swapped with
#       		 j = perm[j];
#      }
#    }
#  }
# }
# ###########################################################################

# Permutate the elements of the array objects according to the permutation perm.
# permutate: Permute objects array according to permutation in perm array
# @param objects - the array of objects to be permuted
# @param perm - the permutation to apply to the array objects
# @param perm_len - the length of the permutation (and the length of the array objects)
#
# $a0 = objects
# $a1 = perm
# $a2 = perm_len

# This function takes in the following arguments:

# $a0: pointer to the start of the permutation array
# $a1: pointer to the current element in the permutation array
# $a2: length of the permutation array
# It returns the number of inversions in the permutation array through the $v0 register.

# Initialize variables:
# - s0 = pointer to objects array
# - s1 = pointer to perm array
# - s2 = length of perm array
# - s3 = current position in perm array
# - s4 = temporary space for element swaps
# - s5 = number of inversions in the permutation array

# void permutate(char *objects, int *perm, int perm_len)
# void get_permuted_pos(int *perm, int pos)
# Returns the permuted position of element at pos in perm.
#
# Registers:
#   $a0: perm
#   $a1: pos
#
# Returns:
# $v0: permuted position of element at pos

# $ra: return address
# $zero: $0 zero register
# $sp: stack pointer


# This function is called "permutate"
permutate:

	# Save some registers on the stack
	addi $sp, $sp, -24	# Reserve space for 6 registers

	# Save $ra, $s1, $s2, $s3, $s4, $s5 on the stack
	sw $ra, 20($sp)		# Save $ra
	sw $s1, 16($sp)		# Save $s1
	sw $s2, 12($sp)		# Save $s2
	sw $s3, 8($sp)    	# Save $s3
	sw $s4, 4($sp)    	# Save $s4
	sw $s5, 0($sp) 		# Save $s5


	# Initialize some variables
	move $s1, $a0		# $s1: perm
	move $s2, $a1		# $s2: perm_len
	move $s3, $a2		# $s3: perm_size
	move $s4, $0		# $s4: i
	move $s5, $v0		# $s5: j

# Start of a loop over all permutations
permutate_loop:

	# Check if we reached the end of the loop
	beq $s4, $s3, permutate_return # if (i == perm_size) return;

	# Get the element of array at index $s4
	sll $t1, $s4, 2 	# $t1: i * 4
	add $t1, $s2, $t1	# $t1: perm_len + i * 4
	lw $a1, 0($t1)		# $a1: perm[i]

	# Call another function cycle_head
	move $a0, $s2	# $a0: perm
	jal cycle_head	# $v0: cycle_head(perm, i)

	move $t1, $v0	# $t1: is_cycle_head

	# Check if the function returned zero
	beq $t1, $0, permutate_head_false	# if (!is_cycle_head) goto permutate_head_false;

	# Initialize $t5 with the value of $s4
	move $t5, $s4  		# $t5: temp = i

	# Get the element of array at index $s4
	sll $t2, $s4, 2		# $t2: i * 4
	add $t2, $s2, $t2	# $t2: perm_len + i * 4
	lw $t3, 0($t2)		# $t3: j = perm[i]	

# Start of a swap loop
permutate_swap:

	# Get the element of array at index $t3
	sll $t2, $t3, 2		# $t2: j * 4
	add $t2, $s2, $t2	# $t2: perm_len + j * 4
	lw $t6, 0($t2)		# $t6: perm[j] 

	# Check if $t5 is equal to $t3
	beq $t5, $t3, permutate_head_false

	# call the swap functio
	move $a0, $s1	# $a0: perm
	move $a1, $t3	# $a1: j
	move $a2, $t6	# $a2: perm[j]]
	jal swap		# swap(perm, j, [perm[j])

	# set $t3 to be $t6
	move $t3, $t6	# j = perm[j]

	# go back to the start of the swap loop
	j permutate_swap	

	# End of swap loop

# Start of the false branch of the cycle_head function
permutate_head_false:

	# Increment $s4 by 1
	addi $s4, $s4, 1	# i++

	# Go back to the start of the main loop
	j permutate_loop

	# End of main loop

# Restore the original values of the registers that were saved earlier
permutate_return:
	lw $s5, 0($sp)		# Restore $s5
	lw $s4, 4($sp)		# Restore $s4
	lw $s3, 8($sp)		# Restore $s3
	lw $s2, 12($sp)		# Restore $s2
	lw $s1, 16($sp)		# Restore $s1
	lw $ra, 20($sp)		# Restore $ra
	addi $sp, $sp, 24	# Free the space we reserved earlier
	jr $ra		# Return
