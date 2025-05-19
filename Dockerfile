# Use the official Flutter image
FROM debian:latest AS build-env

# Install necessary build dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# Clone the Flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run Flutter doctor
RUN flutter doctor -v
RUN flutter channel stable
RUN flutter upgrade

# Copy files to container and build
WORKDIR /app
COPY . .

# Create a temporary .env file with Railway variables
RUN echo "API_BASE_URL=https://dividend-stocks-production.up.railway.app" > .env

# Build Flutter web
RUN flutter build web

# Stage 2 - Create the run-time image
FROM busybox:latest
COPY --from=build-env /app/build/web /www

EXPOSE 8889

CMD ["busybox", "httpd", "-f", "-v", "-p", "8889", "-h", "/www"] 