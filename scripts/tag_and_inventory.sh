#!/bin/bash
# Tag untagged resources and output a CSV inventory (AWS CLI must be configured)

REGION="${1:-us-east-1}"
TAG_KEY="pci_scope"
TAG_VALUE="true"
CSV_FILE="aws_inventory_${REGION}.csv"

echo "ResourceType,ResourceId,Tags" > $CSV_FILE

for TYPE in ec2 vpc subnet sg lb; do
  case $TYPE in
    ec2)
      IDS=$(aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].InstanceId' --output text)
      ;;
    vpc)
      IDS=$(aws ec2 describe-vpcs --region $REGION --query 'Vpcs[*].VpcId' --output text)
      ;;
    subnet)
      IDS=$(aws ec2 describe-subnets --region $REGION --query 'Subnets[*].SubnetId' --output text)
      ;;
    sg)
      IDS=$(aws ec2 describe-security-groups --region $REGION --query 'SecurityGroups[*].GroupId' --output text)
      ;;
    lb)
      IDS=$(aws elbv2 describe-load-balancers --region $REGION --query 'LoadBalancers[*].LoadBalancerArn' --output text)
      ;;
  esac

  for ID in $IDS; do
    # Check for the tag
    TAGS=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$ID" --query 'Tags[*].[Key,Value]' --output text)
    if ! echo "$TAGS" | grep -q "$TAG_KEY"; then
      # Tag resource if not already tagged
      case $TYPE in
        lb)
          aws elbv2 add-tags --resource-arns $ID --tags Key=$TAG_KEY,Value=$TAG_VALUE --region $REGION
          ;;
        *)
          aws ec2 create-tags --resources $ID --tags Key=$TAG_KEY,Value=$TAG_VALUE --region $REGION
          ;;
      esac
    fi
    # Output to CSV
    echo "$TYPE,$ID,\"$TAGS\"" >> $CSV_FILE
  done
done

echo "Inventory written to $CSV_FILE"
