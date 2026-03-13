# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install serve to run the built application
RUN npm install -g serve

# Copy built application from builder
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Expose port (Cloud Run uses 8080 by default)
EXPOSE 8080

# Start application
ENV PORT=8080
CMD ["serve", "-s", "dist", "-l", "8080"]
