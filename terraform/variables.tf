# Değişken Tanımları
# Bu dosya tüm parametreleri tanımlar, terraform.tfvars'da değerleri set edilir

variable "aws_region" {
  description = "AWS Bölgesi (Region)"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Ortam adı (prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Proje adı (tag'ler için kullanılır)"
  type        = string
  default     = "mern-k3s"
}

variable "instance_type" {
  description = "EC2 Instance Tipi"
  type        = string
  default     = "t3.medium"
}

variable "instance_name" {
  description = "EC2 Instance Adı"
  type        = string
  default     = "mern-k3s-server"
}

variable "key_pair_name" {
  description = "AWS Key Pair Adı (SSH için)"
  type        = string
  default     = "mern-key"
}

variable "ami_filter" {
  description = "EC2 AMI Filtresi (Ubuntu 22.04 LTS)"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "enable_detailed_monitoring" {
  description = "CloudWatch Detailed Monitoring aktif?"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "Root Volume Boyutu (GB)"
  type        = number
  default     = 30
}

# Security Group Portları
variable "ingress_ports" {
  description = "İzin verilen inbound portları"
  type = map(object({
    port     = number
    protocol = string
  }))

  default = {
  ssh  = { port = 22,    protocol = "tcp" }
  http = { port = 80,    protocol = "tcp" }
  https = { port = 443,  protocol = "tcp" }
  frontend = { port = 30080, protocol = "tcp" }
  backend  = { port = 30500, protocol = "tcp" }
}
}
