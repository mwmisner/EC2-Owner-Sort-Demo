require 'optparse'
require 'net/http'
require 'json'
require 'aws-sdk'
require 'table_print'
# Gather options provided to program
options = {}
OptionParser.new do |o|
  o.banner = 'Usage: example.rb [options]'
  o.on('-a v', '--access_key v', 'AWS IAM Access Key. (Required without instance profile)') { |v| options[:access_key] = v }
  o.on('-s v', '--secret_key v', 'AWS IAM Access Key. (Required without instance profile)') { |v| options[:secret_key] = v }
  o.on('-r r', '--region r', 'AWS Region (Defaults to us-west-2)') { |v| options[:region] = v }
  o.on('-t t', '--tag', 'AWS Instance Owner Tag (Defaults to Owner )') { |v| options[:tag] = v }
  o.on('-i', '--private_ip_address', 'Display AWS Private IP Address') { |v| options[:private_ip_address] = v }
  o.on('-w', '--instance_state', 'Display AWS Instance State') { |v| options[:instance_state] = v }
  o.on('-m', '--iam_instance_profile', 'Display AWS Instance Iam Instance Profile') { |v| options[:iam_instance_profile] = v }
  o.parse!
end

# Setup a default region and tag if not set in options.
options[:region] ||= 'us-west-2'
options[:tag] ||= 'Owner'

if (options[:access_key] || options[:secret_key])
  # Initialize Aws with parameters gathered from opts parse.
  Aws.config.update({
    region: options[:region],
    credentials: Aws::Credentials.new( options[:access_key], options[:secret_key])
  })
else
  # Initialize Aws with local Instance Profile.
  Aws.config.update({
    region: options[:region],
    credentials: Aws::InstanceProfileCredentials.new()
  })
end
begin
  # Create EC2 Client
  ec2 = Aws::EC2::Client.new()
  # Create Hash with information from EC2
  information = ec2.describe_instances().reservations.map! { | i |
    # Set to nil to avoid acidental creation of varible
    owner = nil
    # Search Instance for availble tags
    i.instances[0].tags.each do | tag |
      # If the tag is matches the provided tag, set owner to it's value.
      if tag.key == options[:tag]
        owner = tag.value
      end
    end
    # If owner is not set, set it to unknown.
    owner ||= 'Unknown'
    # Output hash with all parameters selected by user
    # unless statements control inclusion of hash item
    Hash.new.tap do |info|
     info[:instance_id] = i.instances[0].instance_id
     info[:type] = i.instances[0].instance_type
     info[:owner] = owner
     info[:launch_time] = i.instances[0].launch_time
     info[:private_ip_address ] = i.instances[0].private_ip_address unless options[:private_ip_address].nil?
     info[:instance_state ] = i.instances[0].state.name unless options[:instance_state].nil?
     info[:iam_instance_profile ] = i.instances[0].iam_instance_profile.arn.split('/')[-1] rescue " " unless options[:iam_instance_profile].nil?
    end
  }
# Just in case there is an error, inform the user
rescue Aws::EC2::Errors::ServiceError
  'This script failed to query EC2. Check your IAM credentials or Instance Profile.'
end
# Sort the information by the Owner
information = information.sort {|a,b| a[:owner]<=>b[:owner]}
# Pretty print the information out
tp information