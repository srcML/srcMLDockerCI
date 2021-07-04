FROM fedora:33
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="fedora" \
      org.srcml.osversion="33" \
      org.srcml.boost="1.69.0"

ENV PLATFORM=fedora:latest

# Install dependencies
RUN dnf install -y \
    tar \
    gcc-c++ \
    make \
    cmake \
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

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include
