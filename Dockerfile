# Use the official Go image as a builder stage.
FROM golang:1.21.3 AS builder

# Set the working directory inside the container.
WORKDIR /app

# Copy the Go Modules manifests and download the dependencies.
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application's code.
COPY . .

# Build the application.
# The '.' at the end specifies the current directory (which is /app) as the build context.
RUN CGO_ENABLED=0 GOOS=linux go build -o /main ./cmd/server

# Use a small image for the runtime stage.
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Copy the binary from the builder stage.
COPY --from=builder /app/main .

# This is the runtime command for the container.
CMD ["/main"]
