# Kubernetes Kurulumu - MERN Stack + Python ETL

Bu klasörde MERN Stack uygulaması ve Python ETL projesinin Kubernetes'te çalışması için gerekli tüm yapılandırma dosyaları yer almaktadır.

## Dosya Yapısı

- **namespace.yaml**: Kubernetes namespace oluşturma (mern-app)
- **mongodb-deployment.yaml**: MongoDB StatefulSet, PV, PVC ve Services
- **backend-deployment.yaml**: Express.js backend deployment, service ve HPA
- **frontend-deployment.yaml**: React frontend deployment, service ve HPA
- **python-cronjob.yaml**: Python ETL CronJob (her 1 saatte bir çalışır)
- **ingress.yaml**: Ingress konfigürasyonu (opsiyonel)

## Deploy Adımları

### 1. Namespace Oluştur
```bash
kubectl apply -f namespace.yaml
```

### 2. MongoDB'yi Deploy Et
```bash
kubectl apply -f mongodb-deployment.yaml
```

MongoDB'nin hazır olmasını bekle:
```bash
kubectl get pods -n mern-app -w
# MongoDB pod'u Running durumda olana kadar bekle
```

### 3. Backend'i Deploy Et
Önce Docker imajını oluştur:
```bash
cd ../mern-project/server
docker build -t mern-backend:latest .
```

Ardından deploy et:
```bash
kubectl apply -f backend-deployment.yaml
```

### 4. Frontend'i Deploy Et
Önce Docker imajını oluştur:
```bash
cd ../mern-project/client
docker build -t mern-frontend:latest .
```

Ardından deploy et:
```bash
kubectl apply -f frontend-deployment.yaml
```

### 5. Python ETL CronJob'u Deploy Et
Önce Docker imajını oluştur:
```bash
cd ../python-project
docker build -t mern-python-etl:latest .
```

Ardından deploy et:
```bash
kubectl apply -f python-cronjob.yaml
```

### 6. Ingress Deploy Et (Opsiyonel)
```bash
kubectl apply -f ingress.yaml
```

## Durumunu Kontrol Et

Tüm pod'ları görüntüle:
```bash
kubectl get pods -n mern-app
```

Deployments'i kontrol et:
```bash
kubectl get deployments -n mern-app
```

StatefulSets'i kontrol et:
```bash
kubectl get statefulsets -n mern-app
```

CronJobs'u kontrol et:
```bash
kubectl get cronjobs -n mern-app
```

Services'i kontrol et:
```bash
kubectl get svc -n mern-app
```

## Pod Log'larını Kontrol Et

Frontend log'ları:
```bash
kubectl logs -n mern-app -l app=frontend -f
```

Backend log'ları:
```bash
kubectl logs -n mern-app -l app=backend -f
```

MongoDB log'ları:
```bash
kubectl logs -n mern-app -l app=mongodb -f
```

Python ETL log'ları:
```bash
kubectl logs -n mern-app -l app=python-etl -f
```

## Port Forward (Yerel Test İçin)

Frontend'e erişim:
```bash
kubectl port-forward -n mern-app svc/frontend-service 3000:80
# http://localhost:3000 adresinden erişebilirsin
```

Backend'e erişim:
```bash
kubectl port-forward -n mern-app svc/backend-service 5000:5000
# http://localhost:5000/api/health adresinden kontrol et
```

MongoDB'ye erişim:
```bash
kubectl port-forward -n mern-app svc/mongodb-svc 27017:27017
# mongodb://admin:admin123456@localhost:27017 ile bağlan
```

## Ortam Değişkenleri

### Backend
- PORT: 5000
- MONGODB_HOST: mongodb-svc
- MONGODB_PORT: 27017
- MONGODB_DATABASE: mern-db
- MONGODB_USER: admin
- MONGODB_PASSWORD: admin123456

### Frontend
- REACT_APP_API_URL: http://backend-service:5000

### Python ETL
- MONGODB_HOST: mongodb-svc
- MONGODB_PORT: 27017
- MONGODB_DATABASE: mern-db
- MONGODB_USER: admin
- MONGODB_PASSWORD: admin123456

## Skalama

### Backend'i Manuel Olarak Ölçeklendir
```bash
kubectl scale deployment/backend --replicas=3 -n mern-app
```

### Frontend'i Manuel Olarak Ölçeklendir
```bash
kubectl scale deployment/frontend --replicas=3 -n mern-app
```

HPA (Horizontal Pod Autoscaler) otomatik olarak CPU ve bellek kullanımına göre ölçeklendir.

## Temizlik

Tüm kaynakları sil:
```bash
kubectl delete namespace mern-app
```

## Sorun Giderme

### Pod'un başlatılmadığını görmek
```bash
kubectl describe pod <pod-name> -n mern-app
```

### MongoDB bağlantı hatası
- MongoDB pod'unun Running durumda olduğundan emin ol
- Secret bilgilerinin doğru olduğunu kontrol et
- Networkünü kontrol et: `kubectl get svc -n mern-app`

### CronJob çalışmıyor
```bash
# CronJob durumunu kontrol et
kubectl get cronjob python-etl -n mern-app

# Son Job'ları görmek için
kubectl get jobs -n mern-app -l app=python-etl
```

### Manuel Test Et
```bash
# Python ETL job'unu manuel olarak çalıştır
kubectl apply -f python-cronjob.yaml
kubectl get jobs -n mern-app
kubectl logs -n mern-app job/python-etl-manual
```

## Notlar

- MongoDB için persistent storage kullanılmaktadır
- Backend ve Frontend otomatik ölçekleme özelliğine sahiptir
- Python ETL her saatin başında (0. dakikada) çalışır
- Tüm uygulamalar resource requests ve limits ayarlarına sahiptir
- Liveness ve readiness probes konfigüre edilmiştir
