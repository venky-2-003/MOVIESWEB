# Use the official Nginx image as base
FROM nginx:alpine

# Set working directory inside container
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy your website files to Nginx html directory
COPY . .

# Expose port 80 to access website
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
