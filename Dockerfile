# Base image
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------------------------
# Base setup
# --------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    software-properties-common gnupg curl wget ca-certificates

RUN add-apt-repository -y universe && \
    add-apt-repository -y multiverse || true

# --------------------------------------------------------------------
# Core tools
# --------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
  build-essential \
  git curl wget ca-certificates gnupg \
  vim nano tmux htop tree \
  unzip xz-utils zip rsync \
  ccache \
  pkg-config make cmake ninja-build \
  flex bison bc \
  device-tree-compiler \
  python3 python3-pip python3-venv \
  python3-serial \
  ripgrep fd-find fzf

# --------------------------------------------------------------------
# Toolchains
# --------------------------------------------------------------------
RUN apt-get install -y \
  gcc-arm-none-eabi binutils-arm-none-eabi \
  gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
  gcc-riscv64-linux-gnu g++-riscv64-linux-gnu

# --------------------------------------------------------------------
# Debug + flash
# --------------------------------------------------------------------
RUN apt-get install -y \
  gdb gdb-multiarch gdbserver \
  openocd stlink-tools dfu-util

# --------------------------------------------------------------------
# QEMU
# --------------------------------------------------------------------
RUN apt-get install -y \
  qemu-system-arm \
  qemu-system-misc \
  qemu-user \
  qemu-user-static \
  qemu-utils

# --------------------------------------------------------------------
# Utilities
# --------------------------------------------------------------------
RUN apt-get install -y \
  minicom screen \
  usbutils udev \
  file \
  net-tools iproute2 \
  tftp-hpa

# --------------------------------------------------------------------
# VS Code server deps (Codespaces auto handles UI)
# --------------------------------------------------------------------
RUN apt-get install -y \
  sudo zsh

# --------------------------------------------------------------------
# Python env
# --------------------------------------------------------------------
RUN python3 -m venv /opt/pyenv && \
    /opt/pyenv/bin/pip install --upgrade pip setuptools wheel && \
    /opt/pyenv/bin/pip install pyserial pyocd

ENV PATH="/opt/pyenv/bin:${PATH}"

# --------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Default shell
CMD ["/bin/bash"]
