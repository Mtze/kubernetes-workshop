# Slides (LaTeX / Beamer)

A Beamer rebuild of the workshop deck that reproduces the original look: the
orange title band, full-orange section dividers, standardized break slides,
yellow speech-bubble callouts, orange highlight bands, and the light-box /
dark-terminal code styling. All institution-specific values live in
[`config.tex`](config.tex).

> There is also a Typst version of this deck under [`../slides/`](../slides/).
> This LaTeX version is the one that matches the original graphics 1:1.

## Build

Beamer overlays position against the physical page via TikZ `remember picture`,
so you must run **two passes**:

```bash
cd slides-latex
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex   # second pass places overlays
```

(or `latexmk -pdf main.tex`, which handles the passes automatically).

## Configure

Edit [`config.tex`](config.tex): presenter, institution, cluster URL / platform,
account wording, ingress base domain, image registry/owner, and the two corner
logos (`\wsLogoLight` for orange backgrounds, `\wsLogoDark` for white ones).

## Theme building blocks (`theme.tex`)

| Macro / env | Use |
|---|---|
| `\titleframe` | the orange-band title slide |
| `\sectionframe{Title}` | full-orange section divider |
| `\breakframe` | standardized break slide with the illustration |
| `\orangeband{...}` | full-width orange highlight / definition band |
| `\bubble{at}{pointer}{text}` | yellow speech bubble (inside a `remember picture, overlay` picture) |
| `\yamlfile{path}` | a light manifest box (reads from `../slide-examples/`) |
| `yamlbox` / `termbox` | light manifest box / dark terminal box |
| `\imgref{service}` | `<registry>/<owner>/pedelec-<service>:latest` |

Frames that contain a listing (`\yamlfile`, `termbox`, `lstlisting`) must be
declared `\begin{frame}[fragile]{...}`.

## Assets

Graphics live in `assets/`. `assets/orig/` (a raw dump of every image extracted
from the source PDF) is git-ignored; only the curated, named assets are tracked.
See `assets/NOTICE.md` for third-party-mark provenance.
