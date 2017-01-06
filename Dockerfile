FROM debian:testing
MAINTAINER Seth Parker <c.seth.parker@uky.edu>

# Install apt sources
COPY vc-deps/ /vc-deps/
RUN apt-get clean && apt-get -y update && apt-get install --fix-missing --fix-broken -y \
    binutils \
    libgc1c2 \
    libgcc-6-dev \
    libobjc-6-dev \
    libobjc4 \
    libstdc++-6-dev \
    bzip2 \
    xz-utils \
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
&& curl -o llvm.tar.xz http://releases.llvm.org/3.9.0/clang+llvm-3.9.0-x86_64-linux-gnu-debian8.tar.xz \
&& tar -xf llvm.tar.xz --strip-components 1 -C /usr/local \
&& ln -s $(which clang) /usr/local/bin/cc \
&& ln -s $(which clang++) /usr/local/bin/c++ \
&& update-alternatives --install /usr/bin/cc cc $(which clang) 100 \
&& update-alternatives --set cc $(which clang) \
&& update-alternatives --install /usr/bin/c++ c++ $(which clang++) 100 \
&& update-alternatives --set c++ $(which clang++) \
&& cd /vc-deps/ \
&& ./build-deps.sh -system -cmake\
&& cd / \
&& rm -rf /vc-deps/ /root/.cache/fetchurl/ /llvm.tar.xz

# Start an interactive shell
CMD ["/bin/bash"]
