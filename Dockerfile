FROM fedora:32
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="fedora" \
      org.srcml.osversion="32" \
      org.srcml.boost="1.69.0"

ENV PLATFORM=fedora:latest

# Install dependencies
RUN dnf install -y \
    tar \
    gcc-c++ \
    make \
    ninja-build \
    antlr \
    antlr-C++ \
    libxml2-devel \
    libxslt-devel \
    libarchive-devel \
    libcurl-devel \
    openssl-devel \
    bzip2 \
    cpio \
    zip \
    rpm-build \
    rpmlint \
    man

# Download and install cmake
RUN curl -L https://cmake.org/files/v3.20/cmake-3.20.4-linux-$(uname -m).tar.gz | tar xz --strip-components=1 -C /usr/

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include
