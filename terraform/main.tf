# Ana Kaynaklar (Resources)

# ============================================================================
# VPC Güvenlik Grubu - İzin verilen portları tanımlar
# ============================================================================

resource "aws_security_group" "mern_k3s_sg" {
  name_prefix = "mern-k3s-"
  description = "Security Group for MERN Stack + k3s Kubernetes"

  # Gelen trafik kuralları (Inbound)
  dynamic "ingress" {
    for_each = var.ingress_ports

    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]  # Herkes erişebilir (UYARI: Production'da kısıtla!)
    }
  }

  # Giden trafik kuralı (Outbound) - Hepsi izinli
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mern-k3s-security-group"
  }
}

# ============================================================================
# Ubuntu AMI'sini bul (en güncel olanı)
# ============================================================================

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical (Ubuntu resmi owner)

  filter {
    name   = "name"
    values = [var.ami_filter]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ============================================================================
# EC2 Instance
# ============================================================================

resource "aws_instance" "mern_k3s_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  monitoring             = var.enable_detailed_monitoring
  vpc_security_group_ids = [aws_security_group.mern_k3s_sg.id]

  # Root volume yapılandırması
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = true
  }

  # Public IP adresi ata (SSH için gerekli)
  associate_public_ip_address = true

  # User Data - Instance başlarken çalışacak script
  # NOT: Mevcut k3s sistemi zaten kurulu olduğu için burada ekleme yapılmıyor
  user_data = base64encode(
    <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y curl wget git
      # k3s ve diğer bileşenler zaten kurulu olmalı
      echo "EC2 Instance ready at $(date)" >> /var/log/setup.log
    EOF
  )

  tags = {
    Name = var.instance_name
  }

  depends_on = [aws_security_group.mern_k3s_sg]
}

# ============================================================================
# Elastic IP (İsteğe bağlı - sabit IP için)
# Yorum: Mevcut sistemi bozmamak için default olarak kapalı
# ============================================================================

# resource "aws_eip" "mern_k3s_eip" {
#   instance = aws_instance.mern_k3s_server.id
#   domain   = "vpc"
#   tags = {
#     Name = "mern-k3s-eip"
#   }
# }
