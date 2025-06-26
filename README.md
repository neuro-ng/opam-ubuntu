# opam-ubuntu: OCaml Base Development Image

[![Build and Publish opam-ubuntu](https://github.com/neuro-ng/opam-ubuntu/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/neuro-ng/opam-ubuntu/actions/workflows/docker-publish.yml)
[![Docker Image](https://ghcr-badge.egpl.dev/neuro-ng/opam-ubuntu/latest_tag?trim=major&label=latest)](https://github.com/neuro-ng/opam-ubuntu/pkgs/container/opam-ubuntu)

A foundational Docker image for OCaml development with Ubuntu 25.04 and opam pre-installed. This serves as a base image for more specialized OCaml environments.

## 🎯 Purpose

This image provides a clean, optimized foundation for OCaml development containers by pre-installing and configuring:

- **Ubuntu 25.04 LTS** - Stable, well-supported base system
- **opam** - OCaml package manager, properly initialized
- **Build tools** - gcc, build-essential, autoconf, pkg-config
- **Development utilities** - curl, git
- **Secure setup** - Non-root user for opam operations

## 🚀 Usage

### As a Base Image

```dockerfile
FROM ghcr.io/neuro-ng/opam-ubuntu:latest

# Install your OCaml compiler version
RUN opam switch create 5.1.0

# Install your packages
RUN opam install dune utop ocaml-lsp-server

# Your application setup...
```

### Direct Usage

```bash
# Pull and run interactively
docker pull ghcr.io/neuro-ng/opam-ubuntu:latest
docker run -it --rm ghcr.io/neuro-ng/opam-ubuntu:latest

# Inside the container
opam switch list-available
opam switch create 5.1.0
eval $(opam env)
```

## 📦 What's Included

### System Packages
- `opam` - OCaml package manager
- `build-essential` - Essential build tools
- `gcc` - GNU Compiler Collection
- `curl` - Command line tool for transferring data
- `git` - Version control system
- `autoconf` - Automatic configure script builder
- `pkg-config` - Package configuration tool

### Pre-configured Setup
- **opam initialized** with sandboxing disabled (Docker-compatible)
- **Non-root user** (`ocaml-user`) for secure operations
- **Updated package lists** for latest versions
- **Shell environment** configured for opam

## 🏗️ Building Locally

```bash
# Clone this repository
git clone https://github.com/neuro-ng/opam-ubuntu.git
cd opam-ubuntu

# Build the image
docker build -t opam-ubuntu .

# Test the build
docker run -it --rm opam-ubuntu opam --version
```

## 🔄 Automated Builds

This repository uses GitHub Actions to automatically build and publish Docker images:

### Build Triggers
- **Push to main branch** - Builds and publishes `latest` tag
- **Version tags** (`v*`) - Creates versioned releases
- **Pull requests** - Builds and tests without publishing
- **Weekly schedule** - Rebuilds with latest Ubuntu security updates

### Multi-Platform Support
Images are built for both `linux/amd64` and `linux/arm64` architectures.

## 📦 Available Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest build from main branch |
| `v1.0.0` | Specific version releases |
| `1.0` | Major.minor version |
| `1` | Major version |
| `main` | Latest build from main branch |

## 🔧 Integration Examples

### Standard OCaml Setup

```dockerfile
FROM ghcr.io/neuro-ng/opam-ubuntu:latest

# Install OCaml and basic tools
RUN opam switch create 5.1.0 && \
    eval $(opam env) && \
    opam install dune utop ocaml-lsp-server merlin ocamlformat

# Set up environment
RUN echo 'eval $(opam env)' >> ~/.bashrc
```

### OxCaml Setup

```dockerfile
FROM ghcr.io/neuro-ng/opam-ubuntu:latest

# Create OxCaml switch
RUN opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default && \
    eval $(opam env --switch 5.2.0+ox) && \
    opam install ocamlformat merlin ocaml-lsp-server utop parallel core_unix

# Configure environment
RUN echo 'eval $(opam env --switch 5.2.0+ox)' >> ~/.bashrc
```

### GitHub Actions Usage

```yaml
name: Build OCaml Project

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/neuro-ng/opam-ubuntu:latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup OCaml
        run: |
          opam switch create 5.1.0
          eval $(opam env)
          opam install . --deps-only -y
      
      - name: Build
        run: |
          eval $(opam env)
          dune build
```

## 🔧 Customization

### Adding System Packages

```dockerfile
FROM ghcr.io/neuro-ng/opam-ubuntu:latest

# Switch to root for system package installation
USER root
RUN apt-get update && apt-get install -y \
    additional-package \
    another-package \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to ocaml-user
USER ocaml-user
```

### Pre-installing Common Packages

```dockerfile
FROM ghcr.io/neuro-ng/opam-ubuntu:latest

# Install commonly used OCaml packages
RUN opam switch create 5.1.0 && \
    eval $(opam env) && \
    opam install \
    dune \
    utop \
    ocaml-lsp-server \
    merlin \
    ocamlformat \
    lwt \
    cmdliner \
    alcotest
```

## 🐛 Troubleshooting

### Common Issues

**opam switch not found**
```bash
# Ensure opam environment is loaded
eval $(opam env)
```

**Permission denied errors**
```bash
# Ensure you're using the ocaml-user, not root
USER ocaml-user
```

**Package installation fails**
```bash
# Update opam first
opam update --all
```

## 🤝 Contributing

Contributions are welcome! This base image should remain minimal and focused on providing a solid foundation.

### Guidelines
- Keep the image minimal - only essential packages
- Maintain Ubuntu 25.04 LTS compatibility
- Ensure multi-platform support (amd64/arm64)
- Test changes with common OCaml workflows

### Development Process

```bash
# Fork and clone
git clone https://github.com/neuro-ng/opam-ubuntu.git
cd opam-ubuntu

# Make changes to Dockerfile
# Test locally
docker build -t opam-ubuntu-test .
docker run -it --rm opam-ubuntu-test opam --version

# Submit PR
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [ox-fast-mcp-build-image](https://github.com/neuro-ng/ox-fast-mcp-build-image) - OxCaml development environment built on this base
- [OCaml](https://ocaml.org/) - The OCaml programming language
- [opam](https://opam.ocaml.org/) - OCaml package manager

## 🙋 Support

- **Issues**: [GitHub Issues](https://github.com/neuro-ng/opam-ubuntu/issues)
- **OCaml Community**: [OCaml Discuss](https://discuss.ocaml.org/)

---

**A solid foundation for OCaml development! 🐪** 