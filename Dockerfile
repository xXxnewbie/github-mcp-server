FROM golang:1.24.3-alpine AS build
ARG VERSION="dev"

# Set the working directory
WORKDIR /build

# Install git
RUN apk add --no-cache git

# Copy the source code
COPY . .

# Build the server
RUN CGO_ENABLED=0 go build -ldflags="-s -w -X main.version=${VERSION}" -o /bin/github-mcp-server cmd/github-mcp-server/main.go

# Make a stage to run the app
FROM alpine:3.19
# Set the working directory
WORKDIR /server
# Copy the binary from the build stage
COPY --from=build /bin/github-mcp-server .
# Command to run the server
CMD ["./github-mcp-server", "stdio"]
