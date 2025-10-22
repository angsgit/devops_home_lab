# 🚀 DevOps Home Lab — CI/CD, Kubernetes & Monitoring

## 📘 Overview
This project demonstrates a complete DevOps CI/CD pipeline using a simple Flask-based web application deployed on a Kubernetes cluster.
It covers source control, build automation, containerization, orchestration, monitoring, and observability - all running locally in a fully functional home lab environment.
The setup also emphasizes high availability (HA), disaster recovery (DR), and service reliability, reflecting real-world enterprise DevOps and SRE practices.

---

## 🧩 Project Architecture

## 🧰 Tech Stack & Tools Used

| Category | Tool | Purpose |
|-----------|------|----------|
| **Source Control** | [GitHub] (https://github.com) | Hosts application and IaC repositories |
| **CI/CD Automation** | [Jenkins] (https://www.jenkins.io) | Automates build, test, and deploy pipeline |
| **Containerization** | [Docker] (https://www.docker.com) | Packages the Flask app and dependencies |
| **Orchestration** | [Kubernetes] (https://kubernetes.io) | Deploys and manages application containers |
| **Configuration Management** | [Ansible] (https://www.ansible.com) | Automates environment setup across VMs |
| **Infrastructure as Code (IaC)** | [Terraform] (https://www.terraform.io) |  Automates VM and cluster provisioning |
| **Code Quality & Scanning** | [SonarQube] (https://www.sonarqube.org) | Static code analysis integrated into CI |
| **Artifact Registry** | [DockerHub] (https://hub.docker.com) | Stores and versions container images |
| **Monitoring & Metrics** | [Prometheus] (https://prometheus.io) | Collects metrics from Kubernetes and applications |
| **Visualization & Dashboards** | [Grafana] (https://grafana.com) | Visualizes performance and reliability metrics |
| **Reverse Proxy & Load Balancing** | [NGINX] (https://www.nginx.com) | Provides ingress and routing for web traffic |
| **Programming Language** | [Python] (https://flask.palletsprojects.com) | Simple web app used for demonstration |


---

## 🏗️ Phase 1 — Flask App Setup

- Built a simple Python Flask application with `/` and `/metrics` endpoints.
- Added a `requirements.txt` file for dependencies.
- Verified the app runs locally using:
  ```bash
  python main.py
  ```
- Confirmed `/metrics` exposes Prometheus-style metrics for monitoring.

---

## 🐳 Phase 2 — Dockerization

- Created a `Dockerfile`:
  ```dockerfile
  FROM python:3.10-slim
  WORKDIR /app
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt
  COPY . .
  EXPOSE 8000
  CMD ["python", "main.py"]
  ```

- Built and tested the container:
  ```bash
  docker build -t flask-app .
  docker run -p 8000:8000 flask-app
  ```

---

## ☸️ Phase 3 — Kubernetes Deployment

- Deployed the Flask app to Kubernetes with a **Deployment**, **Service**, and **Ingress**.
- Example manifest (`webappv1.yaml`):
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: webapp
    namespace: app-v1
  spec:
    replicas: 4
    selector:
      matchLabels:
        app: webapp
    template:
      metadata:
        labels:
          app: webapp
      spec:
        containers:
          - name: webapp
            image: docker.io/angsdocker/web-app:v1
            ports:
              - containerPort: 8000
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: webapp
    namespace: app-v1
  spec:
    selector:
      app: webapp
    ports:
      - port: 80
        targetPort: 8000
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: webapp
    namespace: app-v1
    annotations:
      kubernetes.io/ingress.class: nginx
  spec:
    rules:
      - host: web.lab.local
        http:
          paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: webapp
                  port:
                    number: 80
  ```

- Verified the app via `http://web.lab.local`.

---

## 🔁 Phase 4 — CI/CD with Jenkins

- Configured **Jenkins** with:
  - Git plugin
  - Docker plugin
  - Kubernetes CLI
  - Credentials for Docker Hub and kubeconfig
- Jenkins automatically:
  1. Pulls code from GitHub on push  
  2. Builds the Docker image  
  3. Pushes it to Docker Hub  
  4. Updates the Kubernetes deployment with the new image tag  
  5. Rolls out the new version automatically

**Jenkinsfile:**
```groovy
pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-file')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/angsgit/devops_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t angsdocker/web-app:${BUILD_NUMBER} .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push angsdocker/web-app:${BUILD_NUMBER}
                    docker tag angsdocker/web-app:${BUILD_NUMBER} angsdocker/web-app:latest
                    docker push angsdocker/web-app:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    sed -i s#image:.*#image: angsdocker/web-app:${BUILD_NUMBER}#g webappv1.yaml
                    kubectl apply -f webappv1.yaml -n app-v1
                    kubectl rollout status deployment/webapp -n app-v1
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
```

---

## 📊 Phase 5 — Monitoring & Observability

- Installed **Helm**:
  ```bash
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  ```
- Added the Prometheus community repo and installed the monitoring stack:
  ```bash
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  kubectl create namespace monitoring
  helm install kube-prometheus prometheus-community/kube-prometheus-stack -n monitoring
  ```
- Exposed Grafana to the host:
  ```bash
  kubectl -n monitoring patch svc kube-prometheus-grafana -p '{"spec": {"type": "NodePort"}}'
  kubectl -n monitoring get svc kube-prometheus-grafana
  ```
  → Accessed Grafana via `http://<master-node-ip>:<nodeport>`

- Default login:
  ```
  Username: admin
  Password: (get using `kubectl get secret ... | base64 -d`)
  ```

- Verified dashboards: Kubernetes cluster, node, and pod metrics working correctly.

---

## 🧠 Key Learnings

- Full DevOps pipeline integration from code to Kubernetes
- Automating deployments using Jenkins and Git webhooks
- Managing manifests and namespaces in Kubernetes
- Deploying Helm charts for Prometheus & Grafana
- Observability and metrics visualization
- Understanding node taints, resource requests, and pod scheduling

---

## 🗺️ Next Steps (Planned)

- Add custom Grafana dashboards for Flask app metrics  
- Integrate Alertmanager notifications (Slack or email)  
- Manage infrastructure with Terraform (IaC)  
- Deploy to a cloud-managed Kubernetes cluster (EKS / AKS)

---

## 📂 Repository Structure

```
.
project/
|
|
├── README.md                      # Full project documentation and setup guide
├── .gitignore                     # Ignore unnecessary files (logs, creds, etc.)
│
|
├── app/                           # Flask application source code
│   ├── main.py                    # Flask entry point
│   ├── requirements.txt           # Python dependencies
│   ├── Dockerfile                 # Container build instructions
│ 
│
├── jenkins/                       # Jenkins CI/CD pipeline configuration
│   ├── Jenkinsfile                # Pipeline for build → push → deploy to K8s
│   
│  
├── k8s/                           # Kubernetes manifests and Helm resources
│   ├── webappv1.yaml              # Deployment, Service, and Ingress for the Flask app
│   ├── namespace.yaml             # Custom namespace definition (e.g., app-v1)
│   ├── helm/                      # Helm charts for monitoring stack
│   │   └── 
│ 
│
├── monitoring/                    # Monitoring stack (Helm-based)
│   ├── prometheus/                # Prometheus custom configs
│   │   └── .gitkeep
│   ├── grafana/                   # Grafana dashboards and custom configs
│   │   ├── dashboards/
│   │   │   ├── 
│   │   │   └── 
│   │
│
|
├── terraform/                     # Infrastructure as Code (IaC)
│   ├──                     
|
|
├── ansible/                       # Config Automation
│   ├── playbooks/
│   │   ├── 
│   │   └──
│   └── 
│
|
└── docs/                          # Documentation and screenshots
    ├── architecture_diagram.png   # Overview of Jenkins → DockerHub → K8s pipeline
    ├── screenshots/               # Grafana, Jenkins UI, Flask App
    │   ├── 
    │   ├── 
    │   ├── 
    │   └── 
    └── 

```

---

## 🔒 Security

All sensitive credentials and configuration files (e.g., Docker Hub tokens, kubeconfig, Grafana admin passwords) are **not stored in this repository**.  
They are securely managed using **Jenkins Credentials**, **Kubernetes Secrets**, or **local environment variables**.

This project follows **DevSecOps best practices**, ensuring:
- No hardcoded passwords, API keys, or tokens are present in source control.
- Jenkins pipelines use credential IDs only (not plaintext secrets).
- Sensitive cluster configurations (like kubeconfig) remain private and stored securely on the control node.
- Public documentation and manifests contain only non-sensitive example values.

---


---

## 👤 Author
**Angad**  
DevOps & Cybersecurity Engineer  
[GitHub: angsgit](https://github.com/angsgit)
