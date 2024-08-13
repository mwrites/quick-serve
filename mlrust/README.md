# Docker Image for Rust Candle

Build and push the image to docker hub
```bash
make run TAG=v1.0.0
```

ssh into container running your image
```bash
huggingface-cli login
cargo run --example quantized --release --features=cuda -- --prompt "Lebesgue's integral is superior to Riemann's because "
```

cudnn (not supported for all models in candle)
```bash
cargo run --example quantized --release --features=cudnn -- --prompt "Lebesgue's integral is superior to Riemann's because "
```

