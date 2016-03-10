FROM debian:8
MAINTAINER Seth Parker <c.seth.parker@uky.edu>

# Install apt sources
RUN apt-get update && apt-get install -y \
	build-essential \
	clang \
	curl \
	git \
	libbz2-dev \
	libgl1-mesa-dev \
	libusb-1.0-0-dev \
	libqt5opengl5-dev \
	libxkbcommon-dev \
	libXt-dev \
	ninja-build \
	pkg-config \
	qtbase5-dev \
 && rm -rf /var/lib/apt/lists/*

 # Manually build other sources
 RUN mkdir -p /usr/src/things \
    && curl -SL http://example.com/big.tar.xz \
    | tar -xJC /usr/src/things \
    && make -C /usr/src/things all
