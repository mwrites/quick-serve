# Docker Image for Rust Candle

Build and push the image to docker hub
```bash
make run TAG=v1.0.0
```

ssh into container running your image
```bash
huggingface-cli login
cargo run --example mixtral --release  -- --prompt "def print_prime(n): "
```
