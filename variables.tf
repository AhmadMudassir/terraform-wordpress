variable "region" {
  default = "us-east-2"
}

variable "ami" {
  default = "ami-004364947f82c87a0"
}

variable "type" {
  default = "t2.micro"
}

variable "keypair" {
  default = "key-ahmad"
}

variable "owner" {
  default = "ahmad"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "subnet-cidr" {
  default = "10.0.1.0/24"
}

variable "all-traffic-cidr" {
  default = "0.0.0.0/0"
}