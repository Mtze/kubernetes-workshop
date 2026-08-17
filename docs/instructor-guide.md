# Instructor guide

How to provision the infrastructure and run this workshop yourself. The
student-facing setup lives in [`prerequisites.md`](prerequisites.md) and
[`cluster-access.md`](cluster-access.md); this guide is for the person running
the session.

Everything the students touch is standard Kubernetes, so any conformant cluster
works. The reference setup below uses [Rancher](https://www.rancher.com/) as the
management UI (what the TUM delivery uses), but nothing in the deck or exercises
depends on it.

## 1. What you need to provide

| Thing | Why |
|---|---|
| A Kubernetes cluster (v1.28+) | Students deploy to it. |
| An ingress controller (nginx) | The Ingress exercise needs one. |
| A wildcard DNS record + base domain | So `<student>.<base>` resolves to their app. |
| One namespace per student, write-scoped | Each student works in an isolated sandbox. |
| A kubeconfig per student | How they authenticate. |
| The Pedelec images, reachable from the cluster | Public GHCR by default; private registry optional. |

Map these to the deck: set `cluster_url`, `account_wording`, `ingress_base`,
`namespace_convention`, `image_registry`, and `image_owner` in
[`../slides/config.typ`](../slides/config.typ) so the slides match your cluster.

## 2. Namespaces, access, and RBAC

The goal is that each student can create/read/update/delete resources **only in
their own namespace**.

- Create one namespace per student ahead of time (e.g. named after their
  account/username), matching `namespace_convention`.
- Bind a `Role` allowing the core objects the workshop uses (Pods, Deployments,
  Services, Ingresses, and their `get/list/watch/create/update/delete`) via a
  `RoleBinding` per student, scoped to their namespace.
- Issue each student a kubeconfig whose default namespace is theirs, so
  `kubectl apply` lands in the right place without `-n`.
- With Rancher: create a Project for the workshop, add each student's namespace
  to it, and grant each user the namespace-scoped role from the Rancher UI;
  students download their kubeconfig from Rancher.

Optionally apply a `ResourceQuota`/`LimitRange` per namespace so a runaway
Deployment cannot exhaust the cluster.

## 3. Ingress controller, DNS, and TLS

- Install the nginx ingress controller (Helm chart `ingress-nginx`, or your
  platform's managed option).
- Point a **wildcard DNS record** `*.<ingress_base>` at the ingress controller's
  external IP/LoadBalancer, so every student host resolves.
- For HTTPS, run cert-manager with a Let's Encrypt issuer and a wildcard (DNS-01)
  or per-host (HTTP-01) certificate. If you skip TLS, drop the TLS block from the
  ingress and serve over HTTP.

Verify: `curl http://<anything>.<ingress_base>` reaches the ingress controller
(a 404 from nginx is fine - it means routing works).

## 4. Container images

The three Pedelec services are published to GitHub Container Registry by
[`.github/workflows/build-and-publish.yml`](../.github/workflows/build-and-publish.yml).

- **Public path (default):** fork this repo, let the workflow run, and make the
  three `pedelec-*` GHCR packages public (see the repo README's "For forkers").
  The manifests and Helm chart then pull without any credentials. Set
  `image_owner` to your GitHub user/org.
- **Private registry (optional):** if you must keep images private, enable the
  deck's registry appendix (`show_registry_appendix: true`) and create an
  `imagePullSecret` per namespace. See the appendix slides for the exact commands.

## 5. Pre-session checklist

- [ ] Cluster reachable; ingress controller running.
- [ ] Wildcard DNS resolves; TLS issuer working (or HTTP fallback documented).
- [ ] One write-scoped namespace + kubeconfig per registered student.
- [ ] Pedelec images pullable from the cluster.
- [ ] `slides/config.typ` values match the cluster; deck rebuilt.
- [ ] Students sent `prerequisites.md` and their kubeconfig ahead of time.
- [ ] `./scripts/verify-prereqs.sh` passes on a fresh machine.
