locals {
  ingress_rules = [
    "http-80-tcp",
    "all-icmp"
  ]
  egress_rules = [
    "all-all"
  ]
}

######################
### SECURITY GROUP ###
######################

resource "aws_security_group" "defectdojo_security_group" {
  name        = var.security_group_name
  description = "Security Group atrelado à instância do DefectDojo no EC2"
  vpc_id      = aws_vpc.defectdojo_vpc.id

  tags = {
    Name = var.security_group_name
  }

  timeouts {
    create = var.timeout_create_security_group
    delete = var.timeout_delete_security_group
  }
}

###############
### INGRESS ###
###############

resource "aws_security_group_rule" "defectdojo_ingress_security_group_rule" {
  count = length(local.ingress_rules)

  type              = "ingress"
  description       = var.rules[local.ingress_rules[count.index]][3]
  cidr_blocks       = var.ingress_cidr_blocks
  from_port         = var.rules[local.ingress_rules[count.index]][0]
  to_port           = var.rules[local.ingress_rules[count.index]][1]
  protocol          = var.rules[local.ingress_rules[count.index]][2]
  security_group_id = aws_security_group.defectdojo_security_group.id
}

##############
### EGRESS ###
##############

resource "aws_security_group_rule" "defectdojo_egress_security_group_rule" {
  count = length(local.egress_rules)

  type              = "egress"
  description       = var.rules[local.egress_rules[count.index]][3]
  cidr_blocks       = var.egress_cidr_blocks
  from_port         = var.rules[local.egress_rules[count.index]][0]
  to_port           = var.rules[local.egress_rules[count.index]][1]
  protocol          = var.rules[local.egress_rules[count.index]][2]
  security_group_id = aws_security_group.defectdojo_security_group.id
}
