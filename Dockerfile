FROM ubuntu:18.04
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="ubuntu" \
      org.srcml.osversion="18.04" \
      org.srcml.boost="1.69.0"

# Avoid prompts for timezone
ENV TZ=US/Michigan
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    zip \
    g++ \
    make \
    ninja-build \
    antlr \
    libantlr-dev \
    libxml2-dev \
    libxml2-utils \
    libxslt1-dev \
    libarchive-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    cpio \
    man \
    file \
    dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

# Build cmake from source for both amd64 and arm64 platforms
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5.tar.gz | tar xz && \
    cd cmake-3.20.5 && ./bootstrap --generator=Ninja

RUN cd cmake-3.20.5 && ninja && ninja install && cd .. && rm -fR cmake-3.20.5 && cmake --version

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include

# Allow man pages to be installed
RUN sed -i '/path-exclude=\/usr\/share\/man\/*/c\#path-exclude=\/usr\/share\/man\/*' /etc/dpkg/dpkg.cfg.d/excludes
