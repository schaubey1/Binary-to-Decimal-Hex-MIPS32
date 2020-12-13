####################################################################################
# Psuedocode: 
# Define ASCII prompts as needed for user input and output
# 	-load address and ask for user input
# 	-Loop and ask user for all elements of the binary input. 
#	-Call isNegative			
# isNegative:
# 	See if the first element of user entry is 1, if so it is negative. 
# 	- Call isNegative to execute twos compliment conversion.
#	- isNegative: will convert all 0 to 1, and 1 to 0 as needed.
#	- will call hex after converting
#	- if isNegative returns false, call isPositive.
#	- Add each bit multiplied by 2^n constant beginning from the exponent at (n-1). 
#	- Perform n-1 on exponent on the left each time program moves down 1 bit. 
# 	- Perform addition on the arithmetic performed. 
#	- call output
# isPositive:
# 	- call Hex
#	- Assign a register to hold a running sum.
#	- Add each bit multiplied by 2^n constant beginning from the exponent at (n-1). 
#	- Perform n-1 on exponent on the left each time program moves down 1 bit. 
# 	- Perform addition on the arithmetic performed. 
#	- store result
#	- call output
# Hex:
# 
#	- load register with data from isNegative into hex
#	- create a 32 bit number
#	- allocate register
#	- convert into nibbles
# 	- allocate proper reigsters
# 	- process each nibble
#	- store into register
#	- call output
# Output:
# Load each ascii prompt that says what is being outputted
#	-call each register containing the result
# Inputcheck:
# 	-Check if user input is greater than or less than 0 or 1.
#	-call endif
# Endif:
# End if number isn't binary.
# - Called by input check 
####################################################################################
#$a0 -> used to call syscalls
#$a1 -> stores argument
#$s0 -> input
#s0  -> used to store the current byte for bianary operations
#$s2->used to store the current byte for hex
#$t1 -> quotient operations
#$t2 -> remainder from hexadecimal operations
####################################################################################
.data
	newline:	.asciiz "\n"
	input: 		.asciiz "You entered the binary number:\n"
	output: 	.asciiz "\nThe number in decimal is:\n"
	hexposoutput:   .asciiz "\nThe hex representation of the sign-extended number is:\n"
	negsign: 	.asciiz 	"-"
  	error: 		.asciiz "error" 
  	extendinput:    .space 32
	hexprefix: 	.asciiz "0x"
	negHexString:   .asciiz "0xFFFFFF"
	posHexString:	.asciiz "0x000000"
.text
	main:		
		move	 $s0,$a1		# move argument to $s0
		lw	 $s0,($s0)	  	# arguement address is stored here
	
		li 	$v0, 4		  	# print string syscall
		la 	$a0, input    		# load input in $a0
		syscall
	
		li 	$v0, 4		  	# print integer syscall
		move	$a0, $s0	  	# move argument to $a0
		syscall

		li $t5,0 #loop variable

##############################################- begin converter-################################################		
	
	Initializing: 	
		li $t2, 0			
		li $t3, 2			
	
	ASCII2Int:
		lb 	$t0, ($s0)		# Loads first byte of program argument into $t0 
		beqz 	$t0, signextend		# Breaks loop when it hits /0
		subi 	$t0, $t0, 48		# Subtract 48 to get to decimal
		multu   $t2, $t3		# Multiply by 2
		mflo 	$t4			# Load the lower result from the multu instruction using mflo
		add	$t4, $t4, $t0		# Adds the first byte of arguement with $t4
		move 	$t2, $t4		# Move result to $t2
		addi	$s0, $s0, 1		# increment over entire address
		b ASCII2Int			# Branch to iterate over the entire address
	


	signextend:  	 #These functions take a negative input number as a positive number and provide the correct HEX bytes
	
		sll $t4, $t4, 24              #shift logic left 24 bits
		sra $t4, $t4, 24              #shift right artihmetic for 24 bits
		move $s0, $t4 	              #store sign extended number inside $s0
	
	li $v0, 4     
	la $a0, hexposoutput  		      #call oyutput for hex
	syscall
	
	move $s2, $s0
	
	bgez $s2, posHexJump                 #if positive call positive hex function
	bltz $s2, negHexJump                 #if negative call negative hex function
	
	posHexJump:
	li $v0, 4
	la $a0, posHexString                 #load positivehexstring as defined into register $a0 for output
	syscall
	
	j endHexPrefixString
	
	negHexJump: 	       		     #used for negative hex numbers
	li $v0, 4
	la $a0, negHexString 	             #load in 0xFFFFFF
	syscall
	
	endHexPrefixString:
	
	li $t0, 16
	divu $s2, $t0          		      # divide string by 16
	mflo $t1	                      # quitient
	mfhi $t2	                      # remainder
	
	divu $t1, $t0
	mflo $t3			      # qoutient 
	mfhi $t4	                      # remainder
	
				              # print second digit
	bge $t4,10, secondDigitLetter
				              # print number
	addi $t4,$t4 48
	li $v0, 11
	la $a0, ($t4)
	syscall
	j endSecondDigitLetter
	secondDigitLetter:                    # Comments for next loop apply to all loops since they are copies with only label changes
				              # print letter
	addi $t4, $t4, 55 		      #convert value to ASCII
	li $v0, 11 			      #print out second letter
	la $a0, ($t4)
	syscall
	endSecondDigitLetter:	
	
					      #print first digit
	bge $t2, 10, firstDigitLetter
	addi $t2,$t2 48 
	li $v0, 11
	la $a0, ($t2)
	syscall
	
	j endFirstDigitLetter
	
	firstDigitLetter:
	addi $t2,$t2 55			      #convert value to ASCII 
	li $v0, 11
	la $a0, ($t2)			      # print letter
	syscall
	
	endFirstDigitLetter:
	
	la $a0, newline
	syscall
	
	move $s1, $s0
	
	li $v0, 4			     #output
	la $a0, output 
	syscall
	
	bgtz $s1, negConvJump
	li $t7, -1
	mult  $s1, $t7			    #convert value to ASCII
	mflo $s1
	

	
	li $v0, 4
	la $a0, negsign
	syscall
	
	negConvJump:
	
	## Print first digit ##
	
	li $t7, 100
	div $s1, $t7
	mflo $t1
	mfhi $t2
	
	# print first digit
	beqz $t1, firstDigitPrint
 	addi $t1,$t1 48
	li $v0, 11
	la $a0, ($t1)
	syscall
	firstDigitPrint:
	
	## Print second Digit ##
	
	li $t7, 10
	div $t2, $t7
	mflo $t1
	mfhi $t2
	
	# print digit
	beqz $t1, secondDigitPrint
 	addi $t1,$t1 48
	li $v0, 11
	la $a0, ($t1)
	syscall
	secondDigitPrint:
	
	## Print third Digit ##
	
	li $t7, 1
	div $t2, $t7
	mflo $t1
	mfhi $t2
	
	# print digit
 	addi $t1,$t1 48
	li $v0, 11
	la $a0, ($t1)
	syscall
