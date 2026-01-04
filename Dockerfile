FROM --platform=linux/amd64 node:22-alpine AS base-amd64
FROM --platform=linux/arm64 node:22-alpine AS base-arm64
FROM --platform=linux/arm/v7 node:20-alpine AS base-armv7
FROM --platform=linux/arm/v6 node:18-alpine AS base-armv6
FROM node:alpine AS base-default

ARG TARGETARCH
ARG TARGETVARIANT
FROM base-${TARGETARCH}${TARGETVARIANT:-default} AS final

ENV CXXFLAGS="-std=c++17"
# Install native build tools
RUN apk update && apk add --no-cache \
    build-base \
    python3 \
    libusb-dev \
    linux-headers \
    eudev-dev \
    g++ \
    make \
    py3-pip \
    py3-setuptools

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
