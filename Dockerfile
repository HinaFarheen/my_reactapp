# ======================
# FRONTEND BUILD STAGE
# ======================
FROM node:20 AS frontend-build

WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# ======================
# BACKEND BUILD STAGE
# ======================
FROM node:20 AS backend

WORKDIR /app
COPY server/package*.json ./server/
RUN cd server && npm install

# Copy backend source
COPY server/ ./server/

# Copy frontend build into backend (assumes backend serves static files)
COPY --from=frontend-build /app/client/build ./server/public

# Set working directory to backend
WORKDIR /app/server

# Expose backend port (adjust if needed)
EXPOSE 5000

CMD ["npm", "start"]

