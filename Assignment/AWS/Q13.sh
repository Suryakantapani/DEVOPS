#!/bin/bash
VPC_ID=$(aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--query 'Vpc.VpcId' \
--output text)
aws ec2 modify-vpc-attribute \
--vpc-id "$VPC_ID" \
--enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute \
--vpc-id "$VPC_ID" \
--enable-dns-hostnames "{\"Value\":true}"
PUBLIC_SUBNET=$(aws ec2 create-subnet \
--vpc-id "$VPC_ID" \
--cidr-block 10.0.1.0/24 \
--query 'Subnet.SubnetId' \
--output text)
PRIVATE_SUBNET=$(aws ec2 create-subnet \
--vpc-id "$VPC_ID" \
--cidr-block 10.0.2.0/24 \
--query 'Subnet.SubnetId' \
--output text)
IGW_ID=$(aws ec2 create-internet-gateway \
--query 'InternetGateway.InternetGatewayId' \
--output text)
aws ec2 attach-internet-gateway \
--internet-gateway-id "$IGW_ID" \
--vpc-id "$VPC_ID"
PUBLIC_RT=$(aws ec2 create-route-table \
--vpc-id "$VPC_ID" \
--query 'RouteTable.RouteTableId' \
--output text)
aws ec2 create-route \
--route-table-id "$PUBLIC_RT" \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id "$IGW_ID"
aws ec2 associate-route-table \
--route-table-id "$PUBLIC_RT" \
--subnet-id "$PUBLIC_SUBNET"
EIP_ALLOC=$(aws ec2 allocate-address \
--domain vpc \
--query 'AllocationId' \
--output text)
NAT_ID=$(aws ec2 create-nat-gateway \
--subnet-id "$PUBLIC_SUBNET" \
--allocation-id "$EIP_ALLOC" \
--query 'NatGateway.NatGatewayId' \
--output text)
aws ec2 wait nat-gateway-available \
--nat-gateway-ids "$NAT_ID"
PRIVATE_RT=$(aws ec2 create-route-table \
--vpc-id "$VPC_ID" \
--query 'RouteTable.RouteTableId' \
--output text)
aws ec2 create-route \
--route-table-id "$PRIVATE_RT" \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id "$NAT_ID"
aws ec2 associate-route-table \
--route-table-id "$PRIVATE_RT" \
--subnet-id "$PRIVATE_SUBNET"
echo "VPC: $VPC_ID"
echo "Public Subnet: $PUBLIC_SUBNET"
echo "Private Subnet: $PRIVATE_SUBNET"
echo "Internet Gateway: $IGW_ID"
echo "NAT Gateway: $NAT_ID"