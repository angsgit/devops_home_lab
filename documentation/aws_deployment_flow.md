# 🌍 AWS DevOps Deployment Flow — Infrastructure + App Pipelines

## 📄 Overview

This setup uses **two linked Jenkins pipelines**:

1. **`infra-aws` pipeline** — provisions or destroys AWS infrastructure using Terraform and configures Kubernetes using Ansible.
2. **`app-deploy-aws` pipeline** — deploys the Dockerized Flask app onto the Kubernetes cluster created by the Infra pipeline.

Running one job from Jenkins can build an entire AWS environment and deploy the app end-to-end.

---

## ⚙️ 1. Infra Pipeline — `infra-aws`

### 🧱 Purpose
To create or destroy all AWS resources needed for the Kubernetes cluster (EC2 instances, networking, security groups, etc.) and set up Kubernetes automatically.

---

### 🔢 Pipeline Stages

#### **Stage 1 — Checkout Code**
- Jenkins clones the repo: `https://github.com/angsgit/devops_home_lab`.
- Contains Terraform, Ansible, and Jenkins definitions.

#### **Stage 2 — Terraform Init & Apply**
Runs inside `IaC/terraform`:
```bash
terraform init
terraform apply -auto-approve
```
Creates:
- VPC, subnets, route tables, internet gateway
- EC2 instances: 1 master, 2 workers
- Security groups and networking

Terraform state saved in `terraform.tfstate`.

#### **Stage 3 — Configure Kubernetes via Ansible**
Runs:
```bash
ansible-playbook -i inventory.ini install_kubernetes.yml
```
Tasks:
- Installs Docker & kubeadm on all nodes
- Initializes Kubernetes on master
- Joins worker nodes
- Installs Calico networking
- Configures `kubectl`
- Installs NGINX Ingress Controller

#### **Stage 4 — Destroy Infrastructure (optional)**
If started with `DESTROY_INFRA = true`:
```bash
terraform destroy -auto-approve
```
- Destroys all AWS infra
- Skips app deployment trigger

#### **Stage 5 — Trigger App Deployment**
Only runs when `DESTROY_INFRA == false`:
```groovy
build job: 'app-deploy-aws', wait: false
```
Copies Terraform state and triggers app pipeline.

#### **Stage 6 — Post Actions**
- ✅ Success → "Pipeline completed successfully!"
- ❌ Failure → "Something went wrong — check logs."

---

## 🚀 2. App Deployment Pipeline — `app-deploy-aws`

### 🧱 Purpose
Deploys the **Flask app container** (from Docker Hub) into the Kubernetes cluster using **Ansible**.

---

### 🔢 Pipeline Stages

#### **Stage 1 — Checkout Code**
- Pulls the same GitHub repo for Ansible playbooks and manifests.

#### **Stage 2 — Generate Ansible Inventory**
- Copies Terraform state from infra workspace.
- Extracts public IPs using `terraform output`.
- Creates `inventory.ini` dynamically.

#### **Stage 3 — Run Ansible Deployment**
Executes:
```bash
ansible-playbook -i inventory.ini deploy_k8s_app.yml --extra-vars "image_name=angsdocker/web-app:latest namespace_name=app-v1"
```
Tasks:
1. Ensures namespace exists
2. Copies manifests to master node
3. Updates image dynamically
4. Applies Deployment, Service, and Ingress YAML
5. Waits for rollout completion
6. Ensures NGINX Ingress Controller is running
7. Waits for external IP/NodePort
8. Prints final access URL

#### **Stage 4 — Output Example**
```
🌐 Access your app at: http://52.211.73.43/ (Ingress Host: homelab)
✅ Flask app deployed successfully to Kubernetes!
```

---

## 🧩 Summary of Key Components

| Component | Description |
|------------|--------------|
| **Terraform** | Provisions AWS resources (VPC, EC2, networking, SGs) |
| **Ansible** | Configures Kubernetes, installs packages, deploys app |
| **Jenkins** | Automates orchestration and triggers pipelines |
| **Docker Hub** | Hosts Flask app image (`angsdocker/web-app:latest`) |
| **Kubernetes** | Runs and exposes the Flask app via Deployment + Ingress |

---

## 🧠 How to Use It

| Action | What to Do |
|--------|-------------|
| **Deploy full environment** | Run `infra-aws` with `DESTROY_INFRA = false` (triggers app pipeline). |
| **Tear everything down** | Run `infra-aws` with `DESTROY_INFRA = true`. |
| **Redeploy app only** | Run `app-deploy-aws` manually (infra already exists). |
| **Update app version** | Push new image to Docker Hub (e.g., `:v2`) and rerun app pipeline with new tag. |

---

## 🔍 Troubleshooting

| Problem | Likely Fix |
|----------|------------|
| Cannot access app | Ensure Ingress controller is deployed & configured |
| LoadBalancer `<pending>` | Use NodePort type instead |
| Ansible SSH errors | Verify EC2 key permissions and SSH connectivity |
| App not updating | Check image tag and manifest replacement step |

---

## ✅ Summary Flow Diagram
```
[Jenkins infra-aws]
   ├── Terraform apply → EC2s, VPC, SGs
   ├── Ansible configure → K8s setup
   ├── DESTROY_INFRA? ──┐
   │       Yes → Terraform destroy
   │       No  → Trigger app-deploy-aws
   ▼
[Jenkins app-deploy-aws]
   ├── Ansible deploy_k8s_app.yml
   ├── Apply manifests
   ├── Wait for rollout + ingress
   └── Output access URL
```