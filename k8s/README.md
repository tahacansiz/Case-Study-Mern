# Kubernetes Deployment Guide - MERN Stack + Python ETL

Bu klasörde MERN Stack uygulaması ve Python ETL projesinin Kubernetes ortamında çalıştırılması için gerekli deployment ve orchestration yapılandırmaları yer almaktadır.

## Dosya Yapısı

* **namespace.yaml**: Kubernetes namespace oluşturma (mern-app)
* **mongodb-deployment.yaml**: MongoDB deployment, persistent storage ve service yapılandırmaları
* **backend-deployment.yaml**: Express.js backend deployment ve service yapılandırmaları
* **frontend-deployment.yaml**: React frontend deployment ve service yapılandırmaları
* **python-cronjob.yaml**: Python ETL CronJob workload yapılandırması
* **ingress.yaml**: Opsiyonel ingress örnek yapılandırması

---

# Deployment Steps

## 1. Namespace Oluşturma

```bash
kubectl apply -f namespace.yaml
```

---

## 2. MongoDB Deployment

```bash
kubectl apply -f mongodb-deployment.yaml
```

MongoDB pod’unun hazır olduğunu doğrulamak için:

```bash
kubectl get pods -n mern-app -w
```

---

## 3. Backend Deployment

Docker image build işlemi:

```bash
cd ../mern-project/server

docker build -t tahacansiz/mern-backend:latest .
docker push tahacansiz/mern-backend:latest
```

Deployment işlemi:

```bash
kubectl apply -f backend-deployment.yaml
```

---

## 4. Frontend Deployment

Docker image build işlemi:

```bash
cd ../mern-project/client

docker build -t tahacansiz/mern-frontend:latest .
docker push tahacansiz/mern-frontend:latest
```

Deployment işlemi:

```bash
kubectl apply -f frontend-deployment.yaml
```

---

## 5. Python ETL CronJob Deployment

Docker image build işlemi:

```bash
cd ../python-project

docker build -t tahacansiz/python-etl:latest .
docker push tahacansiz/python-etl:latest
```

Deployment işlemi:

```bash
kubectl apply -f python-cronjob.yaml
```

---

## 6. Ingress Configuration (Optional)

Ingress manifest dosyası örnek yapılandırma amacıyla repository içerisinde tutulmaktadır.

```bash
kubectl apply -f ingress.yaml
```

---

# Kubernetes Resource Verification

## Pod Durumları

```bash
kubectl get pods -n mern-app
```

## Deployments

```bash
kubectl get deployments -n mern-app
```

## CronJobs

```bash
kubectl get cronjobs -n mern-app
```

## Services

```bash
kubectl get svc -n mern-app
```

---

# Log Kontrolleri

## Frontend Logs

```bash
kubectl logs -n mern-app -l app=frontend -f
```

## Backend Logs

```bash
kubectl logs -n mern-app -l app=backend -f
```

## MongoDB Logs

```bash
kubectl logs -n mern-app -l app=mongodb -f
```

## Python ETL Logs

```bash
kubectl logs -n mern-app -l app=python-etl -f
```

---

# Port Forward (Local Testing)

## Frontend Access

```bash
kubectl port-forward -n mern-app svc/frontend-service 3000:80
```

Frontend erişimi:

```text
http://localhost:3000
```

---

## Backend Access

```bash
kubectl port-forward -n mern-app svc/backend-service 5000:5000
```

Backend health endpoint:

```text
http://localhost:5000/api/health
```

---

## MongoDB Access

```bash
kubectl port-forward -n mern-app svc/mongodb-svc 27017:27017
```

MongoDB local connection example:

```text
mongodb://localhost:27017
```

---

# Environment Configuration

## Backend Configuration

* PORT
* MONGODB_HOST
* MONGODB_PORT
* MONGODB_DATABASE

## Frontend Configuration

* REACT_APP_API_URL

## Python ETL Configuration

* MONGODB_HOST
* MONGODB_PORT
* MONGODB_DATABASE

Sensitive configuration values Kubernetes Secrets kullanılarak yönetilmektedir.

---

# Scaling

## Backend Scaling

```bash
kubectl scale deployment/backend --replicas=3 -n mern-app
```

## Frontend Scaling

```bash
kubectl scale deployment/frontend --replicas=3 -n mern-app
```

Horizontal scaling yapılandırmaları deployment manifestleri içerisinde tanımlanmıştır.

---

# Cleanup

Tüm namespace ve Kubernetes kaynaklarını silmek için:

```bash
kubectl delete namespace mern-app
```

---

# Troubleshooting

## Pod Detaylarını Görüntüleme

```bash
kubectl describe pod <pod-name> -n mern-app
```

---

## MongoDB Connection Issues

Kontrol edilmesi gerekenler:

* MongoDB pod status
* Kubernetes service durumu
* Secret configuration
* Network connectivity

Kontrol komutları:

```bash
kubectl get svc -n mern-app
kubectl get pods -n mern-app
```

---

## CronJob Troubleshooting

CronJob durumunu kontrol etme:

```bash
kubectl get cronjob python-etl -n mern-app
```

Job geçmişini görüntüleme:

```bash
kubectl get jobs -n mern-app
```

---

## Manual ETL Test

```bash
kubectl apply -f python-cronjob.yaml
kubectl get jobs -n mern-app
```

---

# Notes

* MongoDB deployment persistent storage kullanmaktadır
* Kubernetes ConfigMaps ve Secrets aktif olarak kullanılmaktadır
* Python ETL workload’u Kubernetes CronJob yapısı ile çalışmaktadır
* Monitoring süreçleri Prometheus ve Grafana ile desteklenmiştir
* Deployment süreçleri GitHub Actions CI/CD pipeline ile otomatikleştirilmiştir
* Kubernetes resource management süreçlerinde resource requests ve limits yapılandırmaları kullanılmıştır
