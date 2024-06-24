# Stage 1: Build
FROM node:14 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install the dependencies specified in package.json
RUN npm install

# Copy the rest of the application source code to the working directory
COPY . .

# Stage 2: Production
FROM node:14-alpine

# Copy the rest of the application source code from the build stage
COPY --from=build /usr/src/app .

# Expose the port the application will run on
EXPOSE 3000

# Define the command to run the application
CMD ["node", "index.js"]
