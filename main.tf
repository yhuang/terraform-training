#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-a2a469e9
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-coyote
#

terraform {
  backend "atlas" {
    name    = "jimmy-huang-ck/training"
    address = "https://atlas.hashicorp.com"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "count" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.count}"
  instance_type          = "t2.micro"
  ami                    = "ami-d651b8ac"
  subnet_id              = "subnet-a2a469e9"
  vpc_security_group_ids = ["sg-2788a154"]

  tags {
    Name     = "training ${count.index + 1} / ${var.count}"
    Owner    = "Jimmy Huang"
    Identity = "NWI-vault-coyote"
  }
}

module "example" {
  source = "./example-module"
  command = "echo 'goodbye world'"
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
