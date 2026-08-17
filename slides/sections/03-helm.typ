#import "../lib.typ": *

= Block 3: Helm

// TODO(transcribe): fill per-slide prose from slides.pdf pages ~95-110.

== Why Helm?

One chart, many environments: template the manifests once, then override with
`values.yaml`. No more copy-pasting near-identical YAML per service or per student.

== The Pedelec chart (live demo)

```bash
helm install pedelec ./exercises/03-helm/solution/helm/pedelec
```

// TODO(transcribe): values.yaml walkthrough - templating the image, namespace, and host.
The chart wraps the three Deployments, three Services, and the Ingress from
Block 2, with the image owner and host lifted into `values.yaml`.
