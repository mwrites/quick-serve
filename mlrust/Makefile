# Build, tag, and push the Docker image
build:
	docker buildx build --platform linux/x86_64 -t bla .
	docker tag bla dockerdefine/bla:$(TAG) && \
	docker push dockerdefine/bla:$(TAG)

verify:
	#shows compute cap (recommend >8)
	nvidia-smi --query-gpu=compute_cap --format=csv
	#shows Cuda compiler driver version
	nvcc --version

format:
	cargo fmt --quiet

lint:
	cargo clippy --quiet

test:
	cargo test --quiet

clean:
	cargo clean

run:
	cargo run 

all: format lint test run
