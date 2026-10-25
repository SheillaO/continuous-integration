# Use the smallest official Node.js runtime image based on Alpine Linux
FROM node:24-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy dependency manifests first to leverage Docker's layer caching
COPY package*.json ./

# Install dependencies securely (only production packages to keep it tiny)
RUN npm ci --only=production

# Copy the rest of your application code
COPY . .

# Inform Docker that the container listens on port 3000 at runtime
EXPOSE 3000

# Run the server
CMD ["node", "server.js"]

