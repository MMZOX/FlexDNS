# Flexcdn DNS service as a container

This repository contains a Dockerfile and GitHub workflow for building and pushing a container image for the Flexcdn DNS service to a container registry (Docker Hub or GitHub Container Registry) with no modification to the source code.

## Version Information

Version of Flexcdn DNS service used:
https://flexcdn.cn/downloads/cloud-dns/v1.0.1/cloud-dns-linux-amd64-v1.0.1.zip
SHA256: 99060bacc6a30801f576e2f20e6666bb2e832dde23f33e67dd74c6c6993b86d4

## GitHub Workflow

The repository includes a GitHub Actions workflow that builds and pushes the Docker image to a container registry. The workflow can be triggered:

- Automatically on push to main/master branches
- Automatically on pull requests to main/master branches
- Manually via GitHub Actions UI

### Manual Workflow Execution

When running the workflow manually, you can specify:

1. **Registry Choice**: Choose between Docker Hub (`dockerhub`) or GitHub Container Registry (`ghcr`)
2. **Image Name**: The name for the image (without registry prefix)

### Required Secrets

Depending on the registry choice, you'll need to set up the following secrets in your GitHub repository:

#### For Docker Hub
- `DOCKERHUB_USERNAME`: Your Docker Hub username or organization
- `DOCKERHUB_TOKEN`: Your Docker Hub access token

#### For GitHub Container Registry
- No additional secrets required as it uses the built-in `GITHUB_TOKEN`

## Running the Container

Once the image is pushed to the registry, you can run it with:

```bash
docker run -d \
  -e NODE_ID="your-node-id" \
  -e SECRET="your-secret" \
  -e RPC_ENDPOINTS="http://your-rpc-endpoint:8003" \
  -p 53:53/udp \
  -p 53:53/tcp \
  your-registry/flexdns:latest
```