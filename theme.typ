#import "@preview/polylux:0.3.1": *
#import "@preview/codelst:1.0.0": sourcecode

// CONFIG: Font
#let font = "Roboto"
#let weight = "light"
#let size = 20pt

// CONFIG: Color
#let color-primary = rgb("#66A182")
#let color-foreground = rgb("#5c6a72")
#let color-background = rgb("#ffffff")

#let footer-lighten-value = 50%             // how much lighter the color of the footer is
#let section-foreground = color-background  // color of text on section slide and headers
#let focus-background = color-foreground    // background of the focus slide
#let focus-foreground = color-background    // foreground of focus slide

// Footer in the bottom left
#let custom-footer = state("custom-footer", none)

// Last section in the top left
#let last-section = state("last-section", none)

// A normal slide
#let slide(title: none, is_toc: false, body) = {
  let header-cell = block.with(
    width: 100%,
    height: 100%,
    above: 0pt,
    below: 0pt,
    breakable: false
  )

  // Bar in the top
  let header = {
    set align(top)
    if title != none {
      show: header-cell.with(fill: color-primary, inset: 1.2em)
      set align(horizon)

      if not is_toc {
        text(fill: section-foreground, size: 0.6em, last-section.display())
        text([\ ])
      }
      text(fill: section-foreground, size: 1.2em, strong(title))

    } else { [] }
  }

  // Footer with text on the left and slide count on the right
  let footer = {
    set text(size: 0.6em)
    show: pad.with(1em)
    set align(bottom)
    let footer-color = color-foreground.lighten(footer-lighten-value)
    text(fill: footer-color, custom-footer.display())
    h(1fr)
    text(fill: footer-color, [#logic.logical-slide.display()/#utils.last-slide-number])
  }

  set page(
    header: header,
    footer: if not is_toc { footer } else [],
    margin: (top: 5em),
    fill: color-background,
  )

  let content = {
    show: align.with(horizon)
    show: pad.with(left: 2em, right: 2em, top: -1.5em)
    set text(fill: color-foreground)
    body
  }
  
  logic.polylux-slide(content)

  if is_toc {
    // Don't count TOC slide towards slide count
    logic.logical-slide.update(0)
  }
}


// The actual presentation main
#let presentation(
  aspect-ratio: "16-9",
  title: [Sample title],
  occasion: [Sample occasion], 
  author: [Sample Author],
  date: [01.01.1970],
  logos: (),
  logo_height: 50%,
  footer: [],
  body
) = {
  set text(font: font, weight: weight, size: size)
  set strong(delta: 100)
  set par(justify: true)

  set page(
    paper: "presentation-" + aspect-ratio,
    fill: color-background,
    margin: 0em,
    header: none,
    footer: none,
  )

  // save foother to global state
  custom-footer.update(footer)

  let title-slide = {
    set text(fill: color-foreground, size)
    set align(center + horizon)

    block(width: 100%, inset: 2em, {
      // Logo
      if type(logos) == type("string") { // fix buggy behavior, with a single entry
        align(center+horizon, image(logos, height: logo_height))
      } else if logos.len() == 0 {
        // Do not show any logos
      } else {
        grid(
          columns: logos.len(),
          ..logos.map((logo) => (align(center+horizon, image(logo, width: logo_height))))
        )
      }

      text(size: 1.3em, strong(title))

      line(length: 100%, stroke: .05em + color-primary)

      set text(size: .8em)
      h(1fr)
      if author != none {
        block(spacing: 1em, author)
      }
      if date != none {
        block(spacing: 1em, date)
      }
      set text(size: .8em)

      h(1fr)
      if occasion != none {
        set text(weight: "regular")
        block(spacing: 1em, occasion)
      }

    })
  }

  logic.polylux-slide(title-slide)

  // Show TOC
  slide(title: "Contents", is_toc: true)[
      #utils.polylux-outline(enum-args: (tight: false,))
  ]

  body
}


// Section brake slides with big title printed
#let section(name) = {
  set page(fill: color-primary)
  let content = {
    utils.register-section(name)
    set align(horizon + center)
    show: pad.with(20%)
    set text(size: 2em, weight: "bold", fill: section-foreground)
    name
  }

  logic.polylux-slide(content)

  // Do not count section slides towards total slide count
  logic.logical-slide.update(i => i - 1)

  // Update last section name to display it in the following slides
  last-section.update(name)
}

// Only show the text centered and big (good for a final slide)
#let focus-slide(body) = {
  set page(fill: focus-background, margin: 2em)
  set text(fill: focus-foreground, size: 1.5em)
  logic.polylux-slide(align(horizon + center, body))

  // Do not count focus slides towards total slide count
  logic.logical-slide.update(i => i - 1)
}
