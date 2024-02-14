#import "theme.typ": *

#show: presentation.with(
  author: [Sample Author \<me\@example.org\>],
  title: [Sample Title],
  occasion: [Sample Occasion],
  date: [01.01.1970],
  logos: ("figures/typst.svg", "figures/polylux.png", "figures/ferris.png"),
  logo_height: 40%,
  footer: [This is a really cool footer],
)

#section("My Section")
#slide(title: "My Title")[
  #grid(
    columns: (50%, 50%),
    [
      - #lorem(10)
      - #lorem(10)
      - #lorem(10)
      - #lorem(10)
    ],
    image("figures/ferris.png")
  )
]

#focus-slide()[
  We need to focus now...
]

#slide(title: "Some code!")[
  #figure(
    sourcecode(```rust
    enum Foo {
        Bar1(Box<Foo>),
        Bar2(String),
    }
    ```),
    caption: [Some awesome Rust!]
  )
]
