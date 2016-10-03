FROM debian:testing
MAINTAINER Seth Parker <c.seth.parker@uky.edu>

# Install apt sources
COPY vc-deps/ /vc-deps/
RUN apt-get clean && apt-get -y update && apt-get install --fix-missing --fix-broken -y \
    bzip2 \
    clang-3.8 \
    clang-format-3.8 \
    curl \
    git \
    libbz2-dev \
    libgl1-mesa-dev \
    libusb-1.0-0-dev \
    libqt5opengl5-dev \
    libxkbcommon-dev \
    libxt-dev \
    make \
    ncurses-dev \
    ninja-build \
    pkg-config \
    python3 \
    qtbase5-dev \
&& rm -rf /var/lib/apt/lists/* \
&& update-alternatives --install /usr/bin/cc cc /usr/bin/clang-3.8 100 \
&& update-alternatives --set cc /usr/bin/clang-3.8 \
&& ln -s /usr/bin/clang-3.8 /usr/bin/clang \
&& update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-3.8 100 \
&& update-alternatives --set c++ /usr/bin/clang++-3.8 \
&& ln -s /usr/bin/clang++-3.8 /usr/bin/clang++ \
&& ln -s /usr/bin/clang-format-3.8 /usr/bin/clang-format \
&& cd /vc-deps/ \
&& ./build-deps.sh -system -cmake\
&& cd / \
&& rm -rf /vc-deps/ /root/.cache/fetchurl/

# Start an interactive shell
CMD ["/bin/bash"]
