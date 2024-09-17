### Base ###
FROM debian:bookworm-slim AS base
LABEL org.opencontainers.image.authors="Seth Parker <c.seth.parker@uky.edu>"
LABEL org.opencontainers.image.title="ci-docker (base)"
LABEL org.opencontainers.image.description="Base system packages"
LABEL org.opencontainers.image.source="https://github.com/educelab/ci-docker"

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV QT_PLUGIN_PATH=/usr/local/Qt-6.7.2/plugins

# Install apt sources
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list \
&& apt-get clean && apt-get -y update
RUN apt-get install --fix-missing --fix-broken -y \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libexpat1-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libicu-dev \
    libncurses-dev \
    libopenblas-dev \
    libusb-1.0-0-dev \
    '^libxcb.*-dev' \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-util-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrender-dev \
    libxt-dev \
    locales \
    ninja-build \
    perl \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-setuptools \
    zlib1g-dev \
&& ln -s /usr/bin/python3 /usr/bin/python \
&& sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen \
&& apt-get -t bookworm-backports install -y cmake \
&& apt-get purge && rm -rf /var/lib/apt/lists/*

# Install Qt6
RUN curl -O -L https://download.qt.io/archive/qt/6.7/6.7.2/single/qt-everywhere-src-6.7.2.tar.xz \
&& tar -xf qt-everywhere-src-6.7.2.tar.xz \
&& cd qt-everywhere-src-6.7.2/ \
&& ./configure -opensource -nomake examples -nomake tests -bundled-xcb-xinput -confirm-license \
&& cmake --build . --parallel \
&& cmake --install . \
&& cd ../ \
&& rm -rf qt-*

# Start an interactive shell
ENTRYPOINT ["/bin/bash", "-c"]

### Dynamic ###
FROM base AS dynamic
LABEL org.opencontainers.image.authors="Seth Parker <c.seth.parker@uky.edu>"
LABEL org.opencontainers.image.title="ci-docker (dynamic)"
LABEL org.opencontainers.image.description="Dynamic vc-deps libraries"
LABEL org.opencontainers.image.source="https://github.com/educelab/ci-docker"

# Install vc-deps (dynamic)
COPY vc-deps/ /vc-deps/
RUN cd /vc-deps/ \
&& mkdir -p build \
&& cd build/ \
&& cmake -GNinja -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DVCDEPS_BUILD_ZLIB=OFF -DCMAKE_INSTALL_PREFIX=/usr .. \
&& ninja \
&& cd / \
&& rm -rf /vc-deps/

# Start an interactive shell
ENTRYPOINT ["/bin/bash", "-c"]

### Static ###
FROM base AS static
LABEL org.opencontainers.image.authors="Seth Parker <c.seth.parker@uky.edu>"
LABEL org.opencontainers.image.title="ci-docker (static)"
LABEL org.opencontainers.image.description="Static vc-deps libraries"
LABEL org.opencontainers.image.source="https://github.com/educelab/ci-docker"

# Install vc-deps (static)
COPY vc-deps/ /vc-deps/
RUN cd /vc-deps/ \
&& mkdir -p build \
&& cd build/ \
&& cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DVCDEPS_BUILD_ZLIB=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. \
&& ninja \
&& cd / \
&& rm -rf /vc-deps/

# Start an interactive shell
ENTRYPOINT ["/bin/bash", "-c"]