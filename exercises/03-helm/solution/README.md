# Exercise 03 — Solution walkthrough

> Finished Helm chart for the three Pedelec microservices, plus the reasoning behind each templating decision.

## What's here

```
solution/
└── helm/pedelec/
    ├── Chart.yaml
    ├── values.yaml
    ├── .helmignore
    └── templates/
        ├── _helpers.tpl
        ├── damage-deployment.yml
        ├── location-deployment.yml
        ├── reservation-deployment.yml
        ├── damage-service.yml
        ├── location-service.yml
        ├── reservation-service.yml
        └── pedelec-ingress.yml
```

## Install

```bash
helm install pedelec ./helm/pedelec \
  --namespace <your-namespace> \
  --set image.owner=mtze \
  --set ingress.host=<your-host>
```

Render-only (no cluster contact):

```bash
helm template pedelec ./helm/pedelec --debug
```

## Design decisions

### Two helpers, no more

This chart only defines `pedelec.labels` and `pedelec.image`. Helm starter charts ship with seven or eight helpers — most are noise for a chart this size. Add helpers when you find yourself copy-pasting; don't anticipate.

### `pedelec.image` takes a dict, not a service name

```gotemplate
{{- define "pedelec.image" -}}
{{ .registry }}/{{ .owner }}/pedelec-{{ .service }}:{{ .tag }}
{{- end }}
```

We pass each piece explicitly:

```yaml
image: {{ include "pedelec.image" (dict "registry" .Values.image.registry "owner" .Values.image.owner "tag" .Values.image.tag "service" "damage") }}
```

The verbose call-site is a deliberate trade-off — the helper stays simple (no `.Values` lookups, no surprises), and the relationship between values and rendered output is obvious from one file.

### Common labels go everywhere

Every Deployment, Service, and Ingress gets:

```yaml
labels:
  {{- include "pedelec.labels" . | nindent 4 }}
  app: <service>
```

The `pedelec.labels` block emits the standard `app.kubernetes.io/*` set, then we add a per-resource `app:` for the Service selector.

### Ingress is conditional

```gotemplate
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
...
{{- end }}
```

You can install on a cluster without an ingress controller (CI, kind without ingress-nginx) with `--set ingress.enabled=false`.

### Resources are lifted, not hardcoded

```yaml
resources:
  {{- toYaml .Values.resources | nindent 12 }}
```

`toYaml` lets the consumer pass an arbitrary structure under `resources` without us anticipating every key. If they want to add `ephemeral-storage` limits later, they can — no template change.

### Why each service is its own template file

We could have written a single `templates/services.yaml` with three documents separated by `---`. We didn't, because:

- `helm template` errors point to a specific file.
- Adding a fourth service means adding a file, not editing an existing one (less merge conflict risk in a teaching setting).
- 1:1 mapping from exercise 02 manifests → exercise 03 templates makes the templatization step itself the teaching moment.

For a real production chart with many services, a single template that loops over `range .Values.services` is the right move. We avoid it here because the loop hides what `helm template` is actually doing.

## Verifying

```bash
helm lint ./helm/pedelec
helm template pedelec ./helm/pedelec --set image.owner=mtze --set ingress.host=test.example.com | less
```

After installing:

```bash
helm status pedelec -n <your-namespace>
kubectl get all -n <your-namespace>
```

## Cleanup

```bash
helm uninstall pedelec -n <your-namespace>
```

…or `../../../scripts/reset-namespace.sh`.
