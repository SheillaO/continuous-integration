# --- Stage 1: Base Environment ---
FROM node:24-alpine AS base
WORKDIR /app
COPY package*.json ./

# --- Stage 2: Development & Testing ---
FROM base AS tester
# Install ALL dependencies (including devDependencies like ESLint/Jest)
RUN npm install 
COPY . .
# Force Docker to run your checks. If these fail, the build stops!
RUN npm run lint
RUN npm test

# --- Stage 3: Clean Production Image ---
FROM base AS runner
# Install ONLY production dependencies to keep the image tiny (~50MB)
RUN npm ci --only=production
# Copy only the clean app code from the tester stage
COPY --from=tester /app . 
EXPOSE 3000
CMD ["node", "server.js"]
