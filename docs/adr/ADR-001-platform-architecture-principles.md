# ADR-001: Platform Architecture Principles

## Status
Accepted

## Context

Traditional infrastructure management relies on manual operations: SSH to servers, run commands, edit configs. This approach works for small projects but fails when multiple developers need to deploy applications independently. Manual operations are error-prone, unreproducible, and create dependencies on specific engineers.

We are building a platform where multiple developers will deploy their applications. We need a system that is:
- Reproducible
- Self-service
- Documented by design

This ADR defines the principles that guide all technical decisions in this project.

---

## Decision

### 1. Internal Developer Platform

**Decision:** Build a platform that abstracts infrastructure complexity from developers.

**Alternatives considered:**
- Traditional infrastructure team — developers submit tickets for deployments
- Developers manage their own Kubernetes clusters
- Shared staging environment with manual deployments

**Why we chose IDP:**
- Developers focus on code, not infrastructure
- Reduces onboarding time for new developers
- Standardizes deployment workflows across teams
- Platform team handles complexity once, benefits all teams

---

### 2. GitOps

**Decision:** Git is the single source of truth for both infrastructure and application configuration. Changes are applied through declarative synchronization instead of manual operations.

**Alternatives considered:**
- Push-based CI/CD (Jenkins triggers kubectl apply)
- Manual deployment scripts (bash scripts executed by developers)
- Direct kubectl commands by operators

**Why we chose GitOps:**
- Git provides audit trail, rollback capability, and change history
- ArgoCD ensures cluster state matches repository
- Declarative approach eliminates configuration drift
- All changes are reviewable through pull requests
- No manual access to production cluster required

---

### 3. Infrastructure as Code (IaC)

**Decision:** All infrastructure components must be declaratively defined as code and stored in version control.

**Alternatives considered:**
- Manual configuration via SSH
- Click-ops through web interfaces (cloud consoles)
- Configuration documented in wikis or spreadsheets
- Interactive setup scripts with manual inputs

**Why we chose IaC:**
- Infrastructure is reproducible — no hidden manual changes
- Versioned — full history of changes
- Reviewable — changes go through pull requests
- Automatable — CI can validate and apply changes
- Documentation by design — code describes the system

---

### 4. Self-Service

**Decision:** Developers can deploy and manage their applications without infrastructure team involvement.

**Alternatives considered:**
- Ticket system for deployment requests
- Manual approvals for each deployment
- Dedicated DevOps engineer for each team

**Why we chose Self-Service:**
- Removes bottlenecks — developers deploy when ready
- Accelerates delivery — no waiting for infrastructure team
- Scales to many teams without adding infrastructure staff
- Empowers developers — they own their deployments
- Platform team focuses on building tools, not doing manual work

---

### 5. Local-first Learning

**Decision:** The platform runs on local virtual machines (Vagrant + VirtualBox) instead of public cloud during development and learning.

**Alternatives considered:**
- Public cloud (AWS, GCP, Azure)
- Bare metal servers
- Docker Compose on a single host

**Why we chose Local-first:**
- Zero cost — no cloud expenses or free tier limits
- Full control — no external dependencies or API throttling
- Safe experimentation — mistakes don't cost money or expose data
- Works offline — no internet required after initial setup
- Skills transfer directly to cloud environments — same tools, different providers

---

## Principle Interactions

These principles are not independent — they reinforce each other:

- **GitOps requires IaC** — to use Git as the source of truth, all configuration must be declarative code
- **Self-service requires GitOps** — developers submit changes via Git, automation applies them without human intervention
- **Local-first enables Self-service** — developers can spin up the entire platform locally for testing
- **IaC enables Local-first** — the same code works on local VMs and cloud environments (modulo providers)
- **IDP requires all four** — a platform that hides complexity is built on automation, code, and self-service

This creates a coherent system where each principle supports the others and no principle works in isolation.

---

## Consequences

### Benefits

- Full control over the environment
- Safe experimentation without cost risk
- Fully reproducible infrastructure
- Documented architectural decisions
- Skills transferable to production environments
- No vendor lock-in during learning phase
- Standardized workflows across all teams

### Trade-offs

- Limited local compute resources (RAM, CPU)
- No direct experience with cloud-managed services (RDS, EKS, etc.)
- Higher initial effort for documentation and automation
- Requires more upfront planning than manual approach
- Some services have no local equivalent

### Implementation Requirements

To comply with these principles, the project must include:

- Git repository containing all configuration (IaC, manifests, apps)
- CI/CD pipeline triggered by Git events
- Automated validation of all changes (CI checks)
- Monitoring and observability for all platform components
- Self-service interface (UI or CLI) for developers
- All infrastructure defined in code (Vagrantfile, Ansible, Terraform, K8s manifests)

---

## Risks

- **Limited resources:** Local VMs have limited RAM and CPU. Heavy workloads (e.g., multiple microservices) may not run. Mitigation: optimize configurations, use minimal resource requests.
- **GitOps discipline:** Developers must commit all changes to Git. Bypassing Git (e.g., kubectl edit) breaks the model. Mitigation: restrict cluster access, enforce Git-only changes.
- **Self-service abuse:** Without quotas and limits, developers might consume all cluster resources. Mitigation: enforce ResourceQuotas and LimitRanges.
- **Local-cloud mismatch:** Some cloud services have no local equivalent (e.g., managed databases, load balancers). Mitigation: use open-source alternatives (Postgres on VMs, MetalLB).
- **Tool complexity:** Managing many tools (Vagrant, Ansible, Terraform, ArgoCD, etc.) increases complexity. Mitigation: document setup, create helper scripts.
- **Learning overload:** Too many new technologies at once can overwhelm. Mitigation: introduce technologies one at a time, with clear problem statements.

---

## Related

- `docs/vision.md` — product vision and goals
- `docs/high-level-architecture.md` — component diagram
- Future ADRs will reference this document as the foundation