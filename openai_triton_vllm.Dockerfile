# Stage 1: Build the Rust project
FROM rust:1.76.0-slim AS builder

# Install dependencies including protobuf-compiler
RUN apt-get update && apt-get install -y \
    libssl-dev \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Build the Rust project
RUN cargo build --release

# Stage 2: Create a minimal image with the built executable
FROM ubuntu:22.04

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the executable and configuration files from the builder stage
COPY --from=builder /usr/src/app/target/release/openai_trtllm /app/bin/
COPY --from=builder /usr/src/app/templates/history_template_llama3.liquid /app/templates/

# # Set the command to run the executable
# CMD ["/app/bin/openai_trtllm", "--history-template-file", "/app/templates/history_template_llama3.liquid"]