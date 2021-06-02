#!/bin/bash
sudo apt-get install jq
# clone
$ git clone https://github.com/bugaevc/wl-clipboard.git
$ cd wl-clipboard

# build
$ meson build
$ cd build
$ ninja

# install
$ sudo ninja install

