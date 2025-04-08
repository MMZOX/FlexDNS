FROM alpine:latest

RUN mkdir -p /app/cloud-dns/configs

# Copy the binary from the host
COPY cloud-dns /app/

# Make the binary executable
RUN chmod +x /app/cloud-dns/bin/cloud-dns

WORKDIR /app

# Set environment variables
ENV NODE_ID=""
ENV SECRET=""
ENV RPC_ENDPOINTS="http://127.0.0.1:8003"

EXPOSE 53
EXPOSE 8003

# Create entrypoint script
COPY <<EOF /app/entrypoint.sh
#!/bin/sh

# Create config file dynamically
cat > /app/cloud-dns/configs/api_dns.yaml << CONFIG
rpc.endpoints: [ "${RPC_ENDPOINTS}" ]
nodeId: "${NODE_ID}"
secret: "${SECRET}"
CONFIG

# Run the application in daemon mode
exec /app/cloud-dns/bin/cloud-dns daemon
EOF

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
