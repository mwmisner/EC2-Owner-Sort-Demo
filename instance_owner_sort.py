#!/usr/bin/env python
# Reimplementation of ruby version, not fully working
import boto3

ec2 = boto3.client('ec2')

reservations = ec2.describe_instances()
instance_data = [['InstanceId','PrivateIp Address',]]

max_length = [0] * (len(instance_data) + 1)

for instances in reservations['Reservations']:
    instance = instances['Instances'][0]
    instance_data.append([instance['InstanceId'],instance['PrivateIpAddress']])

for row in instance_data:
    x = 0
    for item in row:
        length = len(item)
        if length > max_length[x]:
            max_length[x] = length
        x += 1

for row in instance_data:
    x=0
    formatted_row = [' '] * (len(instance_data) + 1)
    for item in row:
        print x
        padding = ''
        if (max_length[x] - len(row)) > 0:
            padding = ' ' * (max_length[x] - len(row[x]))
        formatted_row[x] = item + padding
        x += 1
        print item
        
    print ' | '.join(formatted_row)
