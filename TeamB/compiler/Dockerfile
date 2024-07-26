# Use latest stable channel SDK.
FROM dart:stable-sdk AS build
# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/server.dart -o bin/server

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
