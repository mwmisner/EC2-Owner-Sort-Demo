#!/usr/bin/env python
# Reimplementation of ruby version, not fully working
import boto3
from operator import itemgetter, attrgetter, methodcaller

ec2 = boto3.client('ec2')

reservations = ec2.describe_instances()
instance_data_headers = ['InstanceId','PrivateIpAddress']
sort_index = instance_data_headers.index('InstanceId')
instance_data = []
max_length = [0] * (len(instance_data_headers) + 1)

for instances in reservations['Reservations']:
    instance = instances['Instances'][0]
    instance_data.append([instance['InstanceId'],instance['PrivateIpAddress']])
    print instance , "\n"

instance_data.insert(0, instance_data_headers )

for row in instance_data:
    x = 0
    for item in row:
        length = len(item)
        if length > max_length[x]:
            max_length[x] = length
        x += 1
instance_data.pop(0)
sorted_instance_data = sorted(instance_data, key=itemgetter(sort_index))
sorted_instance_data.insert(0, instance_data_headers )

for row in sorted_instance_data:
    x=0
    formatted_row = [' '] * len(row)
    for item in row:
        padding = ''
        if (max_length[x] - len(item)) > 0:
            padding = ' ' * (max_length[x] - len(item[x]))
        formatted_row[x] = item + padding
        x += 1
    print ' | '.join(formatted_row)
