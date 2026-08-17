// Kubernetes Basics - workshop slide deck (Touying, custom TUM-style theme).
//
// Build:
//   typst compile --root . slides/main.typ                       # neutral defaults
//   typst compile --root . --input variant=tum slides/main.typ   # a named variant (see config.typ)
//
// All institution-specific values come from config.typ.

#import "@preview/touying:0.6.1": *
#import "config.typ": cfg
#import "theme.typ": *

#show: workshop-theme.with(
  config-info(
    title: [Kubernetes (K8s) Basics],
    subtitle: [From Docker Compose to Helm on a real cluster],
    author: cfg.presenter,
    institution: if cfg.group == none { cfg.institution } else {
      cfg.institution + " · " + cfg.group
    },
    logo: cfg.logo,
  ),
)

#title-slide()

#include "sections/00-intro.typ"
#include "sections/01-docker-compose.typ"
#include "sections/02-kubernetes.typ"
#include "sections/03-helm.typ"
#include "sections/99-wrapup.typ"

// Optional private-registry / imagePullSecret material (config-gated).
#if cfg.show_registry_appendix {
  include "sections/99-appendix-registry.typ"
}
