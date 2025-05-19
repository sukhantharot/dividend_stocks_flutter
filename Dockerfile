# Stage 1 - Build the flutter web app
FROM dart:stable AS build

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Get Flutter dependencies
WORKDIR /app
COPY . .

# ✅ เพิ่ม .env file ที่นี่
RUN echo "API_BASE_URL=https://dividend-stocks-production.up.railway.app" > .env

RUN flutter pub get
RUN flutter build web --release

# Stage 2 - Serve app with nginx
FROM nginx:stable-alpine

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter build to nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 8889

# Start nginx
CMD ["nginx", "-g", "daemon off;"]