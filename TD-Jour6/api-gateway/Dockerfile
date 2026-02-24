# ── Build stage ──────────────────────────────────────────────────────────────
FROM node:20 AS builder
WORKDIR /app
COPY package.json ./
# Install deps and clean npm cache in the same layer
RUN npm install && npm cache clean --force

# ── Production stage ──────────────────────────────────────────────────────────
FROM node:20-alpine
WORKDIR /app
RUN addgroup -S cloudshop && adduser -S cloudshop -G cloudshop
# Copy pre-built node_modules from builder (avoids re-installing)
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=cloudshop:cloudshop . .
USER cloudshop
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "server.js"]