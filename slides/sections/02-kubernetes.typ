#import "../lib.typ": *

// --- shared colours -------------------------------------------------------
#let c-pod = rgb("#F5A623")
#let c-svc = rgb("#66BB6A")
#let c-ing = rgb("#EF5350")
#let c-hl = rgb("#F5A623")

// --- the recurring "Kubernetes Objects" UML map ---------------------------
// One helper, reused per slide with a different highlighted box (1:1 with the
// six build-up slides).
#let omap(pos, key, body, hi) = node(
  pos, body, stroke: 0.5pt, inset: 6pt,
  fill: if key == hi { c-hl } else { none },
)
#let k8s-map(hi: "") = align(center, diagram(
  spacing: (1.1em, 1.0em),
  omap((1, 0), "namespace", [Namespace], hi),
  omap((1, 1), "ko", [*KubernetesObject*], hi),
  omap((2.7, 0.5), "label", [Label], hi),
  omap((3.7, 1), "labelselector", [LabelSelector], hi),
  omap((0, 3), "statefulset", [StatefulSet], hi),
  omap((0, 4), "job", [Job], hi),
  omap((0, 5), "pv", [PersistentVolume], hi),
  omap((0, 6), "pvc", [PersistentVolumeClaim], hi),
  omap((1.7, 3), "pod", [Pod], hi),
  omap((1.7, 4), "replicaset", [ReplicaSet], hi),
  omap((1.7, 5), "deployment", [Deployment], hi),
  omap((1.7, 6), "service", [Service], hi),
  omap((1.7, 7), "ingress", [Ingress], hi),
  omap((3.5, 4), "clusterip", [ClusterIP], hi),
  omap((3.5, 5), "nodeport", [NodePort], hi),
  omap((3.5, 6), "loadbalancer", [LoadBalancer], hi),
  edge((1, 0), (1, 1), "-"),
  edge((1, 1), (2.7, 0.5), "-"),
  edge((2.7, 0.5), (3.7, 1), "-"),
  edge((1, 1), (1, 2.1), "-"),
  edge((0, 3), (1, 2.1), "-|>"),
  edge((0, 4), (1, 2.1), "-|>"),
  edge((0, 5), (1, 2.1), "-|>"),
  edge((0, 6), (1, 2.1), "-|>"),
  edge((1.7, 3), (1, 2.1), "-|>"),
  edge((1.7, 4), (1, 2.1), "-|>"),
  edge((1.7, 5), (1, 2.1), "-|>"),
  edge((1.7, 6), (1, 2.1), "-|>"),
  edge((1.7, 7), (1, 2.1), "-|>"),
  edge((1.7, 4), (1.7, 3), "-|>", [\*]),
  edge((1.7, 5), (1.7, 4), "-|>"),
  edge((3.5, 4), (1.7, 6), "-|>"),
  edge((3.5, 5), (1.7, 6), "-|>"),
  edge((3.5, 6), (1.7, 6), "-|>"),
  edge((1.7, 7), (1.7, 6), "-"),
))

// --- topology node helpers (Services / Ingress build-up) ------------------
#let podn(pos, name, fill: none) = node(
  pos, align(center)[«Pod»\ #name], stroke: 0.5pt, inset: 8pt, fill: fill,
)
#let svcn(pos, name) = node(
  pos, align(center)[«Service»\ #name], stroke: 0.5pt, inset: 8pt, fill: c-svc,
)
#let ingn(pos, name) = node(
  pos, align(center)[«Ingress»\ #name], stroke: 0.5pt, inset: 8pt, fill: c-ing,
)

= Block 2: Kubernetes Core

== Warning!

- Everything created in the workshop #cfg.cluster_platform project will be deleted!
- You may use the cluster for your project at the host institution
  - Practical-course teams can request Kubernetes access
  - Every DevOps team gets a #cfg.cluster_platform project automatically
- The cluster has a fair use policy!
  - Only reserve what you really need
  - Make sure your code / deployment is not vulnerable
  - Projects that misbehave are removed without notice

== Exercise: Get access to #cfg.cluster_platform

+ Task 1: open #strong(cfg.cluster_url)
+ Task 2: log in with #cfg.account_wording
+ Task 3: access the student cluster

== Exercise: kubectl

+ Task 1: download the `kubeconfig`
+ Task 2: put the `kubeconfig` into `~/.kube/config`
+ Task 3: ensure the connection works: `kubectl cluster-info`

#v(1em)
If you already have something in there, create a backup of the file first.

== Break

#align(center + horizon, text(size: 1.6em, fill: gray)[Break])

== Kubernetes API and API objects

- Namespace
- Pod
- Workloads
  - (ReplicaSet)
  - Deployment
- Service
- Ingress

== Kubernetes objects: Namespace

#k8s-map(hi: "namespace")

== Namespaces

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - *Isolate* groups of *resources*
    - Encapsulate / *scope names*
      - Names of resources within a Namespace have to be unique
    - *Access control*
    - Resource quotas
  ],
  example("10-kubernetes-namespace/namespace.yml"),
)

== Get to know the cluster: namespaces

- Create a namespace (important step to work with the #cfg.cluster_platform cluster)
  - Open #cfg.cluster_platform and navigate to the respective cluster
  - Select Cluster > Projects/Namespaces
  - Click the "Create Namespace" button in the respective project
- See what is running in a specific namespace:

```bash
kubectl -n <namespace> get all
```

== Kubernetes objects: Pod

#k8s-map(hi: "pod")

== Pods

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - *Smallest deployable computing unit* in Kubernetes
    - Group of *one or more containers*
    - Ephemeral nature
      - "Designed to be destroyed"
    - Containers within a Pod *share*
      - Storage
      - Network (IP address)
    - It is uncommon to work with `Pods` directly
  ],
  [
    #rect(stroke: 1pt + gray, inset: 1em, radius: 2pt, width: 100%)[
      Pod
      #v(0.4em)
      #rect(stroke: 1pt + gray, inset: 1.2em, radius: 2pt, width: 100%)[Container]
    ]
    #v(0.6em)
    #align(center, box(fill: c-hl, inset: 8pt, radius: 4pt)[Mostly one container per pod])
  ],
)

== Pods: manifest

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - *Smallest deployable computing unit* in Kubernetes
    - Group of *one or more containers*
    - Ephemeral nature
      - "Designed to be destroyed"
    - Containers within a Pod *share*
      - Storage
      - Network (IP address)
    - It is uncommon to work with `Pods` directly
  ],
  example("11-kubernetes-pod/pod.yml"),
)

== Pods: manifest explained

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("11-kubernetes-pod/pod.yml"),
  [
    - `name` / `namespace`: Name and Namespace of the Pod
    - `labels`: Labels to select the Pod later on
    - `containers`: List of containers in the Pod
    - `name` / `image`: Name and image of the container
    - `ports`: List of ports to the container
  ],
)

== Get to know the cluster: apply

- Deploy a manifest to the cluster (you are just "stating your wishlist", not actually deploying something):

```bash
kubectl apply -f example.yaml
```

- Update a manifest:

```bash
kubectl apply -f example.yaml
```

- Delete all resources in the manifest:

```bash
kubectl delete -f example.yaml
```

== Debugging in Kubernetes

- Get a Kubernetes resource:

```bash
kubectl [-n namespace] get pod
```

- Get details about a Kubernetes resource:

```bash
kubectl [-n namespace] describe pod <name>
```

== Kubernetes objects: Deployment

#k8s-map(hi: "deployment")

== Deployments

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - *Declarative control group* for `Pods` and `ReplicaSets`
      - Update images
      - Update environments
    - Manages *application scaling*
    - Manages *rollout* and *rollback*
    - `LabelSelector` based
  ],
  example("12-kubernetes-deployment/deployment.yml"),
)

== Deployments: manifest explained

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("12-kubernetes-deployment/deployment.yml"),
  [
    - `name` / `namespace`: Name and Namespace of the Deployment
    - `replicas`: n Pods the Deployment should create
    - `selector` / `matchLabels`: Pod selector, "Who is part of the deployment"
    - `template`: Template for Pods
    - `template` labels: Labels which all spawned Pods will receive
    - `containers`: Name and image of the containers in the Pod
  ],
)

== Kubernetes objects: LabelSelector

#k8s-map(hi: "labelselector")

== Interacting with Deployments

- Deploy a deployment manifest to the cluster:

```bash
kubectl apply -f deployment.yaml
```

- Inspect the deployment:

```bash
kubectl describe deployment <name>
```

- Get the application logs:

```bash
kubectl logs deployment/<name>
```

- Scale the application to multiple running instances:

```bash
kubectl scale deployment <name> --replicas=3
```

- Revert to the last deployed version:

```bash
kubectl rollout undo deployment <name>
```

== Exercise: Deployment for the reservation system

+ #strike[Task 1: configure the cluster to be able to pull from a private registry] (see appendix: Private Registries)
+ Task 2: create a deployment manifest for the reservation system

#v(1em)
You can use the templates in your repo as a starting point.

== Task 2: Create reservation deployment

// TODO(diagram): Pedelec component diagram (Location / Reservation / Damage
// systems, each with a database and a service, fronted by a load balancer);
// the Pedelec Reservation component is highlighted.
#align(center, text(fill: gray)[The Pedelec Reservation component of the system architecture])

== Task 2: reservation deployment manifest

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("13-kubernetes-deployment-reservation/reservation-deployment.yml"),
  [
    Image: #raw(img("reservation"))

    - Remember to update the namespace to your own!
    - The resource limits are omitted on the slide; you will see them in the demo.
  ],
)

== Task 2: apply the deployment

- Apply the new manifest:

```bash
kubectl apply -f reservation-deployment.yml
```

- See which `Deployments` are present in a specific `Namespace`:

```bash
kubectl -n <namespace> get deployments
```

== Break

#align(center + horizon, text(size: 1.6em, fill: gray)[Break])

== We have a problem now...

- We learned that
  - Pods are ephemeral
  - Get a new IP address on every schedule
  - Are scattered over all Kubernetes nodes
- How do we find them then?
  - $arrow.r$ Services

== Kubernetes objects: Service

#k8s-map(hi: "service")

== ISO/OSI model (Service)

#table(
  columns: (auto, auto),
  align: (left, left),
  [Layer 7 - Application], [HTTP / DNS / BGP],
  [Layer 6 - Presentation], [],
  [Layer 5 - Session], [],
  [Layer 4 - Transport], [UDP / TCP (Segment)],
  [Layer 3 - Network], [IPv4 / IPv6 / ICMP / ARP (Packet)],
  [Layer 2 - Data Link], [Ethernet (Frame)],
  [Layer 1 - Physical], [Fiber optics],
)

#v(0.6em)
The Service lives here: Layer 4 (Transport).

== Services

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - Abstraction layer to expose a set of `Pods` in the cluster
    - Manages *service discovery*
    - Manages *load balancing* to Pods
    - IP addressable
    - `LabelSelector` based
  ],
  example("14-kubernetes-service/service.yml"),
)

== Services: manifest explained

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("14-kubernetes-service/service.yml"),
  [
    - `name` / `namespace`: Name and Namespace of the Service
    - `selector`: Pod selector, "Who can I send traffic to"
    - `port`: Port the Service exposes
    - `targetPort`: Port(name) the Service connects to
  ],
)

== Services: backing Pods (1)

*Kubernetes Cluster*
#align(center, diagram(
  spacing: 2em,
  podn((0, 1), [Reservation]),
  podn((1.2, 0), [Damage]),
  podn((3, 0.6), [Reservation]),
  podn((0.4, 2), [Reservation]),
  podn((1.7, 2.4), [Damage]),
  podn((2.7, 1.8), [Reservation]),
))

== Services: backing Pods (2)

*Kubernetes Cluster*
#align(center, diagram(
  spacing: 2em,
  podn((0, 1), [Reservation], fill: c-pod),
  podn((1.2, 0), [Damage]),
  podn((3, 0.6), [Reservation], fill: c-pod),
  podn((0.4, 2), [Reservation], fill: c-pod),
  podn((1.7, 2.4), [Damage]),
  podn((2.7, 1.8), [Reservation], fill: c-pod),
))

== Services: single entry point

*Kubernetes Cluster*
#align(center, diagram(
  spacing: (2.5em, 3em),
  svcn((1.5, 0), [Reservation]),
  podn((0, 1), [Reservation], fill: c-pod),
  podn((1, 1), [Reservation], fill: c-pod),
  podn((2, 1), [Reservation], fill: c-pod),
  podn((3, 1), [Reservation], fill: c-pod),
  edge((1.5, 0), (0, 1), "-"),
  edge((1.5, 0), (1, 1), "-"),
  edge((1.5, 0), (2, 1), "-"),
  edge((1.5, 0), (3, 1), "-"),
))

#grid(columns: (1fr, 1fr), gutter: 1em,
  align(center, box(fill: c-hl, inset: 6pt, radius: 4pt)[Single point of entry to all selected Pods]),
  align(center, box(fill: c-hl, inset: 6pt, radius: 4pt)[We call these "Backing Pods" of a Service]),
)

== Exercise: Service for the reservation system

+ Task 1: create a Service manifest for the reservation system
+ Task 2: get the Service details using `kubectl`

== Task 1: Create reservation service

// TODO(diagram): Pedelec component diagram; the Reservation Service interface
// (provided by the Reservation system through the load balancer) is highlighted.
#align(center, text(fill: gray)[The Reservation Service interface of the system architecture])

== Task 1: reservation service manifest

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("15-kubernetes-service-reservation/reservation-service.yml"),
  align(horizon, box(fill: c-hl, inset: 8pt, radius: 4pt)[We use the same label to select the matching Pods]),
)

== Task 2: Find the service

- See which `Services` are present in a specific `Namespace`:

```bash
kubectl -n <namespace> get services
```

== Kubernetes objects: Ingress

#k8s-map(hi: "ingress")

== ISO/OSI model (Ingress)

#table(
  columns: (auto, auto),
  align: (left, left),
  [Layer 7 - Application], [HTTP / DNS / BGP],
  [Layer 6 - Presentation], [],
  [Layer 5 - Session], [],
  [Layer 4 - Transport], [UDP / TCP (Segment)],
  [Layer 3 - Network], [IPv4 / IPv6 / ICMP / ARP (Packet)],
  [Layer 2 - Data Link], [Ethernet (Frame)],
  [Layer 1 - Physical], [Fiber optics],
)

#v(0.6em)
Ingress operates at Layer 7 (Application); the Service at Layer 4 (Transport).

== Kubernetes Ingresses

#block(fill: c-hl, inset: 10pt, radius: 4pt, width: 100%)[
  An Ingress is a Kubernetes API object that manages external access to services in a cluster, typically via HTTP/HTTPS.
]

#v(0.6em)
- *Central entry point* for multiple services (reverse proxy)
- Clean URL routing (e.g., `/api`, `/admin`)
- *TLS termination* (HTTPS)
- Path-based and host-based routing
- An ingress needs to be implemented by an *IngressController*

#v(0.4em)
First API object which is not in the Kubernetes core.

== Ingress: service exposed

*Kubernetes Cluster*
#align(center, diagram(
  spacing: (2.5em, 3em),
  svcn((1.5, 0), [Reservation]),
  podn((0, 1), [Reservation], fill: c-pod),
  podn((1, 1), [Reservation], fill: c-pod),
  podn((2, 1), [Reservation], fill: c-pod),
  podn((3, 1), [Reservation], fill: c-pod),
  edge((1.5, 0), (0, 1), "-"),
  edge((1.5, 0), (1, 1), "-"),
  edge((1.5, 0), (2, 1), "-"),
  edge((1.5, 0), (3, 1), "-"),
))

== Ingress: single service route

*Kubernetes Cluster* #h(1fr) `pedelec.com`
#align(center, diagram(
  spacing: (2.5em, 2.6em),
  ingn((1.5, -1), [Pedelec]),
  svcn((1.5, 0), [Reservation]),
  podn((0, 1), [Reservation], fill: c-pod),
  podn((1, 1), [Reservation], fill: c-pod),
  podn((2, 1), [Reservation], fill: c-pod),
  podn((3, 1), [Reservation], fill: c-pod),
  edge((1.5, -1), (1.5, 0), "-", raw("/reservation")),
  edge((1.5, 0), (0, 1), "-"),
  edge((1.5, 0), (1, 1), "-"),
  edge((1.5, 0), (2, 1), "-"),
  edge((1.5, 0), (3, 1), "-"),
))

== Ingress: path-based fan-out

*Kubernetes Cluster* #h(1fr) `pedelec.com`
#align(center, diagram(
  spacing: (3em, 3em),
  ingn((1, 0), [Pedelec]),
  svcn((0, 1), [Location]),
  svcn((1, 1), [Reservation]),
  svcn((2, 1), [Damage]),
  edge((1, 0), (0, 1), "-", raw("/location")),
  edge((1, 0), (1, 1), "-", raw("/reservation")),
  edge((1, 0), (2, 1), "-", raw("/damage")),
))

== Ingress

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - *Exposes* Services outside the cluster via *HTTP/HTTPS*
      - HTTP load balancing
      - TLS termination
    - Backed by an IngressController
    - Acts like a "Reverse Proxy"
  ],
  example("16-kubernetes-ingress/ingress.yml"),
)

== Ingress: manifest explained

#grid(columns: (1fr, 1fr), gutter: 1em,
  example("16-kubernetes-ingress/ingress.yml"),
  [
    - `apiVersion`: notice the different apiVersion
    - `name` / `namespace`: Name and Namespace of the Ingress
    - `annotations`: new concept, arbitrary non-identifying metadata
    - `host`: Hostname the ingress listens for
    - `path`: Path the ingress routes
    - `backend` / `service`: Service and Port of the backing Service
  ],
)

== Exercise: Ingress for the Pedelec server

+ Task 1: single Ingress deployment
+ Task 2: test the endpoints with Bruno
+ Task 3: add remaining endpoints to the ingress

== Important notes

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    - You can *only use* hosts under #raw("*." + cfg.ingress_base) in the cluster by default
    - You need to make sure that the backing pod *expects the correct route*
    - *Ingress configurations* are heavily based on annotations
      - You can *request a TLS certificate* via an annotation
      - Make sure to test with staging first ;)

    #v(0.4em)
    Let's Encrypt has strict rate-limiting policies.
  ],
  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: app1-ingress
    namespace: my-namespace
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
      cert-manager.io/cluster-issuer: letsencrypt-staging
  spec:
    tls:
      - hosts:
          - pedelec.com
        secretName: reservation-tls
    rules:
      - host: pedelec.com
        http:
          paths:
            - path: /reservation
              pathType: Prefix
              backend:
                service:
                  name: pedelec-reservation-service
                  port:
                    number: 80
  ```,
)

== From Compose to Kubernetes

- Keep in mind:
  - *This mapping is not general advice but for this example it is sufficient!*
- Mapping:

#table(
  columns: (1fr, auto, 1fr),
  align: (center, center, center),
  [*Docker World*], [], [*Kubernetes World*],
  [Service], [$arrow.r$], [Deployment],
  [Expose], [$arrow.r$], [Service],
  [Port], [$arrow.r$], [Service / Ingress],
)

#v(0.6em)
#align(center, box(fill: c-ing, inset: 8pt, radius: 4pt)[
  #text(fill: white)[Docker and Kubernetes use the word "Service" to describe different things!]
])
