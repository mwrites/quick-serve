#!/usr/bin/env bash

# Set your region
region=eu-west-3

# List all applications
applications=$(aws elasticbeanstalk describe-applications --query "Applications[*].ApplicationName" --output text --region $region)

# Terminate all environments
for app in $applications; do
  environments=$(aws elasticbeanstalk describe-environments --application-name $app --query "Environments[*].EnvironmentName" --output text --region $region)
  for env in $environments; do
    aws elasticbeanstalk terminate-environment --environment-name $env --region $region
  done
done

# Delete all applications
for app in $applications; do
  aws elasticbeanstalk delete-application --application-name $app --terminate-env-by-force --region $region
done

# Delete all load balancers
load_balancers=$(aws elb describe-load-balancers --query "LoadBalancerDescriptions[*].LoadBalancerName" --output text --region $region)
for lb in $load_balancers; do
  aws elb delete-load-balancer --load-balancer-name $lb --region $region
done

# Terminate all EC2 instances
instances=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --output text --region $region)
for instance in $instances; do
  aws ec2 terminate-instances --instance-ids $instance --region $region
done
