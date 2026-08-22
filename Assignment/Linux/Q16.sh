cat > employee.txt <<EOF
Alice,HR,Delhi,60000
Bob,Sales,Mumbai,80000
Charlie,IT,Bangalore,90000
David,Finance,Chennai,75000
Eva,Sales,Hyderabad,65000
EOF
awk -F',' '$4 > 70000' employee.txt
awk -F',' '{printf "%s,%s,%s,%.0f\n",$1,$2,$3,$4*1.10}' employee.txt
awk -F',' 'BEGIN{max=0} $4>max{max=$4;name=$1} END{print name}' employee.txt
sed '3d' employee.txt
sed 's/,/|/g' employee.txt
sed '/Sales/d' employee.txt