# EC2 Owner Sort Demo
## Version
1.0
## Purpose
Output sorted EC2 Instances by tagged owner or arbitrary tag.

## Testing Enviroment
This demo was tested in the following enviroment, it should work on all distributions of ruby later than 2.0.0

- Amazon Linux  (amzn-ami-hvm-2016.09)
- Ruby 2.0.0p648

## Example
```
$ ruby instance_owner_sort.rb -t Owner -r us-west-2  -i -w -m
INSTANCE_ID | TYPE      | OWNER   | LAUNCH_TIME             | PRIVATE_IP_ADDRESS | INSTANCE_STATE | IAM_INSTANCE_PROFILE
------------|-----------|---------|-------------------------|--------------------|----------------|---------------------
i-55d69f8c  | t2.micro  | Unknown | 2015-12-22 19:25:27     | 10.0.0.240         | stopped        |
i-5565829c  | m4.large  | Unknown | 2015-07-02 03:14:39     | 10.0.0.225         | stopped        |
i-dce108d0  | t2.medium | Unknown | 2014-10-22 03:12:54     | 10.0.0.252         | stopped        | serverspinup
```
## Usage
## Install the required ruby gems

```
gem install aws-sdk
gem install table_print
```

## Execute the application
### Default Exection

```
ruby instance_owner_sort.rb
```

### Custom Access Keys (Defaults to instance profile)

```
ruby instance_owner_sort.rb -a <your_access_key> -s <your_secret_access_key>
```
### Custom region (Defaults to us-west-2)

```
ruby instance_owner_sort.rb -r us-west-1
```
### Custom tag (Defaults to Owner)

```
ruby instance_owner_sort.rb -t Owner
```

### Display Instance Private IP address

```
ruby instance_owner_sort.rb -i
```
### All Together

```
ruby instance_owner_sort.rb -a <your_access_key> -s <your_secret_access_key> -t Owner -r us-west-2  -i -w -m
```