variable "region" {
  type        = string
  description = "The region for the resources to be created in"
}

########################
##### Naming
########################

variable "project" {
  type        = string
  description = "The name of the project/app"
}

variable "project_short" {
  type        = string
  description = "Abbreviation of the project name"
}

variable "environment" {
  type = string
}

variable "project_prefix" {
  type        = string
  description = "The prefix for the resources name"
}

########################
###### VPC
########################

variable "vpc_id" {
  type = string
  description = "The vpc id provided statically"
  default = ""
}

variable "public_subnets_id" {
  type = list
  description = "The subnet ids of the public subnets provided statically"
  default = []
}

variable "private_subnets_id" {
  type = list
  description = "The subnet ids of the private subnets provided statically"
  default = []
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR range for the vpc"
}

variable "number_of_azs" {
  type        = number
  description = "The number of AZs inside the VPC"
}
