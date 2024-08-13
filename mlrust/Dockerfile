FROM --platform=linux/x86_64 ubuntu:22.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as base
FROM mcr.microsoft.com/devcontainers/rust:0-1-bullseye AS deps
# Combine the images
FROM base

ENV PATH="/usr/local/cuda/bin:/usr/local/cargo/bin:${PATH}" \
    RUSTUP_HOME="/usr/local/rustup" \
    CARGO_HOME="/usr/local/cargo" \
    RUSTFLAGS="-C link-arg=-fuse-ld=lld"

# Copy Rust from deps
COPY --from=deps /usr/local/cargo /usr/local/cargo
COPY --from=deps /usr/local/rustup /usr/local/rustup
RUN rustup default stable

# Basic stuff
ARG APTPKGS="zsh wget tmux tldr nvtop vim neovim curl rsync net-tools less iputils-ping 7zip zip unzip lld lshw ffmpeg gcc openssh-server openssh-client git git-lfs python3-pip python3-venv"

# Install useful command line utility software
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends $APTPKGS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cuda
ENV PATH="/usr/local/cuda/bin:${PATH}"


COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

RUN git clone https://github.com/huggingface/candle.git && cd candle

# Runpod
COPY start-ssh-only.sh /start.sh
RUN chmod +x /start.sh && cat /start.sh 
WORKDIR /workspace
CMD [ "/start.sh" ]
