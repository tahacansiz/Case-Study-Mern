# Terraform MERN + k3s Infrastructure

Bu Terraform konfigürasyonu AWS EC2 üzerinde k3s Kubernetes cluster için Infrastructure as Code sunmaktadır.

## 📋 Yapı

```
terraform/
├── provider.tf          # AWS provider ayarları
├── main.tf             # EC2, Security Group kaynakları
├── variables.tf        # Değişken tanımları
├── outputs.tf          # Çıktı tanımları
├── terraform.tfvars    # Değişken değerleri
└── README.md           # Bu dosya
```

## 🚀 Hızlı Başlangıç

### 1. Ön Koşullar
```bash
# Terraform yüklü mü?
terraform --version

# AWS CLI credentials yapılandırılmış mı?
aws sts get-caller-identity

# Key pair var mı?
aws ec2 describe-key-pairs --key-names mern-key --region eu-north-1
```

### 2. Terraform Komutları

#### `terraform init` - İlk Kurulum
```bash
cd terraform/
terraform init
```
**Ne yapıyor:**
- Terraform çalışma dizinini hazırlar
- AWS provider plugin'ini indirir
- `.terraform/` dizini oluşturur
- `.terraform.lock.hcl` dosyası oluşturur (versiyon kilitlemesi için)

**Çıktı:**
```
Terraform has been successfully initialized!
```

---

#### `terraform plan` - Değişiklikleri Göster
```bash
terraform plan -out=tfplan
```
**Ne yapıyor:**
- Yapılandırdığınız kaynakları kontrol eder
- Mevcut AWS durumu ile karşılaştırır
- Ne oluşturulacağını, değiştirileceğini, silineceğini gösterir
- Gerçek değişiklik yapmaz

**Çıktı örneği:**
```
Plan: 2 to add, 0 to change, 0 to destroy.
- aws_security_group.mern_k3s_sg
- aws_instance.mern_k3s_server
```

---

#### `terraform apply` - Değişiklikleri Uygula
```bash
terraform apply tfplan
```
**Ne yapıyor:**
- `terraform plan` tarafından hazırlanan değişiklikleri AWS'ye gönderir
- EC2 instance'ı oluşturur
- Security Group kurallarını ayarlar
- İşlem tamamlandıktan sonra output'ları gösterir

**Çıktı örneği:**
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
instance_public_ip = "1.2.3.4"
ssh_command = "ssh -i /path/to/mern-key.pem ubuntu@1.2.3.4"
```

---

### 3. SSH ile Bağlanma
```bash
# Output'tan aldığınız public IP ile:
ssh -i /path/to/mern-key.pem ubuntu@<PUBLIC_IP>

# Veya Terraform output'unu kullanarak:
terraform output -raw ssh_command
```

---

## ⚙️ Yapılandırma

### terraform.tfvars Değişkenleri
Değiştirmek istediğiniz değerleri `terraform.tfvars`'da güncelleyin:

| Değişken | Açıklama | Örnek |
|----------|----------|-------|
| `aws_region` | AWS Bölgesi | `eu-north-1` |
| `instance_type` | EC2 Tipi | `t3.medium`, `t3.large` |
| `instance_name` | Instance Adı | `mern-k3s-server` |
| `key_pair_name` | SSH Key Pair Adı | `mern-key` |
| `volume_size` | Disk Boyutu (GB) | `30`, `50` |

### Portlar
`ingress_ports` haritasında tanımlı:
- **22** - SSH
- **80** - HTTP (Frontend)
- **3000** - React App
- **5000** - Node.js API
- **6443** - k3s Kubernetes API

**Yeni port eklemek:**
```hcl
ingress_ports = {
  ssh   = { port = 22,   protocol = "tcp" }
  http  = { port = 80,   protocol = "tcp" }
  app   = { port = 3000, protocol = "tcp" }
  api   = { port = 5000, protocol = "tcp" }
  k3s   = { port = 6443, protocol = "tcp" }
  mongo = { port = 27017, protocol = "tcp" }  # MongoDB ekle
}
```

---

## 📊 Terraform Dosyaları

### State Dosyası
- **`terraform.tfstate`** - Mevcut kaynakların durumunu tutar
- **`terraform.tfstate.backup`** - Önceki durumun yedekleme
- ⚠️ **ASLA** git'e commit etmeyin!

`.gitignore`'a ekle:
```
terraform.tfstate*
.terraform/
.terraform.lock.hcl
```

---

## 🔄 Değişiklikleri Güncelleme

### Mevcut Instance'ı Güncelle
```bash
# terraform.tfvars'da değişiklik yap
nano terraform.tfvars

# Plan et
terraform plan -out=tfplan

# Uygula
terraform apply tfplan
```

### Instance'ı Sil
```bash
terraform destroy
# "yes" yazıp onayla
```

---

## 🛡️ Security Best Practices

### 1. Security Group CIDR'ı Kısıtla
**Şu anki ayar** - Herkese açık:
```hcl
cidr_blocks = ["0.0.0.0/0"]
```

**Production için** - Sadece IP'niz:
```hcl
cidr_blocks = ["YOUR_IP/32"]
```

Örnek:
```bash
# Genel IP'nizi öğren
curl https://checkip.amazonaws.com
# 203.0.113.25 gibi bir sonuç alırsınız
```

### 2. Elastic IP Kütüphanesi
Sabit IP istersen `main.tf`'de yorum açılan bölümü aktif et.

### 3. Credentials
- AWS credentials'ı `~/.aws/credentials`'da tutun
- `terraform.tfvars`'ı `.gitignore`'a ekle

---

## 📝 Örnek İş Akışı

```bash
# 1. Başlat
terraform init

# 2. Planı gör
terraform plan

# 3. Uygula
terraform apply

# 4. Outputs al
terraform output

# 5. SSH ile bağlan
ssh -i mern-key.pem ubuntu@$(terraform output -raw instance_public_ip)

# 6. k3s kontrolü yap
kubectl get nodes

# 7. Değişiklik yap (opsiyonel)
# terraform.tfvars'da bir değeri değiştir
terraform plan
terraform apply

# 8. Sil
terraform destroy
```

---

## 🔗 Kaynaklar

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EC2 Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Security Group Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

---

## ⚠️ Mevcut Sistemi Bozmama

Bu Terraform setup:
- ✅ Yeni resources oluşturur
- ✅ Mevcut EC2'ye dokunmaz
- ✅ Harici state management kullanır
- ✅ Kolay rollback yapabilir

**Eğer farklı AWS account/region kullanıyorsan:**
- `provider.tf`'de region değiştir
- `terraform.tfvars`'da account-specific values set et
- `terraform plan` ile kontrol et

---

**Sorular?** Terraform apply yapmadan `terraform plan` çıktısını incele!
