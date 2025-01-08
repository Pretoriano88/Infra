variable "region" {
  default = "us-east-1"
}
variable "myip" {
  default = "177.30.73.144"
}
variable "sns-email" {
  default = "teste@hotmail.com"
}
// ec2 

variable "ami" {
  description = "The AMI for the EC2 instance"
  type        = string

}
variable "instance_type" {

}
variable "key_name" {

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

