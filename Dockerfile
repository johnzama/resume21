# Use the official Nginx image as a base
FROM nginx:alpine

# Copy the HTML file to the default Nginx public directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]

