#############
### GERAL ###
#############

variable "profile" {
  default     = "unifor"
  description = "Profile da AWS"
  type        = string
}

variable "region" {
  default     = "us-east-1"
  description = "Região da AWS"
  type        = string
}

variable "repository" {
  default     = "https://github.com/ismalia/unifor-desenvolvimento-de-software-seguro-devsecops"
  description = "Repositório do projeto"
  type        = string
}

###########
### EC2 ###
###########

# Instance

variable "ami_ssm_parameter" {
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
  description = "Nome do parâmetro público do SSM que contém o ID do AMI"
  type        = string
}

variable "instance_name" {
  default     = "EC2-DefectDojo"
  description = "Nome da instância EC2"
  type        = string
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Tipo de instância"
  type        = string
}

# Elastic IP

variable "eip_domain" {
  default     = "vpc"
  description = "Indica se o EIP é para uso na VPC"
  type        = string
}

# IAM

variable "iam_role_name" {
  default     = "DefectDojoRole"
  description = "Nome da role do IAM"
  type        = string
}

# Placement Group

variable "placement_group_name" {
  default     = "DefectDojo-PlacementGroup"
  description = "Grupo de posicionamento da instância"
  type        = string
}

######################
### SECURITY GROUP ###
######################

# Security Group

variable "security_group_name" {
  default     = "SG-DefectDojo"
  description = "Nome do Security Group"
  type        = string
}

variable "timeout_create_security_group" {
  default     = "10m"
  description = "Tempo de espera pela criação do Security Group"
  type        = string
}

variable "timeout_delete_security_group" {
  default     = "15m"
  description = "Tempo de espera pela deleção do Security Group"
  type        = string
}

# Ingress

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "Lista de ranges CIDR IPv4 a ser usada em todas as regras de ingress"
  type        = list(string)
}

# Egress

variable "egress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "Lista de ranges CIDR IPv4 a ser usada em todas as regras de egress"
  type        = list(string)
}

# Regras

variable "rules" {
  default = {
    # HTTP
    http-80-tcp = [80, 80, "tcp", "HTTP"]
    # Abre todas as portas em um protocolo
    all-all  = [-1, -1, "-1", "All protocols"]
    all-icmp = [-1, -1, "icmp", "All IPv4 ICMP"]
  }
  description = "Mapa de regras conhecidas para o Security Group ('nome' = ['from port', 'to port', 'protocolo', 'descrição'])"
  type        = map(list(any))
}

###########
### VPC ###
###########

# VPC

variable "cidr" {
  default     = "10.0.0.0/16"
  description = "Bloco CIDR IPv4 da VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  default     = true
  description = "Habilita DNS hostnames na VPC"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "Habilita DNS support na VPC"
  type        = bool
}

variable "instance_tenancy" {
  default     = "default"
  description = "Tenancy das instâncias criadas na VPC"
  type        = string
}

variable "vpc_name" {
  default     = "VPC-DefectDojo"
  description = "Nome a ser usado como identificador em todos os recursos"
  type        = string
}

# Private subnets

variable "private_subnet_suffix" {
  default     = "Private"
  description = "Sufixo nos nome das subnets privadas"
  type        = string
}

# Public subnets

variable "public_subnet_suffix" {
  default     = "Public"
  description = "Sufixo nos nomes das subnets públicas"
  type        = string
}
