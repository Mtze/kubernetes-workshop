#import "../lib.typ": *

= Block 1: Docker Compose

// TODO(transcribe): fill per-slide prose from slides.pdf pages ~8-44.
// Listings are wired from slide-examples/ so they never drift from the repo.

== A single service

#example("01-docker-compose-single-service/compose.yml")

== Multiple services

#example("02-docker-compose-multi-service/compose.yml")

== Publishing ports

#example("03-docker-compose-ports/compose.yml")

== Environment variables

#example("04-docker-compose-environment/compose.yml")

== Custom networks and `expose`

#example("05-docker-compose-networks/compose.yml")

== Run the Pedelec system

```bash
cd exercises/01-microservices
docker compose up
```

// TODO(transcribe): walkthrough of networks, ports, and useful compose commands.

== Scaling and load balancing

// TODO(transcribe): the scaling bridge that closes Block 1.
One container is not enough: replicas, load balancing, and rolling updates are
exactly the jobs an orchestrator does for you. That is the bridge into Kubernetes.
