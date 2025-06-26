# Use Ubuntu 25.04 as base image
FROM ubuntu:25.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    curl \
    opam \
    git \
    autoconf \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for opam operations
RUN useradd -m -s /bin/bash ocaml-user

# Switch to non-root user
USER ocaml-user
WORKDIR /home/ocaml-user

# Initialize opam with sandboxing disabled (required for Docker)
RUN opam init --disable-sandboxing -y

# Update opam to get the latest packages
RUN opam update --all

# Add opam environment setup to bashrc for convenient usage
RUN echo 'eval $(opam env)' >> ~/.bashrc

# Set working directory for future operations
WORKDIR /workspace

# Default command
CMD ["/bin/bash"] 