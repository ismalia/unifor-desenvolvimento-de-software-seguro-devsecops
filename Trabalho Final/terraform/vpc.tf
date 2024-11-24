###########
### VPC ###
###########

resource "aws_vpc" "defectdojo_vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

#######################
### PRIVATE SUBNETS ###
#######################

resource "aws_subnet" "private_subnet" {
  count = length(local.private_subnets)

  availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block           = element(concat(local.private_subnets, [""]), count.index)
  vpc_id               = aws_vpc.defectdojo_vpc.id

  tags = {
    Name = format("${var.vpc_name}-${var.private_subnet_suffix}-%s", element(local.azs, count.index))
  }
}

######################
### PUBLIC SUBNETS ###
######################

# resource "aws_subnet" "public_subnet" {
#   count = length(local.public_subnets)

#   availability_zone    = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
#   availability_zone_id = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
#   cidr_block           = element(concat(local.public_subnets, [""]), count.index)
#   vpc_id               = aws_vpc.defectdojo_vpc.id

#   tags = {
#     Name = format("${var.vpc_name}-${var.public_subnet_suffix}-%s", element(local.azs, count.index))
#   }
# }
