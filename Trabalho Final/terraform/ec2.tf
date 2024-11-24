data "aws_availability_zones" "available" {}

data "aws_iam_policy_document" "ec2_assume_role_iam_policy_document" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "aws_partition" "current" {}

data "aws_ssm_parameter" "ami_ssm_parameter" {
  name = var.ami_ssm_parameter
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
  private_subnets = [for k, v in local.azs : cidrsubnet(aws_vpc.defectdojo_vpc.cidr_block, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(aws_vpc.defectdojo_vpc.cidr_block, 8, k + 48)]
}

# Elastic IP

resource "aws_eip" "defectdojo_eip" {
  domain   = var.eip_domain
  instance = aws_instance.defectdojo_instance.id
}

# IAM

resource "aws_iam_role" "defectdojo_iam_role" {
  name                  = var.iam_role_name
  description           = "Role para a instância do DefectDojo no EC2"
  assume_role_policy    = data.aws_iam_policy_document.ec2_assume_role_iam_policy_document.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "defectdojo_iam_role_policy_attachment" {
  for_each = { for k, v in local.iam_role_policies : k => v }

  policy_arn = each.value
  role       = aws_iam_role.defectdojo_iam_role.name
}

resource "aws_iam_instance_profile" "defectdojo_iam_instance_profile" {
  name = var.iam_role_name
  role = aws_iam_role.defectdojo_iam_role.name

  lifecycle {
    create_before_destroy = true
  }
}

# Placement Group

resource "aws_placement_group" "defectdojo_placement_group" {
  name     = var.placement_group_name
  strategy = "cluster"
}

################
### INSTANCE ###
################

resource "aws_instance" "defectdojo_instance" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami_ssm_parameter.value)
  availability_zone      = element(local.azs, 0)
  disable_api_stop       = false
  iam_instance_profile   = aws_iam_instance_profile.defectdojo_iam_instance_profile.name
  instance_type          = var.instance_type
  placement_group        = aws_placement_group.defectdojo_placement_group.id
  subnet_id              = element(local.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.defectdojo_security_group.id]

  tags = {
    Name = var.instance_name
  }
}
