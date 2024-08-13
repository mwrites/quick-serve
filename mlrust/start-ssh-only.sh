#!/bin/bash

echo "pod started"

# Set environment variables for Rust, CUDNN, and CUDA
export PATH="/usr/local/cuda/bin:/usr/local/cargo/bin:${PATH}"
export RUSTUP_HOME="/usr/local/rustup"
export CARGO_HOME="/usr/local/cargo"
export RUSTFLAGS="-C link-arg=-fuse-ld=lld"
export CUDNN_PATH="/usr/lib/x86_64-linux-gnu/libcudnn.so"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Verify environment variables
echo "Verifying environment variables:"
echo "PATH: $PATH"
echo "RUSTUP_HOME: $RUSTUP_HOME"
echo "CARGO_HOME: $CARGO_HOME"
echo "RUSTFLAGS: $RUSTFLAGS"
echo "CUDNN_PATH: $CUDNN_PATH"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

sleep infinity
