# Home Lab Home Assistant Wheels Cryptography Docker Image

[![Build](https://github.com/TuxdudeHomeLab/docker-image-home-assistant-wheels-cryptography/actions/workflows/build.yml/badge.svg)](https://github.com/TuxdudeHomeLab/docker-image-home-assistant-wheels-cryptography/actions/workflows/build.yml) [![Lint](https://github.com/TuxdudeHomeLab/docker-image-home-assistant-wheels-cryptography/actions/workflows/lint.yml/badge.svg)](https://github.com/TuxdudeHomeLab/docker-image-home-assistant-wheels-cryptography/actions/workflows/lint.yml)

The docker image used for building the Python cryptography package wheels
used by the
[`Home Assistant`](https://home-assistant.io) core package in
[`TuxdudeHomeLab/docker-image-home-assistant`](https://github.com/TuxdudeHomeLab/docker-image-home-assistant)
in Tuxdude's Home Lab setup.

The image itself is only directly consumed by this child docker image
[`TuxdudeHomeLab/docker-image-home-assistant-wheels`](https://github.com/TuxdudeHomeLab/docker-image-home-assistant-wheels)
which builds all the python wheels used by Home Assistant.

The reason to build just the cryptography wheel (and its dependencies)
in this repo/docker image is because of its fragility and flakiness
while building for `linux/arm/v7` docker platform due to a bug in qemu.
