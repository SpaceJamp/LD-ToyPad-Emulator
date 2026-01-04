FROM node:22-bullseye-slim

# THEORETICALLY WITH THIS YOU COULD ADD BEHVIOUR THAT DEPENDS ON THE PLATFORM
ARG TARGETPLATFORM


ENV CXXFLAGS="-std=c++17"
# Install native build tools
RUN apt-get update && apt-get install -y \
    python3 \
    g++ \
    make \
    libusb-1.0-0-dev \
    libudev-dev 

WORKDIR /app

# Copy package and install deps
COPY package*.json ./
RUN npm install

# Copy all source
COPY server ./server
COPY index.js ./index.js

VOLUME ["/app/server/json"]

# App listens on port 80 by default
EXPOSE 80

CMD ["node", "index.js"]
