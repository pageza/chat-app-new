# .devcontainer/Dockerfile
# Use the official Golang image to create a build artifact.
# This is a multi-stage build. It will first compile your application
# and then copy the compiled binary into a new Docker image.

# Stage 1: Building the code
FROM golang:1.18 AS builder

# Create a directory for the app.
WORKDIR /app

# Copy the go.mod and go.sum file.
# This will download and cache your dependencies before building
# your application source code, which can speed up subsequent builds.
COPY go.mod go.sum ./

# Download all dependencies.
RUN go mod download

# Copy the rest of the application's code.
COPY . .

# Build the application.
RUN CGO_ENABLED=0 GOOS=linux go build -o /main .

# Stage 2: Create the runtime image
FROM alpine:latest

# Install ca-certificates in case you need HTTPS
RUN apk add --no-cache ca-certificates

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the binary from the builder stage.
COPY --from=builder /main .

# This port matches the port exposed by the Go application.
EXPOSE 8080

# Run the binary.
CMD ["/main"]
