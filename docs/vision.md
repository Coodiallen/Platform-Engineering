# Vision

## Problem Statement

Modern development teams spend too much time on infrastructure-related tasks. Deployments typically require 3–5 manual steps, take over 30 minutes, and often involve waiting for infrastructure engineers. Each team follows its own deployment process, leading to inconsistencies, repetitive work, and human error.

Developers depend on infrastructure engineers for routine tasks, slowing down delivery. The lack of standardized workflows makes onboarding difficult and reduces platform reliability.

Our goal is to eliminate these inefficiencies by providing a unified Internal Developer Platform that enables developers to deliver applications quickly, safely, and consistently.

---

## Target Users

The primary users are software developers who want to focus on writing code instead of managing infrastructure.

The platform also serves:

* **Team Leads**, who need visibility into application health and deployment status.
* **QA Engineers**, who require isolated and reproducible testing environments.
* **Platform Engineers**, who abstract infrastructure complexity so developers don't need to understand Kubernetes.

---

## Goals

The platform aims to:

* Provide developers with a self-service interface for application deployment.
* Automate the complete delivery lifecycle: build, test, deploy, and rollback.
* Reduce lead time from code commit to running workload.
* Establish consistent operational standards across all applications.
* Ensure automatic rollback on deployment failures.
* Provide unified access to logs, metrics, and deployment status.

---

## Non Goals

The platform is **not** intended to:

* Build or maintain application business logic.
* Replace IDEs or development tools.
* Manage stateful workloads like databases or message queues — that's the application team's responsibility.
* Perform low-level OS or kernel tuning.

---

## Success Criteria

The platform will be considered successful when:

* Developers can deploy applications without manual infrastructure intervention.
* All applications use the same deployment pipeline template.
* No manual kubectl commands are required for standard application deployment.
* Failed deployments automatically rollback.
* Logs and metrics are accessible through a unified interface.
* A new developer can deploy their first application within one working day.