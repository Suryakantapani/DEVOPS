cat > employee.txt <<EOF
Alice,HR,Delhi,60000
Bob,Sales,Mumbai,80000
Charlie,IT,Bangalore,90000
EOF
echo "i"
awk -F',' '$4 > 70000' employee.txt
echo "ii"
awk -F',' '{printf "%s,%s,%s,%.0f\n",$1,$2,$3,$4*1.10}' employee.txt
echo "iii"
awk -F',' 'BEGIN{max=0} $4>max{max=$4;name=$1} END{print name}' employee.txt
echo "iv"
sed '3d' employee.txt
echo "v"
sed 's/,/|/g' employee.txt
echo "vi"
sed '/Sales/d' employee.txt