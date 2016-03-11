FROM debian:8
MAINTAINER Seth Parker <c.seth.parker@uky.edu>

# Install apt sources
COPY vc-deps/ /vc-deps/
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
&& rm -rf /var/lib/apt/lists/* \
&& update-alternatives --set c++ /usr/bin/clang++ \
&& update-alternatives --set cc /usr/bin/clang \
&& cd /vc-deps/ \
&& ./build-deps.sh -system -cmake\
&& cd / \
&& rm -rf /vc-deps/ /root/.cache/fetchurl/

# Start an interactive shell
CMD ["/bin/bash"]
