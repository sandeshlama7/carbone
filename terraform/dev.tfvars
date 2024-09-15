region = "us-east-1"
## naming
project        = "proposal-generator"
project_short  = "pg"
environment    = "development"
project_prefix = "prop-gen"

## vpc
vpc_cidr           = "10.16.0.0/20"
number_of_azs      = 2
vpc_id             = "vpc-03d964f7cd3fa2c74"                                  #Adex poc vpc
public_subnets_id  = ["subnet-091ddaa5a3164fa99", "subnet-0f97b0bb45cdeb3b7"] #us-east-1d and us-east-1a
private_subnets_id = ["subnet-0d1cb005765916ebf", "subnet-094222bc07bb63e74"] #us-east-1d and us-east-1a
