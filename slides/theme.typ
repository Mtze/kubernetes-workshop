// Custom Touying theme for the workshop deck.
// Light content slides with an accent-coloured identity, full-accent section
// dividers, an accent band title slide, a bold slide title with an accent rule,
// a footer, and code styling (light boxes for manifests, dark boxes for terminals).
// The accent colour and all branding come from config.typ.

#import "@preview/touying:0.6.1": *
#import "config.typ": cfg

#let accent = cfg.accent
#let term-bg = rgb("#1b1b2b")
#let term-fg = rgb("#e8e8e8")
#let code-bg = rgb("#f6f6f8")
#let code-stroke = 0.6pt + rgb("#e2e2e6")

// ---------------------------------------------------------------- normal slide
#let slide(config: (:), repeat: auto, setting: body => body, composer: auto, ..bodies) = touying-slide-wrapper(self => {
  let header(self) = {
    grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      text(size: 1.5em, weight: "bold", fill: black)[#utils.display-current-heading(level: 2)],
      utils.call-or-display(self, self.info.logo),
    )
    v(-0.2em)
    line(length: 100%, stroke: 1.2pt + accent)
  }
  let footer(self) = {
    set text(size: 0.62em, fill: gray)
    grid(
      columns: (1fr, auto),
      [Workshop: Kubernetes Basics - #cfg.presenter],
      context (utils.slide-counter.display() + " / " + utils.last-slide-number),
    )
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      margin: (x: 2.2em, top: 3em, bottom: 1.8em),
    ),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})

// ----------------------------------------------------------------- title slide
#let title-slide(config: (:)) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  let info = self.info
  let body = {
    block(width: 100%, height: 40%, fill: accent, inset: (x: 2.2em, y: 1.4em))[
      #set align(horizon)
      #grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(fill: white, weight: "bold", size: 2.3em)[#info.title],
        utils.call-or-display(self, info.logo),
      )
    ]
    block(inset: (x: 2.2em, top: 1.6em))[
      #if info.subtitle != none {
        text(size: 1.15em, fill: accent, weight: "bold")[#info.subtitle]
        v(1.4em)
      }
      #text(size: 1.1em, weight: "bold")[#info.author]
      #linebreak()
      #text(fill: gray)[#info.institution]
    ]
  }
  touying-slide(self: self, config: config, body)
})

// --------------------------------------------------------------- section slide
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(fill: accent, margin: 2.5em))
  set text(fill: white, weight: "bold", size: 2em)
  touying-slide(
    self: self,
    config: config,
    align(center + horizon)[#utils.display-current-heading(level: 1) #body],
  )
})

// ---------------------------------------------------------------- focus slide
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(fill: accent, margin: 2.5em))
  set text(fill: white, weight: "bold", size: 1.8em)
  touying-slide(self: self, config: config, align(center + horizon, body))
})

// ---------------------------------------------------------------------- theme
#let workshop-theme(..args, body) = {
  show: touying-slides.with(
    config-page(paper: "presentation-16-9", margin: (x: 2.2em, top: 3em, bottom: 1.8em)),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: ("Helvetica Neue", "Arial", "DejaVu Sans"), size: 21pt, fill: rgb("#1a1a1a"))
        set par(spacing: 0.9em, leading: 0.62em)
        show strong: set text(fill: accent)
        // Code: light boxes for manifests, dark boxes for terminals.
        show raw.where(block: true): it => {
          let term = it.lang in ("bash", "sh", "shell", "console", "text")
          block(
            width: 100%,
            radius: 6pt,
            inset: (x: 12pt, y: 10pt),
            fill: if term { term-bg } else { code-bg },
            stroke: if term { none } else { code-stroke },
            text(size: 0.8em, fill: if term { term-fg } else { black })[#it],
          )
        }
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: accent,
      neutral-lightest: white,
      neutral-darkest: black,
    ),
    ..args,
  )
  body
}
