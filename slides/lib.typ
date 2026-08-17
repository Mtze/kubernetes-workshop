// Shared imports and helpers for the workshop deck.
// Every section file starts with:  #import "../lib.typ": *

#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "config.typ": cfg

// Render a file from ../slide-examples/ as a syntax-highlighted code listing,
// so the slides never drift from the runnable snippets in the repo.
// `read()` resolves relative to this file (slides/lib.typ).
#let example(path, lang: "yaml") = raw(read("../slide-examples/" + path), block: true, lang: lang)

// Fully-qualified container image reference for a Pedelec service, from config.
#let img(service) = cfg.image_registry + "/" + cfg.image_owner + "/pedelec-" + service + ":latest"

// A per-student ingress host under the configured base domain.
#let host(sub) = sub + "." + cfg.ingress_base
