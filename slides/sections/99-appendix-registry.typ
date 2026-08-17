#import "../lib.typ": *

= Appendix: Private Registries

// Rendered only when cfg.show_registry_appendix is true (see config.typ).
// TODO(transcribe): slides ~64-67 (imagePullSecret against a private registry).

== When your images are not public

The default Pedelec images are public on #cfg.image_registry, so any cluster can
pull them. If your images live on a *private* registry, the cluster needs
credentials first.

== Create an image pull secret

```bash
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<user> \
  --docker-password=<token>
```

== Use it in a Pod

Reference the secret in the Pod (or Deployment template) spec:

```yaml
spec:
  imagePullSecrets:
    - name: regcred
  containers:
    - name: reservation
      image: <registry>/<owner>/pedelec-reservation:latest
```
