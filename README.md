# Binary-to-Decimal-Hex-MIPS32
Binary to Decimal/Hex conversion written in MIPS32
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
