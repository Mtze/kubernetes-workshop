# Exercise 01 — Microservices & Docker Compose

> Get the three Pedelec microservices running locally with Docker Compose and exercise their HTTP APIs.

## Learning goals

After this exercise you'll have:

- A working local stack of three Go microservices behind Docker Compose.
- A mental model of which port belongs to which service.
- Hands-on familiarity with the API surface that exercises 02 and 03 will deploy to Kubernetes.

## Prerequisites

- Docker (24.x+) running locally
- Optional: [Bruno](https://www.usebruno.com/) for replaying the prepared API requests

Run `../../scripts/verify-prereqs.sh` from the repo root if you're not sure.

## What's in this folder

```
01-microservices/
├── damage/                # Go service, port 8082
├── location/              # Go service, port 8081
├── reservation/           # Go service, port 8080
├── docker-compose.yml     # Brings all three up together
├── go.work / go.work.sum  # Go workspace tying the modules together
└── bruno/                 # API request collection
```

Each service is a tiny Gin app with an in-memory mock dataset — no database, no auth, no persistence. The point is to keep the services small enough that all the focus stays on the operational layer.

## Step 1 — Start the stack

```bash
cd exercises/01-microservices
docker compose up --build
```

You should see three lines of `Starting <service> service` followed by Gin's startup logs.

> [!NOTE]
> First build takes a minute (Go toolchain + module download). Subsequent builds are seconds.

## Step 2 — Smoke-test each service

In another terminal:

```bash
# Reservation service — list pedelecs
curl -s http://localhost:8080/pedelec | jq

# Location service — create a location
curl -s -X POST http://localhost:8081/locations \
  -H 'Content-Type: application/json' \
  -d '{"id": "1", "lat": 48.149, "lng": 11.568}'

# Damage service — create a damage report
curl -s -X POST http://localhost:8082/damage \
  -H 'Content-Type: application/json' \
  -d '{"pedelecId": "1", "severity": 3, "comment": "Bent wheel"}'
```

If you have Bruno installed, open the `bruno/` folder as a collection and use the `Local-Development` environment.

## Step 3 — Map the API surface

Fill in this table by inspecting the running services (or by reading their `main.go`):

| Method | Path | Service | What it does |
|---|---|---|---|
| GET | `/pedelec` | reservation | List all pedelecs |
| GET | `/pedelec/:id` | reservation | Get one pedelec |
| POST | `/reservation` | reservation | Create a reservation |
| GET | `/reservation/:id` | reservation | Get a reservation |
| DELETE | `/reservation/:id` | reservation | Delete a reservation |
| POST | `/locations` | location | Create a location |
| GET | `/locations/:id` | location | Get a location |
| POST | `/damage` | damage | Create a damage report |
| GET | `/damage/:id` | damage | Get damage for a pedelec |

Notice that *every service exposes its routes at its own root* — there's no shared API prefix. In exercise 02, the Ingress will give us a single hostname with path-based fan-out across the three services.

## Common pitfalls

> [!WARNING] **Port already in use** — `docker compose up` will fail if anything else is listening on 8080, 8081, or 8082. Stop the offender or change the host port in `docker-compose.yml`.

> [!WARNING] **Stale containers** — if you edit Go code and re-run, use `docker compose up --build` (the `--build` is important).

## Next

[Exercise 02 — Kubernetes](../02-kubernetes/README.md) takes this same stack and runs it in a real cluster.
