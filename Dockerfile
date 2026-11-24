# --- STAGE 1: Build & Dependency Isolation ---
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY app/package*.json ./
RUN npm install --only=production

COPY app/ ./

# --- STAGE 2: Hardened Production Runtime ---
FROM node:20-alpine

ENV NODE_ENV=production
WORKDIR /app

# Security hardening: Drop root privileges
USER node

COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=builder /usr/src/app/server.js ./server.js

EXPOSE 3000

CMD ["node", "server.js"]
