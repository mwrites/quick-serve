# syntax=docker/dockerfile:1

# Base image with CUDA
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS base

# Stage for system dependencies
FROM base AS system-deps
ARG APTPKGS="pkg-config libssl-dev zsh wget tmux tldr nvtop vim neovim curl rsync net-tools less iputils-ping 7zip zip unzip lld lshw ffmpeg gcc openssh-server openssh-client git git-lfs python3-pip python3-venv"
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update -y && \
    apt-get install -y --no-install-recommends $APTPKGS && \
    apt-get clean

# Stage for Rust installation
FROM system-deps AS rust-install
COPY --from=mcr.microsoft.com/devcontainers/rust:0-1-bullseye /usr/local/cargo /usr/local/cargo
COPY --from=mcr.microsoft.com/devcontainers/rust:0-1-bullseye /usr/local/rustup /usr/local/rustup
ENV PATH="/usr/local/cargo/bin:${PATH}" \
    RUSTUP_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo"
RUN rustup component add rustfmt clippy && \
    rustup default stable

# Stage for Python dependencies
FROM rust-install AS python-deps
COPY requirements.txt /tmp/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --no-cache-dir -r /tmp/requirements.txt

# Stage for Candle repository
FROM python-deps AS candle
RUN git clone https://github.com/huggingface/candle.git /candle

# Final stage
FROM candle AS final
COPY start-ssh-only.sh /start.sh
RUN chmod +x /start.sh

# Verification and environment setup
RUN echo "Verifying installed components:" && \
    echo "Rust:" && rustc --version && cargo --version && \
    echo "Rust components:" && rustup component list --installed && \
    echo "Python:" && python3 --version && pip3 list && \
    echo "Candle repository:" && ls -la /candle && \
    echo "System packages:" && dpkg-query -l | grep -E "(cuda|cudnn|gcc|git|python3|ssh)" && \
    echo "Current user:" && whoami

ENV PATH="/usr/local/cuda/bin:/usr/local/cargo/bin:${PATH}" \
    RUSTUP_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo" \
    RUSTFLAGS="-C link-arg=-fuse-ld=lld" \
    CUDNN_PATH="/usr/lib/x86_64-linux-gnu/libcudnn.so" \
    LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

RUN echo "Verifying environment variables:" && \
    echo "PATH: $PATH" && \
    echo "RUSTUP_HOME: $RUSTUP_HOME" && \
    echo "CARGO_HOME: $CARGO_HOME" && \
    echo "RUSTFLAGS: $RUSTFLAGS" && \
    echo "CUDNN_PATH: $CUDNN_PATH" && \
    echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

WORKDIR /candle

CMD [ "/start.sh" ]
