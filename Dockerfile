# syntax=docker/dockerfile:experimental

ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} AS builder

SHELL ["/bin/bash", "-c"]

ARG HOME_ASSISTANT_VERSION
ARG PIP_VERSION
ARG WHEEL_VERSION
ARG PACKAGES_TO_INSTALL

RUN \
    set -e -o pipefail \
    # Install build dependencies. \
    && homelab install util-linux mount \
    # autoconf build-essential rustc cargo python3-dev \
    # Install dependencies. \
    && homelab install ${PACKAGES_TO_INSTALL:?} \
    && mkdir -p /config /root/ha /root/ha /wheels

WORKDIR /root/ha

# hadolint ignore=DL4006,SC1091
RUN \
    set -e -o pipefail \
    # Set up the virtual environment for building the wheels. \
    && python3 -m venv . \
    && source bin/activate \
    && pip3 install --no-cache-dir --progress-bar off --upgrade pip==${PIP_VERSION:?} \
    && pip3 install --no-cache-dir --progress-bar off --upgrade wheel==${WHEEL_VERSION:?}

# hadolint ignore=DL3001,DL4006,SC1091
RUN --security=insecure \
    set -e -o pipefail \
    # Workaround for the rust/cargo build needed by cryptography due to a \
    # qemu bug. See this issue for more context and this step acts merely \
    # as a workaround. \
    # https://github.com/rust-lang/cargo/issues/8719#issuecomment-932084513 \
    && mkdir -p /root/.cargo && chmod 777 /root/.cargo && mount -t tmpfs none /root/.cargo \
    # Activate the virtual environment for building the wheels. \
    && source bin/activate \
    # Build the wheels. \
    && MAKEFLAGS="-j$(nproc)" pip3 wheel \
        --no-cache-dir \
        --progress-bar off \
        --wheel-dir=/wheels \
        "$(curl \
            --silent \
            --location \
            https://raw.githubusercontent.com/home-assistant/core/${HOME_ASSISTANT_VERSION:?}/homeassistant/package_constraints.txt | \
            grep 'cryptography==')"

FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

SHELL ["/bin/bash", "-c"]

RUN --mount=type=bind,target=/builder,from=builder,source=/wheels \
    set -e -o pipefail \
    && mkdir -p /wheels \
    && cp -rf /builder/* /wheels/

ENV PATH="/opt/bin:${PATH}"
