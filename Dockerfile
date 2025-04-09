FROM alpine:latest

# Install nftables and dependencies
RUN apk add --no-cache nftables

# Copy the entire cloud-dns directory with all contents
COPY cloud-dns/ /app/cloud-dns/

# Make the binary executable
RUN chmod +x /app/cloud-dns/bin/cloud-dns

WORKDIR /app

# Set environment variables with defaults
ENV NODE_ID=""
ENV RPC_ENDPOINTS="http://127.0.0.1:8003"
# Use build arg for secret to avoid warning
ARG SECRET=""
ENV SECRET=${SECRET}

EXPOSE 53/udp
EXPOSE 53/tcp

# Create entrypoint script using single quotes to prevent variable expansion
COPY <<'EOF' /app/entrypoint.sh
#!/bin/sh

# Setup nftables rules for UDP port 53
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; }
nft add rule inet filter input udp dport 53 accept

# Generate configuration file from environment variables
cat > /app/cloud-dns/configs/api_dns.yaml << CONFIG
rpc.endpoints: [ "$RPC_ENDPOINTS" ]
nodeId: "$NODE_ID"
secret: "$SECRET"
CONFIG

# Start the cloud-dns service
echo "Starting cloud-dns service..."
echo "running with config:"
cat /app/cloud-dns/configs/api_dns.yaml
exec /app/cloud-dns/bin/cloud-dns daemon
EOF

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
