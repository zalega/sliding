# Stage 1: Build the SvelteKit application
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the SvelteKit application
RUN npm run build

# Stage 2: Serve the static files using Nginx
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built SvelteKit output to the Nginx HTML directory
COPY --from=build /app/.svelte-kit/output /usr/share/nginx/html

# Expose port 4000
EXPOSE 4000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]