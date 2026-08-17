#import "../lib.typ": *

= Welcome

== Today's goal

By the end of this session you can take a multi-service application from
`docker compose` on your laptop to a Helm-managed deployment on a real
Kubernetes cluster, and read, write, and debug the manifests in between.

This is a *baseline*: enough to keep exploring on your own, not all of Kubernetes.

== Agenda

#grid(columns: (1fr, 1fr), gutter: 1.5em,
  [
    *Block 1: Docker Compose*
    - Services, ports, environment, networks
    - Run the Pedelec system locally
    - Scaling and load balancing
  ],
  [
    *Block 2: Kubernetes core*
    - The reconciliation model, `kubectl`
    - Namespaces, Pods, Deployments
    - Services, Ingress and path routing
  ],
)

#v(1em)
*Block 3: Helm* - package the whole application as a reusable chart.

== Learning goals

+ Understand the key features of Docker Compose.
+ Create and use custom Docker Compose setups.
+ Understand the core Kubernetes objects: Namespaces, Pods, Deployments, Services, Ingress.
+ Use `kubectl` and Helm to interact with a cluster.

== Prerequisites

Install before the session (see `docs/prerequisites.md`):
- Docker, `kubectl`, and Helm
- Optionally Bruno (HTTP client) for the API exercises
- Access to a cluster: #cfg.cluster_platform at #strong(cfg.cluster_url), or any local cluster (kind, minikube, k3d)

Then run `./scripts/verify-prereqs.sh`.

== The running example: Pedelec

// TODO(transcribe): align wording with the deck's Pedelec intro.
A small e-bike sharing system built from three stateless Go services:
- *reservation* - pedelecs and reservations (`:8080`)
- *location* - GPS coordinates per pedelec (`:8081`)
- *damage* - damage reports (`:8082`)

One example carries us the whole way: Compose, then Kubernetes, then Helm.
