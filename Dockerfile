# Use an official Node.js runtime as a parent image
# We are using Node.js 20-alpine for a good balance of features and image size.
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
# This step leverages Docker's build cache.
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application source code into the container
COPY . .

# Make port 3001 available to the world outside this container
EXPOSE 3001

# Command to run the application
# This will execute the "dev" script from your package.json
CMD ["npm", "run", "dev"]
