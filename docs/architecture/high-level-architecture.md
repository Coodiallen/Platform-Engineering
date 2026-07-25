# High-Level Architecture

## Overview

The Internal Developer Platform (IDP) is a self-service system that abstracts infrastructure complexity from developers. It provides a standardized application delivery pipeline from code commit to running workload in Kubernetes. The platform automates deployment, observability, and operations, allowing developers to focus on business logic instead of infrastructure.

The platform is built on open-source tools and runs locally on virtual machines for learning and experimentation. All components are defined as code and managed through GitOps principles.

---

## Architectural Goals

- **Self-Service** — Developers deploy applications without infrastructure team involvement through UI or CLI.
- **GitOps** — Git is the single source of truth. All changes flow through Git and are synchronized declaratively.
- **Reproducibility** — Every component is defined as code. The entire platform recreates from scratch with one command.
- **Observability** — All applications and platform components expose metrics, logs, and traces through unified dashboards.
- **Security by Default** — Secrets managed centrally. Access controlled through RBAC. Security built in, not added later.

---

## System Context

The platform consists of four logical layers that work together:

| Layer | Description |
|-------|-------------|
| **Developer** | Person who writes code and deploys applications through the platform |
| **Internal Developer Platform** | Self-service layer providing interfaces for source control, CI/CD, observability, and secrets |
| **Kubernetes Platform** | Container orchestration layer running application workloads |
| **Infrastructure** | Virtual machines providing compute, storage, and networking resources |

---

## Component Responsibilities

### Internal Developer Platform (User Layer)

Entry point for developers. Provides interfaces for source control, deployment, observability, and secrets.

| Component | Responsibility |
|-----------|----------------|
| **Gitea (Source Control)** | Hosts application code, infrastructure definitions, and GitOps configuration. Triggers CI on code changes |
| **Gitea Actions (CI)** | Builds Docker images from application code, runs tests, pushes images to Harbor, updates GitOps manifests |
| **ArgoCD (GitOps)** | Monitors Git repositories for changes. Synchronizes desired state to Kubernetes cluster |
| **Grafana + Loki + Prometheus** | Collects logs, metrics, and application traces. Provides dashboards and alerts |
| **Vault** | Stores and distributes secrets to applications. Developers request credentials through self-service |
| **Harbor** | Container registry storing Docker images with vulnerability scanning |

### Kubernetes Platform (Orchestration Layer)

Container orchestration platform that runs applications.

| Component | Responsibility |
|-----------|----------------|
| **Workloads** | Deployments, StatefulSets, Jobs running developer applications |
| **Ingress** | External access routing with TLS termination |
| **Metrics (Prometheus)** | Scrapes application and cluster metrics |

### Infrastructure (Hardware Layer)

Physical or virtual machines running the platform.

| Component | Responsibility |
|-----------|----------------|
| **Ubuntu VMs** | 3 nodes (1 master, 2 workers) providing compute resources |
| **VirtualBox** | Hypervisor running the VMs |
| **Vagrant** | VM provisioning and lifecycle management |
| **Ansible** | Configuration management and software installation |

---

## Data Flow

### End-to-End Application Deployment

1. **Developer pushes code** to Gitea repository
2. **Gitea Actions triggers CI pipeline:**
   - Validates code (linting, unit tests)
   - Builds Docker image
   - Pushes image to Harbor
   - Updates Kubernetes manifests with new image tag
   - Commits changes to GitOps repository
3. **ArgoCD detects changes** in GitOps repository
4. **ArgoCD syncs** the desired state to Kubernetes cluster
5. **Kubernetes schedules** new containers and replaces old ones (Rolling Update)
6. **Ingress routes** external traffic to the new application version
7. **Prometheus scrapes** application metrics
8. **Loki collects** application logs
9. **Developer checks** deployment status and logs through Grafana dashboards

---

## Component Interactions

Developer pushes code → Gitea
Gitea triggers → Gitea Actions (CI)
Gitea Actions builds image → Harbor
Gitea Actions updates manifests → GitOps Repository
ArgoCD watches → GitOps Repository
ArgoCD syncs → Kubernetes
Kubernetes exposes app → Ingress
Application logs → Loki → Grafana
Application metrics → Prometheus → Grafana
Developer views → Grafana Dashboards


---

## Future Extensions

Components planned for later stages of the project:

| Component | Purpose |
|-----------|---------|
| **Terraform** | Infrastructure provisioning beyond VMs. Manage namespaces, service accounts, network policies |
| **cert-manager** | Automatic TLS certificate issuance for Ingress endpoints |
| **Service Mesh** | Advanced traffic management, circuit breaking, mutual TLS |
| **Backstage** | Developer portal with service catalog, documentation, and self-service actions |
| **Crossplane** | Control plane for managing cloud resources through Kubernetes API |
| **AI Assistant** | Integrated assistant for troubleshooting and answering DevOps questions |
| **Velero** | Backup and restore for Kubernetes resources and persistent volumes |
| **ExternalDNS** | Automatic DNS record management for Ingress endpoints |
| **GitOps Multi-Environment** | Support for dev, staging, production through separate Git branches or directories |