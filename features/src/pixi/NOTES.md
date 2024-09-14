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