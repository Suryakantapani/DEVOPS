#!/bin/bash
echo "Enter first number:"
read a
echo "Enter second number:"
read b
echo "Addition: $((a+b))"
echo "Subtraction: $((a-b))"
echo "Multiplication: $((a*b))"
if [ $b -eq 0 ]
then
    echo "Division: Invalid"
    echo "Modulus: Invalid"
else
    echo "Division: $((a/b))"
    echo "Modulus: $((a%b))"
fi