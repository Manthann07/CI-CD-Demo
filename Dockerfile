# Use Node 20 LTS base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the app
COPY . .

# Expose port your app runs on
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
