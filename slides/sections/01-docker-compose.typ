#import "../lib.typ": *

= Block 1: Docker Compose

== What is Docker Compose?

- Compose is a layer "on top" of Docker
- Docker compose allows to
  - *Combine* multiple containers that interact with each other
  - Start / Stop multiple containers easily
  - *Persist* data in volumes
  - Configure multiple *isolated environments* (e.g. development and testing)
  - *Deploy* software to a Server / VM

== The Docker Compose File

- Docker compose files are written in *yaml*: `compose.yaml`
- Defining:
  - `services`
    - Abstraction of a computing resource
    - A valid `compose.yaml` has to specify at least one service
  - `networks`
    - Abstraction of a communication channel
    - Handle service discovery
  - `volumes` / `configs` / `secrets`

== Example: `services`

Create a `compose.yml` file:

#example("01-docker-compose-single-service/compose.yml")

- We create a `service` called "app"
- From the `image` "hello-world"

Start the compose with:

```bash
docker compose up
```

== Example: Multiple `services`

Update the `compose.yml` file:

#example("02-docker-compose-multi-service/compose.yml")

Start the compose with:

```bash
docker compose up -d
docker compose ps
```

- The containers now run in the background ("detached")
- `docker compose ps` shows the running containers

== `docker compose ps`

Initial version of our `compose.yaml`:

```text
~/workshop> docker compose ps
NAME                    IMAGE             COMMAND                 SERVICE      CREATED        STATUS        PORTS
workshop-serverside1-1  nginxdemos/hello  "/docker-entrypoint.…" serverside1  3 minutes ago  Up 3 minutes  80/tcp
workshop-serverside2-1  nginxdemos/hello  "/docker-entrypoint.…" serverside2  3 minutes ago  Up 3 minutes  80/tcp
```

- The containers offer port 80 - but we can't access it yet

```bash
docker compose down
```

== Example: Make `services` accessible

Update the `compose.yml` file:

#example("03-docker-compose-ports/compose.yml")

- We map the host port 8081 to the container port 80

Start the compose.

== `docker compose ps` with ports

Initial version of our `compose.yaml`:

```text
~/workshop> docker compose ps
NAME                    IMAGE             COMMAND                 SERVICE      CREATED        STATUS        PORTS
workshop-serverside1-1  nginxdemos/hello  "/docker-entrypoint.…" serverside1  3 minutes ago  Up 3 minutes  80/tcp
workshop-serverside2-1  nginxdemos/hello  "/docker-entrypoint.…" serverside2  3 minutes ago  Up 3 minutes  80/tcp
```

Updated `compose.yaml` with port mappings:

```text
~/workshop> docker compose ps
NAME                    IMAGE             COMMAND                 SERVICE      CREATED        STATUS        PORTS
workshop-serverside1-1  nginxdemos/hello  "/docker-entrypoint.…" serverside1  2 minutes ago  Up 2 minutes  0.0.0.0:8081->80/tcp
workshop-serverside2-1  nginxdemos/hello  "/docker-entrypoint.…" serverside2  2 minutes ago  Up 2 minutes  0.0.0.0:8082->80/tcp
```

- Now the container port is forwarded (accessible) to the host. See `http://localhost:8082`

== Example: Inspect our `services`

Open `localhost:8081` and `localhost:8082` in the browser: each nginx page
reports its own server address (e.g. `172.20.0.2:80` and `172.20.0.3:80`).

- Each container has an (unique) IP address

// TODO(diagram): two browser screenshots of the nginxdemos/hello pages side by side.

== Configure Containers: `environment`

- Inject variables into containers

#example("04-docker-compose-environment/compose.yml")

- Never put secrets directly into the compose file - Use .env files instead
- Applications need to handle environment variables!

== Our Running Example: Pedelec App

Our office is located in close proximity to our customers. The access to public
transportation is poor and the number of available parking spots at the
customer's site is low.

With a bike, the customer site is easy to reach and only minimal parking space
is required. To reduce the commuting time to a minimum we plan to operate a pool
of Pedelecs (electricity powered bicycles) for our employees. Pedelecs can be
reserved with a new mobile app.

// TODO(diagram): photo of a cyclist.

== Our Running Example: Pedelec App (story)

Marie, an employee in the city, has an appointment at a partner site across town.
There are not enough public parking spots so she cannot use her car. If she uses
a Pedelec the trip can be done in 10 minutes.

She searches for a Pedelec in her app and sees that 3 of them are available and
have enough battery power to reach the site. Marie reserves this Pedelec.

When Marie arrives at the bike lot, the app automatically displays the PIN to
unlock the Pedelec. She unlocks it and drives over. There she notices that the
bell of the bike is damaged. She reports this damage with the app. After she is
back at the office, she returns the bike and releases her reservation.

== Software Engineering Happening

// TODO(diagram): meme image of a masked developer at a multi-monitor setup.

== Pedelec Server Side

// TODO(diagram): UML component diagram of the Pedelec server side.
// Three subsystems - Location System, Reservation, Damage System - each with a
// Database component and a Pedelec-<subsystem> controller component. A shared
// Loadbalancer sits below them, exposing Search Pedelec Service, Pedelec
// Location Service, Pedelec Management Service, Reservation Service and Damage
// Report Service.

Microservice architecture: Location System, Reservation, and Damage System,
each backed by its own database and fronted by a shared Loadbalancer.

== Exercise: Pedelec App Overview

`https://github.com/Mtze/kubernetes-workshop`

- Task 1: Fork and Clone the Pedelec Repo
- Task 2: Inspect the Server Side (`./exercises/01-microservices`)
- Task 3: Start the Server Side with docker compose

== Tasks

```bash
git clone git@github.com:Mtze/kubernetes-workshop.git
cd kubernetes-workshop
code .
cd exercises/01-microservices
docker compose up
```

== Exercise: Pedelec App API

- Task 1: Open Bruno
- Task 2: Open Bruno config
- Task 3: Check if API is working

== The Docker Compose File (revisited)

- Docker compose files are written in *yaml*: `compose.yaml`
- Defining:
  - `services` #sym.checkmark
    - Abstraction of a computing resource
    - A valid `compose.yaml` has to specify at least one service
  - `networks`
    - Abstraction of a communication channel
    - Handle service discovery
  - `volumes` / `configs` / `secrets`

== Example: `networks`

Architecture we created with `ports`:

#diagram(
  spacing: 3em,
  node((0, 0), [Client], stroke: 0.5pt),
  node((1, 0), [app1], stroke: 0.5pt),
  node((1, 1), [app2], stroke: 0.5pt),
  edge((0, 0), (1, 0), "-|>"),
  edge((0, 0), (1, 1), "-|>"),
)

Architectures we can create with `networks`:

#diagram(
  spacing: 3em,
  node((0, 0), [Client], stroke: 0.5pt),
  node((1, 0), [app1], stroke: 0.5pt),
  node((2, 0), [app2], stroke: 0.5pt),
  edge((0, 0), (1, 0), "-|>"),
  edge((1, 0), (2, 0), "-|>"),
)

== Example: Create `networks`

Update the `compose.yml` file:

#example("05-docker-compose-networks/compose.yml")

- We're still using `ports` to map the service to the host
- Both containers connect to the same network
- We replaced the `port` mapping with an `expose` to limit access to within the "mynet" `network`
- We explicitly define a `network`

== `docker compose ps` with networks

Updated `compose.yaml` with a private network:

```text
~/workshop> docker compose ps
NAME             IMAGE             COMMAND                 SERVICE  CREATED         STATUS         PORTS
workshop-app1-1  nginxdemos/hello  "/docker-entrypoint.…" app1     16 seconds ago  Up 15 seconds  0.0.0.0:8080->80/tcp
workshop-app2-1  nginxdemos/hello  "/docker-entrypoint.…" app2     16 seconds ago  Up 15 seconds  80/tcp
```

- app1 is reachable from outside the network: `port`
- app2 is only reachable from within the network: `expose`

== Useful commands

```bash
docker compose up       # Starts the project in foreground
docker compose up -d    # Starts the project in the background
docker compose ps       # Shows all running services
docker compose down     # Stops the project
docker compose logs     # Shows the logs of all containers
docker compose pull     # Pulls the images of all services
```

== Break

// TODO(diagram): illustration of a person taking a break at a desk.
#align(center)[_Short break - back in a few minutes._]

== Scaling your Application

// Section-divider slide in the deck (rendered as a normal slide).

== What is scaling?

#block(inset: (x: 1em, y: 0.8em), radius: 6pt, fill: cfg.accent.lighten(85%))[
  Scalability is the property of a system to handle a growing amount of work by
  adding resources to the system.
]

- How can we scale?
  - Make the existing resources more capable
  - Add more of the same resources we have already

== Scale up vs. Scale out: vertical

- *Vertical Scaling:* Scaling up / down
  - Scale the machine (More CPU / More RAM)
  - *Benefits*
    - No software changes required
    - Easy to maintain
  - *Drawbacks*
    - Limited by physics
    - Hardware cost may be significant

// TODO(diagram): a small Server box growing into a larger Server box.

== Scale up vs. Scale out: horizontal

- *Horizontal Scaling:* Scaling out / in
  - Scale the application
  - *Benefits*
    - Flexible
    - Limitless (More or less)
  - *Drawbacks*
    - More complex architecture
    - Harder to debug

- If we talk about scaling today we mean horizontal scaling

// TODO(diagram): one Application box fanning out into four Application boxes.

== Scalable Architectures

- Key Aspects for a scalable architecture
  - *API-First Design:* Clear interfaces between components.
  - *Stateless Services:* Design services to avoid local state
  - *Async Communication:* Prefer message queues or event-driven designs
  - *Database Sharding/Replication:* Avoid bottlenecks by scaling data layers
  - *Observability and Monitoring:* Integrate logging, metrics, and tracing
  - *Resilience and Fault Tolerance:* Design for failure with retries, circuit breakers, and graceful degradation

== Pedelec Server Side: scalability

// TODO(diagram): the Pedelec server-side UML component diagram, annotated with
// which scalability properties are already satisfied.

Reviewing the Pedelec server side against the scalability aspects:
- DB Shards #sym.checkmark
- Stateless Controller #sym.checkmark
- API Specs #sym.checkmark
- Event Framework?

== Problems with scaling

- Service Discovery
- Load Balancing
- Shared Data
- Shared Storage
- Configuration Management
- Observability

// TODO(diagram): one Application box fanning out into four Application boxes.
// (Service Discovery and Load Balancing are highlighted; the remaining items
// are previewed for later.)

== Load Balancing

#block(inset: (x: 1em, y: 0.8em), radius: 6pt, fill: cfg.accent.lighten(85%))[
  Load balancing is the process of distributing a set of tasks over a set of
  resources (computing units), with the aim of making their overall processing
  more efficient.
]

- Load balancing can be conducted on *different levels*
- Example: University Assignments
  - Distribute by exercise sheet
  - Distribute by exercise
  - Distribute by sub problem

== ISO/OSI Model

- Layer 7 - Application Layer (HTTP / DNS / BGP)
- Layer 6 - Presentation Layer
- Layer 5 - Session Layer
- Layer 4 - Transport Layer (UDP / TCP, Segment)
- Layer 3 - Network Layer (IPv4 / IPv6 / ICMP / ARP, Packet)
- Layer 2 - Data Link Layer (Ethernet, Frame)
- Layer 1 - Physical Layer (Fiber optics)

Where load balancing happens:
- *Application Load Balancer* - Layers 5-7
- *Network Load Balancer* - Layers 3-4
- *Link Aggregation* - Layers 1-2

// TODO(diagram): two OSI stacks side by side with the three load-balancer
// scopes bracketing their layer ranges.
