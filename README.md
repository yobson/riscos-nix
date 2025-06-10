# WIP RISC OS gcc cross toolchain flake

It has been tested on x86_64 linux. If you type `nix develop`, you should get a shell with gcc and binutils.

It is a rather rushed port from `gccsdk` and so it is gcc version 4.7.4. But on the bright side, it _should_ build on any linux system you can install nix on!

## Usage
Run `nix develop github:yobson/riscos-nix` and after a log time, you will be dropped into a shell with the cross compiler and a few other tools.
