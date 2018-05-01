FROM debian:stretch-slim
MAINTAINER Seth Parker <c.seth.parker@uky.edu>

# Install apt sources
COPY vc-deps/ /vc-deps/
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
&& apt-get clean && apt-get -y update
RUN apt-get install --fix-missing --fix-broken -y \
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
    qt5-default \
    qtbase5-dev \
&& apt-get -t stretch-backports install -y cmake \
&& apt-get purge && rm -rf /var/lib/apt/lists/*
RUN curl -o llvm.tar.xz http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-x86_64-linux-gnu-debian8.tar.xz \
&& tar -xf llvm.tar.xz --strip-components 1 -C /usr/local \
&& ln -s $(which clang) /usr/local/bin/cc \
&& ln -s $(which clang++) /usr/local/bin/c++ \
&& update-alternatives --install /usr/bin/cc cc $(which clang) 100 \
&& update-alternatives --set cc $(which clang) \
&& update-alternatives --install /usr/bin/c++ c++ $(which clang++) 100 \
&& update-alternatives --set c++ $(which clang++)
RUN cd /vc-deps/ \
&& mkdir -p build \
&& cd build/ \
&& cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. \
&& ninja \
&& cd / \
&& rm -rf /vc-deps/ /llvm.tar.xz

# Start an interactive shell
CMD ["/bin/bash"]
