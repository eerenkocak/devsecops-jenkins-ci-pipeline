# 🛡️ DevSecOps CI Pipeline with Jenkins, Docker & Trivy Security Scanning

[🌍 English Documentation](#english-version) | [🇹🇷 Türkçe Dökümantasyon](#türkçe-versiyon)

---

## <a name="english-version"></a>🇺🇸 English Version

This repository demonstrates an automated, security-first **DevSecOps Continuous Integration (CI)** architecture. The Jenkins controller infrastructure is provisioned via **Terraform** on **AWS (`eu-north-1`)**, while application builds are governed by a declarative `Jenkinsfile` integrating isolated container testing, multi-stage Docker builds, **Aqua Security Trivy** vulnerability scanning, and ChatOps alerting.

### 🚀 Key DevSecOps & Engineering Practices

* **Infrastructure as Code (IaC) Provisioning (`terraform/`):** Automates the deployment of an **IMDSv2-hardened**, FinOps-constrained EC2 Jenkins controller (`cpu_credits = "standard"`, encrypted `gp3` storage) pre-configured with Docker Engine, Java 21, and Trivy via bootstrap scripts.
* **Declarative Pipeline as Code (`Jenkinsfile`):** Eliminates manual UI configuration by defining the entire CI lifecycle in version-controlled Groovy syntax.
* **Containerized Test Isolation:** Executes automated unit and sanity checks inside ephemeral `node:20-alpine` containers without polluting the host controller environment.
* **Multi-Stage Production Builds:** Compiles ultra-lightweight, non-root (`USER node`) Alpine Docker images to minimize runtime attack surfaces.
* **Automated Vulnerability Gating (Trivy):** Scans every newly built container image for `HIGH` and `CRITICAL` CVEs via Docker socket mounting, automatically breaking the build (`--exit-code 1`) if security thresholds are violated.
* **GitHub Webhooks & ChatOps:** Triggers pipelines instantaneously upon `git push` events and dispatches real-time build/security status alerts via Discord/Slack webhooks.

### 📐 Project Structure
```text
devsecops-jenkins-ci-pipeline/
├── app/
│   ├── package.json       # Node.js dependencies & test scripts
│   ├── server.js          # Telemetry REST API
│   └── test.js            # Automated unit & sanity checks
├── terraform/
│   ├── main.tf            # Hardened EC2 & Security Group definitions
│   ├── variables.tf       # FinOps instance type validation guardrails
│   ├── outputs.tf         # Controller URL & IP telemetry
│   └── userdata.sh        # Automated Jenkins, Docker & Trivy bootstrap
├── Dockerfile             # Multi-stage, non-root production image
├── .dockerignore          # Build context filter
├── Jenkinsfile            # Declarative DevSecOps CI pipeline
└── .gitignore             # State & dependency exclusion rules
```

---

## <a name="türkçe-versiyon"></a>🇹🇷 Türkçe Versiyon

Bu depo, güvenlik odaklı otomatik bir **DevSecOps Sürekli Entegrasyon (CI)** mimarisidir. Jenkins sunucu altyapısı **AWS (`eu-north-1`)** üzerinde **Terraform** ile otomatik olarak kurulurken; uygulama derleme ve güvenlik süreçleri izole konteyner testleri, çok aşamalı (multi-stage) Docker imaj üretimi, **Trivy** zafiyet taraması ve ChatOps bildirimlerini içeren deklaratif bir `Jenkinsfile` ile yönetilir.

### 🚀 Öne Çıkan DevSecOps ve Mühendislik Pratikleri

* **Kod Olarak Altyapı (`terraform/`):** **IMDSv2** güvenlik sertleştirmesi ve FinOps limitleri uygulanmış EC2 Jenkins sunucusunu, içerisinde Docker, Java 21 ve Trivy hazır kurulu şekilde tek komutla ayağa kaldırır.
* **Kod Olarak Pipeline (`Jenkinsfile`):** Arayüzden manuel ayar yapmak yerine tüm CI yaşam döngüsünü versiyon kontrollü deklaratif kod ile yönetir.
* **İzole Konteyner Testleri:** Ana sunucuyu kirletmeden geçici `node:20-alpine` konteynerleri içerisinde otomatik birim (unit) testlerini koşar.
* **Çok Aşamalı İmaj Üretimi:** Yetkisiz kullanıcı (`USER node`) ile çalışan ultra hafif prodüksiyon imajları derler.
* **Trivy Güvenlik Kapısı (DevSecOps):** Derlenen her Docker imajını `HIGH` ve `CRITICAL` güvenlik açıklarına karşı tarar; kritik açık tespit ederse pipeline'ı otomatik durdurarak (`--exit-code 1`) güvensiz kodun ilerlemesini engeller.
* **GitHub Webhook & ChatOps:** Depoya yapılan her `git push` işleminde hattı anında tetikler ve sonuçları Discord/Slack kanallarına bildirir.
