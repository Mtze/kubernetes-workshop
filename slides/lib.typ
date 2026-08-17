// Shared helpers for the workshop deck.
// Every section file starts with:  #import "../lib.typ": *

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "config.typ": cfg

// Render a file from ../slide-examples/ as a code listing, so the slides never
// drift from the runnable snippets in the repo. `read()` resolves relative to
// this file (slides/lib.typ).
#let example(path, lang: "yaml") = raw(read("../slide-examples/" + path), block: true, lang: lang)

// Fully-qualified container image reference for a Pedelec service, from config.
#let img(service) = cfg.image_registry + "/" + cfg.image_owner + "/pedelec-" + service + ":latest"

// A per-student ingress host under the configured base domain.
#let host(sub) = sub + "." + cfg.ingress_base
