#!/bin/bash
BACKEND_IP=$1
echo "Backend IP: $BACKEND_IP"
echo "Waiting for backend..."
sleep 20
echo "Response from Backend"
curl http://$BACKEND_IP