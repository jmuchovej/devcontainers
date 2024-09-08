//! How to edit this file:
//! In the `matrix` component of the `target: "typst"` block, prepend a new object
//!   with keys `{ typst = ????, typstyle = ????, variant = ????}`, then update the
//!   `variable "LATEST"` block to a default value matching this new entry!
// What the variables in the object you're adding refer to!
//   1. `typst` <-- this is the year of TeXLive we're building!
//      Releases here: https://github.com/typst/typst/releases/latest
//   2. `typstyle` <-- this is the version of `typstyle` to build
//      Releases here: http://github.com/Enter-tainer/typstyle/releases/latest
//   3. `variant` <-- this is based on what `mcr.microsoft.com` publishes as the latest
//      variant of Rust! see more:
//      https://mcr.microsoft.com/en-us/product/devcontainers/rust/about#using_this_image
//*     NOTE: this should be the latest Debian **prefixed with the _major version_**
//*     found in typst's `Cargo.toml`!
//*     Cmd+F "rust-version" in https://github.com/typst/typst/blob/main/Cargo.toml

variable "LATEST" {
  type = string
  default = "0.11.1"
}

group "default" {
  targets = [ "typst" ]
}

repo = "https://github.com/jmuchovej/devcontainers"
template = "${repo}/tree/main/src/templates/typst"
image = "ghcr.io/jmuchovej/devcontainers/typst"

target "typst" {
  matrix = {
    item = [
      {typst = "0.11.1", typstyle = "0.11.32", variant = "1-bookworm", },
      {typst = "0.11.0", typstyle = "0.11.20", variant = "1-bookworm", },
    ]
  }
  name = "typst-v${replace(item.typst, ".", "-")}"
  context = "./"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64", "linux/arm64", ]
  args = {
    VARIANT = item.variant
    TYPST_VERSION = "v${item.typst}"
    TYPSTYLE_VERSION = "v${item.typstyle}"
  }
  labels = {
    "org.opencontainers.image.source" = repo
    "org.opencontainers.image.authors" = "John Muchovej <jmuchovej@pm.me>"
    "org.opencontainers.image.url" = "${template}"
    "org.opencontainers.image.documentation" = "${template}/README.md"
    "org.opencontainers.image.title" = "Typst v${item.typst}"
  }
  tags = [ "${image}:${item.typst}", LATEST == item.typst ? "${image}:latest" : "", ]
}
