#!/bin/bash
#!/bin/bash
echo "Enter a string:"
read user_string
reversed=""
for (( i=${#user_string}-1; i>=0; i-- )); do
    reversed="$reversed${user_string:$i:1}"
done
echo "Reversed string: $reversed"

