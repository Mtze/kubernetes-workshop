# Kubernetes Workshop — Pedelec Microservices

A hands-on workshop that takes three Go microservices from `docker compose` on your laptop to a Helm-managed deployment on a real Kubernetes cluster.

The running example is the **Pedelec** app — a tiny system for managing e-bike reservations, locations, and damage reports.

## At a glance

| Exercise | What you build | Folder |
|---|---|---|
| 01 | Run three microservices locally with Docker Compose | [`exercises/01-microservices/`](exercises/01-microservices/) |
| 02 | Deploy those services to Kubernetes with hand-written Deployment / Service / Ingress YAML | [`exercises/02-kubernetes/`](exercises/02-kubernetes/) |
| 03 | Convert the raw manifests into a reusable Helm chart | [`exercises/03-helm/`](exercises/03-helm/) |

Each exercise has a `start/` folder (the canvas) and a `solution/` folder (reference + walkthrough). Peek at the solution when stuck, or compare after.

## Prerequisites

- Docker
- kubectl
- Helm
- (Optional) [Bruno](https://www.usebruno.com/) for replaying API requests
- Access to a Kubernetes cluster — TUM ASE CIT cluster or any local cluster (kind, minikube, k3d, Docker Desktop)

Check your setup:

```bash
./scripts/verify-prereqs.sh
```

More detail: [`docs/prerequisites.md`](docs/prerequisites.md) and [`docs/cluster-access.md`](docs/cluster-access.md).

## Repo map

```
kubernetes-workshop/
├── README.md                          # you are here
├── LICENSE                            # CC BY 4.0
├── .github/workflows/
│   ├── build-and-publish.yml          # builds & publishes the 3 services to GHCR
│   └── lint.yml                       # yamllint + helm lint + kubeconform
├── docs/
│   ├── prerequisites.md
│   ├── cluster-access.md
│   ├── architecture.md                # request flow + mermaid diagram
│   └── glossary.md
├── exercises/
│   ├── 01-microservices/              # Go services + Docker Compose
│   ├── 02-kubernetes/{start,solution} # raw K8s manifests
│   └── 03-helm/{start,solution}       # Helm chart
└── scripts/
    ├── verify-prereqs.sh
    └── reset-namespace.sh
```

## Container images

The three services are published as public images on GitHub Container Registry by the build workflow:

```
ghcr.io/mtze/pedelec-damage:latest
ghcr.io/mtze/pedelec-location:latest
ghcr.io/mtze/pedelec-reservation:latest
```

Every K8s manifest and Helm value in this repo points at these by default, so you can `kubectl apply` and `helm install` without building anything yourself.

## For forkers

The build workflow is designed to work on any fork without modification — it derives the image namespace from `${{ github.repository_owner }}` and authenticates with the built-in `GITHUB_TOKEN`. No PAT, no secrets, no editing required.

**One manual step after the first workflow run on your fork:** GHCR packages created by `GITHUB_TOKEN` start *private*. Visit `https://github.com/<your-user>?tab=packages`, open each `pedelec-*` package, and set its visibility to *public* (Package settings → Change visibility). After that, the K8s manifests still work — but you'll want to retarget them at your own images:

```bash
# In exercise 02 solution:
sed -i 's|ghcr.io/mtze|ghcr.io/<your-gh-user>|g' \
  exercises/02-kubernetes/solution/k8s/deployments/*.yml

# In exercise 03 (Helm), just override the value:
helm install pedelec ./exercises/03-helm/solution/helm/pedelec \
  --set image.owner=<your-gh-user>
```

## License

CC BY 4.0 — see [`LICENSE`](LICENSE).

This material is free for educators to use and adapt, including for commercial training, as long as attribution is given.

## Acknowledgements

The Pedelec example services were originally built for the iOS Praktikum at TUM. This workshop repo extracts and reorganizes the server-side microservices + Kubernetes pieces for use as a standalone Kubernetes teaching aid.
