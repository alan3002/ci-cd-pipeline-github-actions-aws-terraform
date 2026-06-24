# 🚀ci-cd-pipeline-github-actions-aws-terraform
-------------------------------------------------

A complete DevOps project demonstrating modern cloud-native application deployment using:

* Docker Containerization
* Multi-Stage Docker Builds
* Docker Compose
* GitHub Actions CI/CD
* Trivy Security Scanning
* Amazon ECR
* Terraform Infrastructure as Code (IaC)
* AWS VPC
* AWS EC2
* AWS EKS

---

# 📖 Project Overview

This project demonstrates the complete DevOps lifecycle from application development to cloud deployment.

The goal is to:

1. Develop and test an application.
2. Containerize the application using Docker.
3. Build automated CI/CD pipelines.
4. Scan images for security vulnerabilities.
5. Push images to Amazon ECR.
6. Provision infrastructure using Terraform.
7. Deploy workloads on AWS infrastructure.

---

# 🏗️ Project Architecture

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Run Unit Tests
    ├── Build Docker Image
    ├── Trivy Security Scan
    └── Push Image to Amazon ECR
    │
    ▼
Amazon ECR
    │
    ▼
AWS Infrastructure (Terraform)
    │
    ├── VPC
    ├── Subnets
    ├── Security Groups
    ├── EC2
    └── EKS
```

---

# 📂 Project Structure

```text
devops-master-project
│
├── .github
│   └── workflows
│       ├── ci.yml
│       └── terraform.yml
│
├── app
│   ├── main.py
│   ├── test_main.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── terraform
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   │
│   └── modules
│       ├── vpc
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       └── ec2
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
└── README.md
```

---

# 🐍 Application

A simple FastAPI application.

## main.py

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {
        "message": "DevOps Project Running"
    }
```

---

# 🧪 Unit Testing

## test_main.py

```python
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_home():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json() == {
        "message": "DevOps Project Running"
    }
```

Run tests:

```bash
cd app

pytest
```

Expected Output:

```bash
1 passed
```

---

# 🐳 Docker

## What is Docker?

Docker packages applications and dependencies into containers.

Benefits:

* Consistent environments
* Faster deployments
* Easy scaling
* Platform independence

---

# 🐳 Docker Image Layering

Every Docker instruction creates a layer.

Example:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["uvicorn","main:app"]
```

Layers:

```text
Layer 1 → Base Image
Layer 2 → Workdir
Layer 3 → Copy requirements
Layer 4 → Install dependencies
Layer 5 → Copy source code
Layer 6 → Start application
```

Docker reuses unchanged layers to speed up builds.

---

# 🚀 Multi-Stage Build

Purpose:

* Reduce image size
* Improve security
* Remove build dependencies

Example:

```dockerfile
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt

COPY . .

FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --from=builder /app .

EXPOSE 8000

CMD ["uvicorn","main:app","--host","0.0.0.0","--port","8000"]
```

---

# 🐳 Docker Compose

Run multiple containers together.

Example:

```yaml
version: "3.9"

services:
  app:
    build: .
    ports:
      - "8000:8000"
```

Start:

```bash
docker compose up -d
```

Check:

```bash
docker ps
```

---

# ⚙️ GitHub Actions CI/CD

The CI pipeline automatically runs whenever code is pushed.

Workflow:

```text
Code Push
    │
    ▼
Checkout Code
    │
    ▼
Install Dependencies
    │
    ▼
Run Unit Tests
    │
    ▼
Build Docker Image
    │
    ▼
Trivy Scan
    │
    ▼
Login to ECR
    │
    ▼
Push Image to ECR
```

---

# 🔒 Trivy Security Scanning

Trivy scans container images for:

* Critical vulnerabilities
* High vulnerabilities
* Misconfigurations
* Secrets

Example:

```yaml
- name: Trivy Scan
  uses: aquasecurity/trivy-action@master
```

---

# 📦 Amazon ECR

Amazon Elastic Container Registry stores Docker images.

Login:

```bash
aws ecr get-login-password \
--region us-east-1 \
| docker login \
--username AWS \
--password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

Push Image:

```bash
docker tag app:latest \
<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/app:latest

docker push \
<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/app:latest
```

---

# 🏗️ Infrastructure as Code (Terraform)

Terraform provisions infrastructure using code.

Benefits:

* Repeatable deployments
* Version control
* Automation
* Reduced human errors

---

# 📚 Terraform Concepts

## Declarative

Describe desired state.

```hcl
resource "aws_instance" "web" {
  ami = "ami-xxxx"
}
```

Terraform decides how to create it.

---

## State File

Terraform tracks resources using:

```text
terraform.tfstate
```

Never manually edit the state file.

---

## Plan

Preview changes:

```bash
terraform plan
```

---

## Apply

Deploy resources:

```bash
terraform apply
```

---

# 🧩 Terraform Modules

Modules make Terraform reusable.

## VPC Module

Creates:

* VPC
* Public Subnet
* Route Table
* Internet Gateway

## EC2 Module

Creates:

* EC2 Instance
* Security Group

## EKS Module

Creates:

* EKS Control Plane
* Managed Node Group
* IAM Roles

---

# 🌐 Provider Configuration

```hcl
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

---

# 🏗️ Root Module Example

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
}

module "ec2" {
  source = "./modules/ec2"

  subnet_id = module.vpc.subnet_id
}
```

---

# ⚙️ Terraform CI/CD Pipeline

Workflow:

```text
Push Terraform Code
      │
      ▼
terraform fmt
      │
      ▼
terraform init
      │
      ▼
terraform validate
      │
      ▼
terraform plan
      │
      ▼
Manual Approval
      │
      ▼
terraform apply
```

---

# 🚀 Deployment Steps

## 1. Clone Repository

```bash
git clone https://github.com/yourusername/devops-master-project.git

cd devops-master-project
```

---

## 2. Run Application

```bash
cd app

pip install -r requirements.txt

uvicorn main:app --reload
```

Open:

```text
http://localhost:8000
```

---

## 3. Build Docker Image

```bash
docker build -t devops-app .
```

---

## 4. Run Container

```bash
docker run -d -p 8000:8000 devops-app
```

---

## 5. Terraform Deployment

```bash
cd terraform

terraform init

terraform validate

terraform plan

terraform apply
```

---

# 🔧 Prerequisites

Install:

* Git
* Docker
* Docker Compose
* AWS CLI
* Terraform
* Python 3.12+
* GitHub Account
* AWS Account

---

# 🎯 Learning Outcomes

By completing this project you will understand:

✅ Docker Containerization

✅ Docker Layering

✅ Multi-Stage Docker Builds

✅ Docker Compose

✅ FastAPI Development

✅ Unit Testing with Pytest

✅ GitHub Actions CI/CD

✅ Trivy Security Scanning

✅ Amazon ECR

✅ Terraform Basics

✅ Terraform Modules

✅ AWS VPC

✅ AWS EC2

✅ AWS EKS

✅ Infrastructure as Code

---

# 👨‍💻 Author

Alan Biju

DevOps Intern

Saints and Masters

AWS | Docker | Kubernetes | Terraform | CI/CD | DevOps
