//! How to edit this file:
//! In the `matrix` component of the `target: "latex"` block, prepend a new object
//!   with keys `{ texlive = ????, chktex = ????, variant = ????}`, then update the
//!   `variable "LATEST"` block to a default value matching this new entry!
// What the variables in the object you're adding refer to!
//   1. `texlive` <-- this is the year of TeXLive we're building!
//      Cmd+F "Current release": https://tug.org/texlive/
//   2. `chktex` <-- this is the version of `chktex` to install
//      Releases here: http://download.savannah.gnu.org/releases/chktex
//   3. `variant` <-- this is based on when the Ubuntu's LTS release schedule
//      LTS __standard__ support schedule: https://ubuntu.com/about/release-cycle#ubuntu

variable "LATEST" {
  type = string
  default = "2024"
}

group "default" {
  targets = [ "latex" ]
}

repo = "https://github.com/jmuchovej/devcontainers"
template = "${repo}/tree/main/src/templates/latex"
image = "ghcr.io/jmuchovej/devcontainers/latex"

target "latex" {
  matrix = {
    item = [
      {texlive = "2024", chktex = "1.7.9", variant = "noble", },
      {texlive = "2023", chktex = "1.7.8", variant = "jammy", },
      {texlive = "2022", chktex = "1.7.6", variant = "jammy", },
    ]
  }
  name = "latex-v${replace(item.texlive, ".", "-")}"
  context = "./"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64", "linux/arm64", ]
  args = {
    VARIANT = item.variant
    CHKTEX_VERSION = "${item.chktex}"
    TEXLIVE_VERSION = "${item.texlive}"
  }
  labels = {
    "org.opencontainers.image.source" = repo
    "org.opencontainers.image.authors" = "John Muchovej <jmuchovej@pm.me>"
    "org.opencontainers.image.url" = "${template}"
    "org.opencontainers.image.documentation" = "${template}/README.md"
    "org.opencontainers.image.title" = "LaTeX Devcontainer with TexLive ${item.texlive}"
  }
  tags = [ "${image}:${item.texlive}", LATEST == item.texlive ? "${image}:latest" : "", ]
}
