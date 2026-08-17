#import "../lib.typ": *

= Block 2: Kubernetes Core

// TODO(transcribe): fill per-slide prose from slides.pdf pages ~45-94.

== Why Kubernetes?

// TODO(transcribe): why K8s / self-healing.
You declare the *desired state*; the cluster continuously *reconciles* the real
state toward it. No more imperative, step-by-step deployment.

== The reconciliation loop

#align(center, diagram(
  spacing: 4em,
  node((0, 0), [Desired state\ (your YAML)], stroke: 0.5pt, inset: 8pt),
  edge("-|>", [observe]),
  node((1, 0), [Controller], stroke: 0.5pt, inset: 8pt),
  edge("-|>", [act]),
  node((2, 0), [Cluster state], stroke: 0.5pt, inset: 8pt),
  edge((2, 0), (0, 0), "-|>", bend: -40deg, [diff]),
))

== Accessing the cluster

Log in to #cfg.cluster_platform at #strong(cfg.cluster_url) with #cfg.account_wording,
download your kubeconfig, then:

```bash
export KUBECONFIG=~/.kube/pedelec-workshop.yaml
kubectl cluster-info
kubectl get pods
```

Each participant gets a namespace named `#cfg.namespace_convention`.

== Namespaces

#example("10-kubernetes-namespace/namespace.yml")

== Pods

#example("11-kubernetes-pod/pod.yml")

== Pods: spot the bug

#example("11-kubernetes-pod/incorrect-pod.yml")

// TODO(transcribe): what is wrong here, and how kubectl describe surfaces it.

== Deployments

#example("12-kubernetes-deployment/deployment.yml")

== Deployment: Pedelec reservation

#example("13-kubernetes-deployment-reservation/reservation-deployment.yml")

Image: #raw(img("reservation"))

== Services

#example("14-kubernetes-service/service.yml")

== Service: Pedelec reservation

#example("15-kubernetes-service-reservation/reservation-service.yml")

== Ingress and path-based routing

#example("16-kubernetes-ingress/ingress.yml")

Your app becomes reachable at #strong(host(cfg.namespace_convention)).
