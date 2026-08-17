# Slides

The workshop deck, written in [Typst](https://typst.app) with
[Touying](https://typst.app/universe/package/touying) and a custom light theme
(`theme.typ`). Every institution-specific value, including the accent colour, is
a configuration variable, so you can rebuild the deck for your own cluster
without editing any slide.

## Build

Typst 0.13+ is required. Always pass `--root .` (from the repo root) so the deck
can read the code snippets in [`../slide-examples/`](../slide-examples/):

```bash
# Neutral defaults (placeholders, no institution branding)
typst compile --root . slides/main.typ slides.pdf

# A named variant (see config.typ)
typst compile --root . --input variant=tum slides/main.typ slides-tum.pdf

# Live preview while editing
typst watch --root . slides/main.typ
```

## Configure

All variables live in [`config.typ`](config.typ). A fork ships the `default`
variant (neutral placeholders). To reuse the deck:

- **Quick:** edit the values in the `default` block of `config.typ`.
- **Reusable:** copy the `tum` block, rename it (e.g. `myuni`), fill in your
  values, and build with `--input variant=myuni`. A variant only needs to list
  the keys it changes; everything else falls back to `default`.

| Variable | Meaning |
|---|---|
| `institution`, `group`, `presenter`, `logo`, `accent` | Title slide and branding |
| `cluster_platform`, `cluster_url`, `account_wording` | How students reach the cluster |
| `ingress_base` | `<student>.<ingress_base>` is where their app is exposed |
| `namespace_convention` | The namespace pattern shown to students |
| `image_registry`, `image_owner` | Image refs: `<registry>/<owner>/pedelec-<service>` |
| `show_registry_appendix` | Include the private-registry / imagePullSecret appendix |

## How it fits together

```
slides/
├── main.typ            # entrypoint: theme + config + includes every section
├── config.typ          # ALL configurable values (edit here)
├── theme.typ           # custom light theme (accent-coloured, from config)
├── lib.typ             # shared helpers (example(), img(), host())
└── sections/
    ├── 00-intro.typ
    ├── 01-docker-compose.typ
    ├── 02-kubernetes.typ
    ├── 03-helm.typ
    ├── 99-wrapup.typ
    └── 99-appendix-registry.typ   # only rendered when show_registry_appendix: true
```

Code listings are read straight from [`../slide-examples/`](../slide-examples/)
via the `example()` helper, so the slides can never drift from the runnable
snippets in the repo.

To run the workshop on your own cluster, see
[`../docs/instructor-guide.md`](../docs/instructor-guide.md).
