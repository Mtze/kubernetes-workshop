#import "../lib.typ": *

= Block 3: Helm

== Break

// TODO(image): illustration of a person taking a short break at a desk.
#align(center)[_Short break - back in a few minutes._]

== What is a Helm Chart

Helm Charts help you define, install, and upgrade even the most complex
Kubernetes application.
Charts are easy to create, version, share, and publish - so start using Helm and
stop the copy-and-paste.

#emph[Remember the hassle changing the namespace?]

- Three+ Concepts
  - The *chart* is a bundle of information necessary to create an instance of a
    Kubernetes application.
  - The *values* contains configuration information that can be merged into a
    packaged chart to create a releasable object.
  - A *release* is a running instance of a chart, combined with a specific config.

== Helm Motivation

- *Reusable & Shareable:* Charts help version, reuse, and distribute your
  deployments \
  #sym.arrow One chart can deploy to dev, staging, and production with different values
- *Multi-Environment Support:* Easily manage Test, Staging, and Production via
  separate values.yaml files
- *Cloud Portability:* Abstract infrastructure specific configuration - move from
  GCP to AWS with minimal changes
- *Simple Installation:* Install off-the-shelf apps (e.g., Kafka, Grafana,
  NextCloud) with one command

== What is an Helm Chart?

```text
~/workshop/helm> tree
my-chart/
├── Chart.yaml         # Metadata (name, version, description)
├── values.yaml        # Default configuration values
├── templates/         # Templated Kubernetes Manifests / YAML files
└── charts/            # Optional dependencies
```

- Parameterized Kubernetes Manifests
- Filled with values on install / upgrade
- Optional Helper functions

== The Helm value concept

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
```yaml
# values.yml
---
replicaCount: 2

image:
  repository: myregistry/pedelec
  tags: v1.2.0
```
  ],
  [
```yaml
# Deployment Template
---
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: {{ .Values.replicaCount }}
  template:
    spec:
      containers:
      - name: app1-container
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```
  ],
)

#emph[These Values are placed in on install.]
#emph[Notice - we no longer specify the namespace.]

== Helm Getting Started

- Create a chart skeleton

```bash
helm create pedelec
```

- Install a chart (release)

```bash
helm -n <namespace> install <release-name> <chart>
```

- Update a release

```bash
helm -n <namespace> upgrade <release-name> <chart>
```

== Exercise: Create a Helm Chart for the Pedelec Server

- Task 1: Initialize the helm chart
- Task 2: Copy over the manifests
- Task 3: Remove namespace from all resources
- Task 4: Replace hard coded values with Templates

The reference chart lives at `exercises/03-helm/solution/helm/pedelec` and wraps
the Block 2 Deployments, Services, and Ingress with the values lifted into
`values.yaml`.

== Useful commands

```bash
helm install my-app ./my-chart                     # Starts the project
helm install my-app -f values.dev.yaml ./my-chart  # Deploy with dev config
helm install my-app -f values.prod.yaml ./my-chart # Deploy with prod config
helm uninstall my-app                              # Uninstalls the release and deletes resources
helm upgrade my-app ./my-chart                     # Shows the logs of all containers
helm template my-app ./my-chart                    # Prints the manifest without installing
helm lint ./my-chart                               # Validates chart structure and templates
```
