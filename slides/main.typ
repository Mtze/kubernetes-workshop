// Kubernetes Basics - workshop slide deck (Touying / metropolis).
//
// Build:
//   typst compile slides/main.typ                       # neutral defaults
//   typst compile --input variant=tum slides/main.typ   # a named variant (see config.typ)
//
// All institution-specific values come from config.typ.

#import "lib.typ": *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-colors(primary: cfg.accent),
  config-info(
    title: [Kubernetes Basics],
    subtitle: [From Docker Compose to Helm on a real cluster],
    author: cfg.presenter,
    institution: if cfg.group == none { cfg.institution } else {
      cfg.institution + " · " + cfg.group
    },
  ),
)

#show: codly-init.with()
#codly(languages: codly-languages, zebra-fill: none)

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
