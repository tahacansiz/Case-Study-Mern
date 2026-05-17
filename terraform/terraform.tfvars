# Terraform Değişkenleri - Buraya ENV-specific değerleri yazın
# Bu dosya .gitignore'a eklenmelidir (credentials içerebilir)

aws_region   = "eu-north-1"
environment  = "prod"
project_name = "mern-k3s"

instance_type = "t3.small"
instance_name = "mern-k3s-server"
key_pair_name = "mern-key"

# Volume boyutu (GB)
volume_size = 30

# CloudWatch monitoring
enable_detailed_monitoring = false

# İzin verilen portlar
ingress_ports = {
  ssh  = { port = 22,    protocol = "tcp" }
  http = { port = 80,    protocol = "tcp" }
  https = { port = 443,  protocol = "tcp" }
  frontend = { port = 30080, protocol = "tcp" }
  backend  = { port = 30500, protocol = "tcp" }
}
