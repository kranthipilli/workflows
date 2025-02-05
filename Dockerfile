# Use Node.js for building the frontend
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all frontend files
COPY . .

# Build the frontend (Vite or React)
RUN npm run build

# Use Nginx to serve the frontend
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Remove default nginx static files
RUN rm -rf ./*

# Copy built frontend from builder stage
COPY --from=builder /app/dist ./

# Expose port 80 for serving frontend
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
