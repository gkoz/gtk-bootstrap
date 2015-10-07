## gtk-bootstrap
Build GTK from source

### Prerequisites

Some of the dependencies you can install from your distribution's packages:
- libegl1-mesa-dev
- libfreetype6-dev
- libpng-dev
- libxml-parser-perl
- libxtst-dev
- xutils-dev

### Building

```shell
> ./bootstrap.sh manifest.txt
```
It will build and install everything into `$HOME/local`.

Note: `pkg-config` uses absolute paths in its manifests so if you relocate the files later, you'll have to fix the `prefix` path in the `local/lib/pkgconfig/*.pc` files.

### Using

Don't forget to clean up any crates built without the `PKG_CONFIG_PATH` override. `cargo` can't check that for you.
```shell
> cargo clean
> export PKG_CONFIG_PATH="$HOME/local"
> cargo build
```

```shell
export LD_LIBRARY_PATH="$HOME/local/lib"
cargo run
```
Note: an older multirust version might clobber the `LD_LIBRARY_PATH` variable, you can test if that is the case like this:
```shell
> LD_LIBRARY_PATH=XtestX multirust run stable sh -c 'echo $LD_LIBRARY_PATH' | grep -q XtestX && echo OK
```
