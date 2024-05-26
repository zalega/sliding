# Use the official Node.js image as the base image
FROM node:18.17.1-alpine

# Set the working directory in the container
WORKDIR /app

COPY package*.json ./
RUN npm install
# Copy the application files into the working directory
COPY . .

# Install the application dependencies
RUN npm run build
RUN npm install pm2 -g

# Define the entry point for the container

EXPOSE 3000

CMD [ "pm2-runtime", "start", "pm2.json" ]