# DevOps Inference Assignment

Distributed inference platform deployed on AWS using Terraform.  
This setup deploys workers across private infrastructure and exposes inference through a public JSON API.

---

## Architecture

```
                    AWS VPC (10.0.0.0/16)
    ┌─────────────────────────────────────────────────┐
    │                                                 │
    │  Public Subnet (10.0.1.0/24)                    │
    │  ┌───────────────────────────────────────────┐  │
    │  │  API Gateway VM (44.214.108.109)          │  │
    │  │                                           │  │
    │  │  nginx :80                                │  │
    │  │    │                                      │  │
    │  │    ▼                                      │  │
    │  │  iii engine :3111/:49134                  │  │
    │  │    │              │                       │  │
    │  │    ▼              ▼                       │  │
    │  │  caller-worker  inference-worker          │  │
    │  │  (TypeScript)   (Python)                  │  │
    │  │     │              ▲                      │  │
    │  │     └──── RPC ─────┘                      │  │
    │  └───────────────────────────────────────────┘  │
    │                                                 │
    │  Private Subnet (10.0.2.0/24)                   │
    │  ┌─────────────────┐  ┌─────────────────┐       │
    │  │  Worker VM 1    │  │  Worker VM 2    │       │
    │  │  10.0.2.120     │  │  10.0.2.5       │       │
    │  │  No public IP   │  │  No public IP   │       │
    │  └─────────────────┘  └─────────────────┘       │
    └─────────────────────────────────────────────────┘
```

---

# Project Structure

```text
README.md

scripts/
docker-compose.yml

terraform/
├── ec2.tf
├── main.tf
└── variable.tf

workers/
├── caller-worker/
│   ├── src/
│   ├── Dockerfile
│   ├── iii.worker.yaml
│   ├── package.json
│   └── tsconfig.json
│
└── inference-worker/
    ├── Dockerfile
    ├── iii.worker.yaml
    ├── math_worker.py
    └── requirements.txt
```

---

# Infrastructure

Provisioned using Terraform:

- VPC
- Public subnet
- Private subnet
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups
- EC2 instances


---

# Deploy From Scratch

## 1. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/devops-inference-assignment.git

cd devops-inference-assignment
```

---

## 2. Initialize Terraform

```bash
cd terraform

terraform init
```

---


## 3. Create Infrastructure

```bash
terraform apply
```

Terraform provisions:
- networking
- subnets
- NAT gateway
- EC2 instances
- security groups

---

## 4. SSH Into API Gateway

```bash
ssh -i iii-key.pem ubuntu@<API_PUBLIC_IP>
```

---

## 5. Install Docker

```bash
sudo apt update -y
sudo apt install docker.io docker-compose -y

sudo systemctl enable docker
sudo systemctl start docker
```

---

## 6. Start Services

```bash
docker-compose up -d
```

---


# RPC Flow

```text
Client Request
      |
      v
HTTP JSON API
      |
      v
caller-worker
      |
      | RPC
      v
inference-worker
      |
      v
JSON Response
```

---

