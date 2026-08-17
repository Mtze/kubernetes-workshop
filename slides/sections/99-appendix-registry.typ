#import "../lib.typ": *

// Rendered only when cfg.show_registry_appendix is true (see config.typ).
// Transcribed from slides.pdf pages 65-67 (the "Configure Pull Secrets" slides).
// Relevant when pulling images from a PRIVATE registry. The default Pedelec
// images are public, so this is off by default. Registry specifics are shown as
// placeholders so the appendix is reusable.

#let c-note = rgb("#EF5350")
#let note = align(right, box(fill: c-note, inset: 8pt, radius: 4pt)[
  #text(fill: white)[Only needed for a private registry]
])

= Appendix: Private Registries

== Configure pull secrets: token

- Create an access token to your registry with `read_registry` scope
  - e.g. in GitLab: Settings > Repository > Deploy tokens > Add token
  - e.g. in GHCR: a personal access token with `read:packages`

#v(1em)
#note

== Configure pull secrets: create the secret

- Create the pull secret in your namespace:

```bash
kubectl -n <namespace> create secret docker-registry regcred \
  --docker-server=<your-registry> \
  --docker-username=<username> \
  --docker-password=<token>
```

#v(0.6em)
This is the "manual" way of creating a secret; prefer manifests whenever possible.

#note

== Configure pull secrets: use it

- Keep the secret out of version control; template the namespace in a manifest:

```bash
kubectl apply -f deployment-secrets.yml
```

- Reference the secret from the Pod (or Deployment template) spec:

```yaml
spec:
  imagePullSecrets:
    - name: regcred
```

- Kubernetes can now pull the images without further intervention

#note
