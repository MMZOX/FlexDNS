FROM alpine:latest

# Copy the entire cloud-dns directory with all contents
COPY cloud-dns/ /app/cloud-dns/

# Make the binary executable
RUN chmod +x /app/cloud-dns/bin/cloud-dns

WORKDIR /app

# Set environment variables with defaults
ENV NODE_ID=""
ENV SECRET=""
ENV RPC_ENDPOINTS="http://127.0.0.1:8003"

EXPOSE 53
EXPOSE 8003

# Create entrypoint script using single quotes to prevent variable expansion
COPY <<'EOF' /app/entrypoint.sh
#!/bin/sh
cat > /app/cloud-dns/configs/api_dns.yaml << CONFIG
rpc.endpoints: [ "$RPC_ENDPOINTS" ]
nodeId: "$NODE_ID"
secret: "$SECRET"
CONFIG

cat /app/cloud-dns/configs/api_dns.yaml
exec /app/cloud-dns/bin/cloud-dns daemon
EOF

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
