# Base devcontainer with Node and ffmpeg
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install ffmpeg, curl, and Node (Node already present in many base images; this ensures Node 18)
RUN apt-get update && \
    apt-get install -y ffmpeg curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create app dir
WORKDIR /workspace

# Default port used by the server
EXPOSE 8080

CMD [ "bash" ]
