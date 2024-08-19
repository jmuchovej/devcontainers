//! How to edit this file:
// 1. In the `default` group (below), you should append `texlive-????` where `????` is
//    the year you're adding.
// 2. You should copy the most recent `target` block and take care to update:
//    1. `TEXLIVE_VERSION`
//       Cmd+F "Current release": https://tug.org/texlive/
//    2. `CHKTEX_VERSION`
//       Releases here: http://download.savannah.gnu.org/releases/chktex
//    3. `VARIANT` <-- this is based on when the Ubuntu's LTS release schedule
//       LTS __standard__ support schedule: https://ubuntu.com/about/release-cycle#ubuntu

group "default" {
    targets = ["texlive2022", "texlive2023", "texlive2024"]
}

target "shared" {
    context = "./"
    dockerfile = "Dockerfile"
    platforms = [ "linux/amd64", "linux/arm64", ]
}

target "texlive2024" {
    inherits = ["shared"]
    args = {
        TEXLIVE_VERSION = "2024"
        CHKTEX_VERSION = "1.7.9"
        VARIANT = "noble"
    }
    labels = {
        "org.opencontainers.image.title" = "LaTeX DevContainer with TeXLive 2024"
    }
    tags = [
        "ghcr.io/jmuchovej/latex-devcontainer:2024",
        "ghcr.io/jmuchovej/latex-devcontainer:latest",
    ]
}

target "texlive2023" {
    inherits = ["shared"]
    args = {
        TEXLIVE_VERSION = "2023"
        CHKTEX_VERSION = "1.7.8"
        VARIANT = "jammy"
    }
    labels = {
        "org.opencontainers.image.title" = "LaTeX DevContainer with TeXLive 2023"
    }
    tags = [
        "ghcr.io/jmuchovej/latex-devcontainer:2023",
    ]
}

target "texlive2022" {
    inherits = ["shared"]
    args = {
        TEXLIVE_VERSION = "2022"
        CHKTEX_VERSION = "1.7.6"
        VARIANT = "jammy"
    }
    labels = {
        "org.opencontainers.image.title" = "LaTeX DevContainer with TeXLive 2022"
    }
    tags = [
        "ghcr.io/jmuchovej/latex-devcontainer:2022",
    ]
}
