#import "../lib.typ": *

= Wrap-up

== Summary

- ✅ What *Kubernetes* is and why it's the backbone of modern infrastructure
- 📜 Manifests - the declarative way to define your cluster's desired state
- 🧩 Building Blocks of a *Cluster*
  - 🧱 Pods - the smallest deployable units
  - 🚀 Deployments - manage replicas and rolling updates
  - 🌐 Services - stable endpoints for dynamic workloads
  - 🌍 Ingresses - routing external traffic into the cluster
- 🗃 Namespaces - organize and control environments and teams cleanly
- 🛠 *Helm* - the package manager for Kubernetes

== Summary

- What we achieved today:
  - You deployed the pedelec server project to the cloud! 🚀

// TODO(image): "NOT BAD" reaction meme.
#emph[..but where to go from here?]

== Further Materials and Topics

- Developer side
  - Make it big: *Autoscalers*
  - Work with ENV Variables: *ConfigMaps* and *Secrets*
  - Deep Dive: *Labels* and *LabelSelectors*
  - Persistent Storage: *Volumes* and *VolumeClaims*
- Kubernetes Internals
  - Cluster Architecture
  - Control Plane
  - Container Lifecycle
  - CRI, CNI, CSI

== Resources

- Docker
  - #link("https://docs.docker.com/compose/")
  - #link("https://docs.docker.com/compose/compose-file/")
- Kubernetes
  - #link("https://kubernetes.io/docs")
- Youtube
  - #link("https://youtu.be/iVj5vEnbFr0?si=Z4XJyKV4hvs50k4K")

All materials, exercises, and this deck:
#link("https://github.com/Mtze/kubernetes-workshop")

Presented by #cfg.presenter.

= [Optional] Kubernetes under the hood

== Control Plane

#align(center, diagram(
  spacing: 3em,
  node((0, 0), [Control Plane Node\ Scheduler · etcd · API Server\ Controller Manager\ Cloud Controller Manager\ kubelet · kube-proxy], stroke: 0.5pt, inset: 8pt),
  node((1, 0), [worker01\ kubelet · kube-proxy], stroke: 0.5pt, inset: 8pt),
  node((2, 0), [worker02\ kubelet · kube-proxy], stroke: 0.5pt, inset: 8pt),
  node((3, 0), [worker03\ kubelet · kube-proxy], stroke: 0.5pt, inset: 8pt),
  node((0, 1), [Developer Computer\ `kubectl`], stroke: 0.5pt, inset: 8pt),
  edge((0, 1), (0, 0), "-|>", [talks to API Server]),
))

Datacenter #sym.arrow Kubernetes Cluster: one control-plane VM and three worker
VMs; the developer's `kubectl` talks to the API Server on the control plane node.

== Kubernetes Networking

#align(center, diagram(
  spacing: 2.5em,
  node((0, 0), [Pod\ IP 10.41.1.1], stroke: 0.5pt, inset: 8pt),
  edge("-|>"),
  node((1, 0), [`eth0:vnic`], stroke: 0.5pt, inset: 8pt),
  edge("-|>"),
  node((2, 0), [`veth:vnic`], stroke: 0.5pt, inset: 8pt),
  edge("-|>"),
  node((3, 0), [Linux Kernel\ (Router)], stroke: 0.5pt, inset: 8pt),
  edge("-|>"),
  node((4, 0), [`eth0:nic`], stroke: 0.5pt, inset: 8pt),
  edge("-|>"),
  node((5, 0), [Datacenter\ Router], stroke: 0.5pt, inset: 8pt),
))

Each worker VM runs its pods in their own Linux namespaces (pod IPs from
10.41.x.x), connected through veth pairs to the node's Linux kernel router, out
its NIC, and across the shared datacenter router.

== Kubernetes Storage

#align(center, diagram(
  spacing: 3em,
  node((1, 0), [Pod], stroke: 0.5pt, inset: 8pt),
  edge((1, 0), (1, 1), "-|>", [mounts]),
  node((1, 1), [Volume], stroke: 0.5pt, inset: 8pt),
  node((0.5, 2), [PersistentVolume\ size, accessMode], stroke: 0.5pt, inset: 8pt),
  edge((0.5, 2), (1, 1), "-|>", [is a]),
  node((1.5, 2), [PersistentVolumeClaim\ size, accessMode], stroke: 0.5pt, inset: 8pt),
  edge((1.5, 2), (0.5, 2), "-|>", [binds]),
  node((1, 3), [StorageClass], stroke: 0.5pt, inset: 8pt),
  edge((0.5, 2), (1, 3), "--"),
  edge((1.5, 2), (1, 3), "--"),
  node((1, 4), [Provisioner], stroke: 0.5pt, inset: 8pt),
  edge((1, 3), (1, 4), "--"),
))

A Pod mounts Volumes; a PersistentVolume is a Volume; a PersistentVolumeClaim
binds to a PersistentVolume; both reference a StorageClass, which uses a
Provisioner.
