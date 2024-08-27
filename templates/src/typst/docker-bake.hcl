//! How to edit this file:
// 1. In the `default` group (below), you should append `texlive-????` where `????` is
//    the year you're adding.
// 2. You should copy the most recent `target` block and take care to update:
//    1. `TYPST_VERSION`
//       https://github.com/typst/typst/releases
//    2. `VARIANT` <-- Use the latest Debian, but prefix with Rust major version!
//       Cmd+F "rust-version" in https://github.com/typst/typst/blob/main/Cargo.toml

group "default" {
    targets = [
        "typst-v0-11-1",
        "typst-v0-11-0",
    ]
}

target "shared" {
    context = "./"
    dockerfile = "Dockerfile"
    platforms = [ "linux/amd64", "linux/arm64", ]
}

target "typst-v0-11-1" {
    inherits = ["shared"]
    args = {
        TYPST_VERSION = "v0.11.1"
        TYPSTYLE_VERSION = "v0.11.32"
        VARIANT = "1-bookworm"
    }
    labels = {
        "org.opencontainers.image.title" = "Typst v0.11.1"
    }
    tags = [
        "ghcr.io/jmuchovej/typst-devcontainer:0.11.1",
        "ghcr.io/jmuchovej/typst-devcontainer:latest",
    ]
}

target "typst-v0-11-0" {
    inherits = ["shared"]
    args = {
        TYPST_VERSION = "v0.11.0"
        TYPSTYLE_VERSION = "v0.11.20"
        VARIANT = "1-bookworm"
    }
    labels = {
        "org.opencontainers.image.title" = "Typst v0.11.0"
    }
    tags = [
        "ghcr.io/jmuchovej/typst-devcontainer:0.11.0",
    ]
}
