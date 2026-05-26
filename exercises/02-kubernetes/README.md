# Exercise 02 — Deploying to Kubernetes

> Write the Deployment, Service, and Ingress manifests that put the three Pedelec microservices onto a Kubernetes cluster.

This exercise has two folders:

- [`start/`](start/README.md) — the empty canvas. Same compose stack as exercise 01, but no Kubernetes manifests. **You'll write them.**
- [`solution/`](solution/README.md) — a reference set of manifests with a walkthrough of why they look the way they do. Peek when you're stuck, or compare after you're done.

## Learning goals

By the end of this exercise you'll be able to:

- Write a Deployment that runs a single-container service.
- Write a Service that fronts a Deployment with a stable in-cluster DNS name.
- Write an Ingress that fans out HTTP paths to multiple Services.
- Apply, inspect, debug, and delete K8s resources with `kubectl`.

## Prerequisites

- Exercise 01 completed (or at least skimmed)
- Cluster access set up — see [`docs/cluster-access.md`](../../docs/cluster-access.md)
- The Pedelec container images are already published at `ghcr.io/mtze/pedelec-<service>:latest` — no build needed for this exercise unless you forked

## Where to start

```bash
cd exercises/02-kubernetes/start
cat README.md   # task list, hints, expected commands
```

When you're done, compare with `../solution/` and read the walkthrough in [`solution/README.md`](solution/README.md).
