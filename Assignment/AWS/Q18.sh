#!/bin/bash
INSTANCE_ID="i-0123456789abcdef0"
REGION="ap-south-1"
DASHBOARD_NAME="EC2-Monitoring-Dashboard"
echo "Checking AWS CLI..."
aws --version
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2-CPU-High" \
  --alarm-description "Alarm when EC2 CPU utilization exceeds 70%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --unit Percent \
  --region $REGION
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2-Status-Check-Failed" \
  --alarm-description "Alarm when EC2 status check fails" \
  --metric-name StatusCheckFailed \
  --namespace AWS/EC2 \
  --statistic Maximum \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --unit Count \
  --region $REGION
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2-Network-In-High" \
  --alarm-description "Alarm when EC2 incoming network traffic is high" \
  --metric-name NetworkIn \
  --namespace AWS/EC2 \
  --statistic Average \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 10000000 \
  --comparison-operator GreaterThanThreshold \
  --unit Bytes \
  --region $REGION
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2-Network-Out-High" \
  --alarm-description "Alarm when EC2 outgoing network traffic is high" \
  --metric-name NetworkOut \
  --namespace AWS/EC2 \
  --statistic Average \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 10000000 \
  --comparison-operator GreaterThanThreshold \
  --unit Bytes \
  --region $REGION
cat > dashboard.json <<EOF
{"widgets": [{
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "EC2 CPU Utilization",
        "metrics": [[
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "$INSTANCE_ID"
          ]],
        "period": 300,
        "stat": "Average",
        "region": "$REGION",
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }}}},{
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "EC2 Network Traffic",
        "metrics": [[
            "AWS/EC2",
            "NetworkIn",
            "InstanceId",
            "$INSTANCE_ID"
          ],
          [
            ".",
            "NetworkOut",
            ".",
            "."
          ]],
        "period": 300,
        "stat": "Average",
        "region": "$REGION",
        "view": "timeSeries"
      }},{
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "EC2 Status Check",
        "metrics": [[
            "AWS/EC2",
            "StatusCheckFailed",
            "InstanceId",
            "$INSTANCE_ID"
          ]],
        "period": 300,
        "stat": "Maximum",
        "region": "$REGION",
        "view": "timeSeries"
      }},{
      "type": "alarm",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "EC2 CloudWatch Alarms",
        "alarms": [
          "arn:aws:cloudwatch:$REGION:$(aws sts get-caller-identity --query Account --output text):alarm:EC2-CPU-High",
          "arn:aws:cloudwatch:$REGION:$(aws sts get-caller-identity --query Account --output text):alarm:EC2-Status-Check-Failed",
          "arn:aws:cloudwatch:$REGION:$(aws sts get-caller-identity --query Account --output text):alarm:EC2-Network-In-High",
          "arn:aws:cloudwatch:$REGION:$(aws sts get-caller-identity --query Account --output text):alarm:EC2-Network-Out-High"
        ]}}]}
EOF
aws cloudwatch put-dashboard \
  --dashboard-name "$DASHBOARD_NAME" \
  --dashboard-body file://dashboard.json \
  --region "$REGION"
aws cloudwatch describe-alarms \
  --alarm-name-prefix "EC2-" \
  --query 'MetricAlarms[].{Alarm:AlarmName,State:StateValue,Metric:MetricName}' \
  --output table \
  --region "$REGION"
aws cloudwatch list-dashboards \
  --region "$REGION"