#!/bin/bash
# Prompt user for the number of terms
echo -n "Enter the number of terms: "
read N

# Initialize the first two terms
a=0
b=1

echo "Fibonacci Series up to $N terms:"

for (( i=0; i<N; i++ ))
do
    echo -n "$a "
    # Calculate next term: fn = a + b
    fn=$((a + b))
    # Update values for the next iteration
    a=$b
    b=$fn
done
echo ""

