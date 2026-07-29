# ☁️ Nimbus Shop — DevOps & Cloud Infrastructure Portfolio

**A production-grade DevOps case study: taking a MERN e-commerce app from raw code to a fully containerized, Kubernetes-orchestrated, CI/CD-automated, and real-time monitored system.**

![License MIT](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-in%20development-yellow)
![Infra](https://img.shields.io/badge/focus-DevOps%20%7C%20Kubernetes%20%7C%20CI%2FCD-blueviolet)

## 🎯 What I Built Here

This project is **not** about building an online store's features from scratch — it's about **engineering the infrastructure around one**. Here's what I designed and built myself in this repository:

- 📦 **Containerization** — wrote multi-stage `Dockerfile`s for frontend & backend to keep images small and efficient.
- ☸️ **Kubernetes Orchestration** — deployments, services, and Nginx Ingress Controller on a local cluster (Minikube), including manifest design.
- 🔁 **CI/CD Pipeline** — a GitHub Actions pipeline built from scratch: install → test → security scan (Trivy/Snyk) → build → push image.
- 📈 **Reliability Engineering** — rolling update configuration (zero downtime), liveness/readiness probes, and HPA for pod auto-scaling.
- 🌐 **Public Exposure Without a VPS** — set up Cloudflare Tunnel so the local cluster can be reached publicly, for free, with a zero-trust model.
- 📊 **Observability Stack** — installed and configured Prometheus + Grafana for metrics, plus a log store (Loki/ELK).

In short: anyone can clone the app itself — but **how it's brought to a stable, production-ready state** is what this repo is actually about.

---

## 🏗️ System Architecture

The diagram below shows the full flow — from a developer pushing code, to the app running on Kubernetes and being monitored in real time.

<img width="1182" height="1523" alt="621510825-bfbff3d7-aa4e-4fde-b613-d69adb802a7c" src="https://github.com/user-attachments/assets/70ef32e1-4208-4c90-b965-5ebfb6e27e64" />


### Flow Overview (top to bottom)

| Stage | Simple Explanation |
|---|---|
| **1. Developer → GitHub** | The developer writes code and pushes / opens a pull request to the GitHub repository. |
| **2. CI — GitHub Actions** | On every code change, the pipeline runs automatically: install dependencies → run tests (Jest/Mocha) → security scan (Trivy/Snyk) → build the Docker image. |
| **3. Image Registry** | The built Docker image is stored in Docker Hub / GitHub Container Registry (GHCR). |
| **4. CD — Kubernetes Cluster** | The image is pulled and run as a pod inside the Kubernetes cluster, then routed through the Nginx Ingress Controller. |
| **5. Frontend & Backend Pods** | Frontend (React/Next.js) and Backend (Node.js, multi-replica) run separately so each can be scaled independently. |
| **6. Redis & MongoDB Atlas** | Redis is used as a cache & session store, while the main data lives in MongoDB Atlas (cloud database). |
| **7. External Services** | Product image uploads use Cloudinary, and payments use Stripe. |
| **8. Cloudflare Tunnel** | Connects the cluster to the internet securely and **for free**, with no public server (VPS) or static IP needed. |
| **9. Reliability** | Rolling updates (zero-downtime deploys), automatic healthchecks (liveness/readiness), and HPA (auto-scaling pods based on traffic load). |
| **10. Monitoring & Logging** | Prometheus collects metrics, displayed on a Grafana dashboard, while application logs are stored in Loki/ELK. |

---

## 🧰 Tech Stack

**Application**
- React.js / Next.js (Frontend)
- Node.js + Express (Backend)
- MongoDB Atlas (Database)
- Redis (Cache & Session)

**Infrastructure & DevOps**
- Docker & Docker Compose
- Kubernetes (Minikube for local development)
- Nginx Ingress Controller
- GitHub Actions (CI/CD)
- Trivy / Snyk (Security Scanning)
- Cloudflare Tunnel (Public Exposure)

**Monitoring**
- Prometheus (Metrics)
- Grafana (Dashboard)
- Loki / ELK (Log Management)

**Third-Party Services**
- Cloudinary (Image hosting)
- Stripe (Payment gateway)

## 🚀 Running It Locally

### Prerequisites

Make sure you have these installed:

- [Node.js](https://nodejs.org/) (v18 or above)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (for local Kubernetes simulation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### 1. Clone the Repository

```bash
git clone https://github.com/alternatif-omg/nimbus-shop.git
cd nimbus-shop
```

### 2. Run with Docker

```bash
# Build & run all services (frontend, backend, etc.)
docker compose up --build
```

### 3. Run on Kubernetes (Minikube)

```bash
# Start the local cluster
minikube start

# Deploy Kubernetes resources
kubectl apply -f ./k8s/

# Check pod status
kubectl get pods
```



---

## 🔖 About the App & Credits

The application layer (UI, authentication, shopping cart, Stripe checkout, etc.) is built on top of the open-source **[mern-ecommerce](https://github.com/burakorkmez/mern-ecommerce)** project by [Burak Orkmez](https://github.com/burakorkmez), released under the MIT license. I did not rewrite the application logic — instead, I used it as a realistic deployment target to practice the full DevOps workflow above, which is far more representative than deploying a "Hello World" app.

If you're interested in the app's features themselves (rather than the infrastructure), check out the original repository.

---

## 📜 License

This project is licensed under **MIT**, following the license of the original base application — free to use, modify, and redistribute as long as attribution is preserved. See the [LICENSE](./LICENSE) file for details.

---

## 📬 Contact

Built by **Alfan Huda** as part of a DevOps & Cloud Engineering portfolio.

- GitHub: [@alternatif-omg](https://github.com/alternatif-omg)
