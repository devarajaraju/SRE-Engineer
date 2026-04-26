#!/bin/bash
# Prompt the user for a number
echo "Enter a number:"
read num

# Store the original number for comparison
original_num=$num
reverse=0

# Loop to reverse the number
while [ $num -gt 0 ]
do
    # Get the last digit
    digit=$(( num % 10 ))
    # Build the reversed number
    reverse=$(( reverse * 10 + digit ))
    # Remove the last digit from the original number
    num=$(( num / 10 ))
done

# Compare the reversed number with the original
if [ $original_num -eq $reverse ]; then
    echo "$original_num is a palindrome."
else
    echo "$original_num is not a palindrome."
fi

