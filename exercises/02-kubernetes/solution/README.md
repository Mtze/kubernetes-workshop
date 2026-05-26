# Exercise 02 — Solution walkthrough

> Reference manifests for deploying the three Pedelec microservices, plus the reasoning behind each design choice.

## What's here

```
solution/
└── k8s/
    ├── deployments/
    │   ├── damage-deployment.yml
    │   ├── location-deployment.yml
    │   └── reservation-deployment.yml
    ├── services/
    │   ├── damage-service.yml
    │   ├── location-service.yml
    │   └── reservation-service.yml
    └── pedelec-ingress.yml
```

Apply with:

```bash
kubectl apply -R -f k8s/
```

## Design decisions

### One file per resource

We could have stuffed everything into a single `pedelec.yaml`. We didn't, because:

- `kubectl describe` errors point to a specific file when something fails.
- Diff reviews are easier — a one-line image-tag bump touches one file.
- Helm-ifying later (exercise 03) is a 1:1 translation: one template per file.

For larger systems, consider **Kustomize** or **Helm** rather than scaling up the file count.

### Container ports are *named*

```yaml
ports:
  - containerPort: 8082
    name: damage-api
```

The Service then targets that name:

```yaml
ports:
  - port: 80
    targetPort: damage-api
```

Naming the port means the Service contract is "talk to whatever port the container called `damage-api`". If you later change the Go service to listen on `:9000`, the Service still works — only the Deployment's `containerPort` changes.

### `imagePullPolicy: Always`

The images are tagged `:latest`, which is mutable. `Always` guarantees we pick up the newest published build on every Pod restart. In production you'd pin to an immutable tag (`@sha256:...` or a semver tag) and drop `imagePullPolicy` entirely.

### Resource requests and limits

```yaml
resources:
  requests:
    cpu: "50m"
    memory: "32Mi"
  limits:
    cpu: "500m"
    memory: "128Mi"
```

These tiny services don't need much. The **requests** matter for scheduling (the scheduler reserves this much capacity per pod). The **limits** matter for protection (a runaway pod can't eat the whole node).

If you ever see pods getting `OOMKilled`, the limit is too low. If a node is over-committed, the requests are wrong.

### Service `port: 80`, container `targetPort: <port-name>`

Every Service exposes port 80 inside the cluster, regardless of what the container speaks underneath. This is convention — clients in the cluster always say `service-name:80`, and the Service handles the translation. Less mental overhead than remembering which service is on 8080 vs 8081 vs 8082.

### Ingress paths use `pathType: Prefix`

`Prefix` is forgiving — `/pedelec` matches `/pedelec`, `/pedelec/123`, `/pedelec?foo=bar`. The alternative `Exact` only matches the literal string and almost never does what you want for REST APIs.

### No `imagePullSecrets`

The Pedelec images are public on GHCR, so no pull secret is needed. This intentionally removes one of the most common workshop failure modes. If you forked and made your packages private, you'd need to:

```bash
kubectl create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username=<your-gh-user> \
  --docker-password=<a-PAT-with-read:packages>
```

…then add `imagePullSecrets: [{name: ghcr-creds}]` to each Pod spec. The cleaner answer is to keep the packages public.

### No `Namespace` resource in the YAML

The manifests don't declare a namespace. That's deliberate — you `kubectl apply -n <your-namespace>` (or set it as your default with `kubectl config set-context --current --namespace=<your-namespace>`), and the same manifests work in everybody's namespace. If we'd hardcoded `namespace: pedelec`, every participant would need to edit every file.

## Verifying

```bash
# Everything green?
kubectl get all
kubectl get ingress

# Pod logs say "Starting <service> service" for each?
for svc in damage location reservation; do
  echo "--- $svc ---"
  kubectl logs deploy/$svc
done

# End-to-end smoke test
HOST=<your-ingress-host>
curl -s https://$HOST/pedelec | jq
```

## Cleanup

```bash
../../../scripts/reset-namespace.sh
```

…or by hand:

```bash
kubectl delete -R -f k8s/
```
