# ---- Stage 1: Build ----
# Use a specific version of a standard image
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
# Use --ci for cleaner installs
RUN npm ci

COPY . .

# ---- Stage 2: Production ----
# Use a minimal, secure base image
FROM node:18-alpine

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /home/appuser/app

# Copy only necessary artifacts from the builder stage
COPY --from=builder /app .

# Set ownership of the app files
RUN chown -R appuser:appgroup .

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 8080

# Add a health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --tries=1 -O /dev/null http://localhost:8080/health || exit 1

# Command to run the application
CMD [ "node", "app.js" ]