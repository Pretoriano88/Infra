variable "myip" {
}
variable "sns-email" {

}

variable "region" {
  type        = string
  description = "AWS region"
}
variable "cidr_vpc" {
  type        = string
  description = "CIDR block for VPC"
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
}
variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
}


// ec2 

variable "ami" {
  description = "The AMI for the EC2 instance"
  type        = string

}
variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
}
variable "key_name" {
  type        = string
  description = "Name of the key pair for EC2"
}

// RDS variables 
variable "db_class_instance" {
  type = string
}

variable "allo_stora" {
  type        = number
  description = "Space for RDS (GB)"
}

variable "dbname" {
  type        = string
  description = "RDS Name"
}

variable "engine" {
  type        = string
  description = "RDS Engine (ex: mysql, postgres, etc.)"
}

variable "v_engine" {
  type        = string
  description = "Version engine"
}

variable "user" {
  type        = string
  description = "RDS user name"
}

variable "password" {
  type        = string
  description = "RDS Password"
}

variable "parameter_group_name" {
  type        = string
  description = "parameter group"
}

variable "port" {
  type        = number
  description = "RDS port"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "skip snapshot in finish rds"
}
variable "multi_az" {
  description = "RDS Multi Avaiable zone"
  type        = bool
}

