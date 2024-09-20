
# pixi (pixi)

Add Pixi (by Prefix.dev) to your Dev Container!

## Example Usage

```json
"features": {
    "ghcr.io/jmuchovej/devcontainers/pixi:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select (or enter) the version of pixi you want to install. | string | latest |

## Limitations

The `onCreateCommand` relies on having passwordless `sudo` access. Thus, it demands that
both `sudo` is available and the `${remoteUser}` has passwordless access!

## OS Support
This feature has been tested on Debian-based distributions (Ubuntu & Debian). As of
**14 Sep 2024**, **Alpine is unsupported**. This is because Alpine does not provide a
the virtual package `__glibc`, which means that packages have `glibc` dependencies
cannot be used (_many of the core `conda` packages require `glibc` in some fashion).
Thus, there's little use in starting from an `alpine` image.

More details on [this GitHub issue][no-alpine-install] (tracked by the folks at
Prefix.dev).

[no-alpine-install]: https://github.com/prefix-dev/pixi-docker/issues/23

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/jmuchovej/devcontainers/blob/main/features/src/pixi/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
