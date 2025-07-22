# Use the official Perl image
FROM perl:5.36

# Install Mojolicious
RUN cpanm Mojolicious

# Set the working directory
WORKDIR /usr/src/app

# Copy Mojolicious files to the container
COPY . /usr/src/app

# Expose port 8080
EXPOSE 8080

# Start the Mojolicious app
CMD ["morbo", "my_mojo_app.pl", "-l", "http://*:8080"]