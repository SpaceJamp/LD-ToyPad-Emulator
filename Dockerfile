ARG TARGETARCH
ARG TARGETVARIANT

FROM --platform=linux/amd64 node:22-alpine AS base-amd64

# arm 64-bit
# docker seems to default to arm64 without any TARGETVARIANT
FROM --platform=linux/arm64/v8 node:22-alpine AS base-arm64
FROM --platform=linux/arm64/v8 node:22-alpine AS base-arm64v8

# arm 32-bit
# on a 32bit raspberry pi os (bookworm) docker sets TARGETVARIANT to v8
# though logs indicate that it still just pulls arm/v7 base images
FROM --platform=linux/arm/v7 node:18-alpine AS base-armv8
FROM --platform=linux/arm/v7 node:18-alpine AS base-armv7
FROM --platform=linux/arm/v6 node:18-alpine AS base-armv6

FROM base-${TARGETARCH}${TARGETVARIANT} AS final

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

EXPOSE 80

CMD ["node", "index.js"]
