#import "../lib.typ": *

= Welcome

== Kubernetes (K8s) Basics

*What you will build*

In this workshop, you will start by working with Docker Compose to manage
multi-container setups, then deploy and explore the Pedelec server-side system.
You will learn to write Kubernetes manifests, interact with clusters using
#cfg.cluster_platform and kubectl, and create Deployments, Services, and
Ingresses. By the end, you will have deployed a microservice architecture to the
cloud and gained hands-on experience with scalable, containerized application
management.

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    *Prerequisites*
    - Containers
    - Images
    - Docker
    - UML
    - CLI
  ],
  [
    *Key Vocabulary*
    - Compose File
    - Kubernetes
    - kubectl
    - Manifest
    - Deployment
    - Service
    - Ingress
    - Helm
  ],
)

== Who are we?

- #strong(cfg.presenter)
- Doctoral Student at #cfg.institution
- Educator at heart
- Software and Infrastructure Architect
- Research Areas
  - Container-based Software Engineering
  - Infrastructure Orchestration
  - Scaling Education Technology

== Pre Survey

*I need your help!*

// Survey link (QR code + URL) intentionally omitted.

== Learning Goals

*Context and assumptions*
- You understand the basics of Docker
- You understand the ISO/OSI Model
- You know how to use the CLI

*At the end of this session you are able to*
- Understand the key features of docker compose
- Create and use custom docker compose setups
- Understand the basic concepts of Kubernetes
- Use kubectl and helm to interact with Kubernetes
