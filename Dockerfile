# Use official Node.js image for build stage
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy rest of the app and build
COPY . .
RUN npm run build

# Production stage: serve with Nginx
FROM nginx:stable-alpine

# Remove default site
RUN rm -rf /usr/share/nginx/html/*

# Copy build from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy optional custom Nginx config (if exists)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
