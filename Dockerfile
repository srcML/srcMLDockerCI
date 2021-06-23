FROM centos:8
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="centos" \
      org.srcml.osversion="8" \
      org.srcml.boost="1.69.0" \
      org.srcml.cmake="3.14.1"

# Update and install dependencies
RUN dnf install -y 'dnf-command(config-manager)' && dnf config-manager --set-enabled powertools && dnf -y module enable javapackages-tools && dnf upgrade -y && dnf install -y \
    which \
    zip \
    unzip \
    gcc-c++ \
    make \
    cmake \
    ninja-build \
    antlr \
    antlr-C++ \
    libxml2-devel \
    libxslt-devel \
    libarchive-devel \
    openssl-devel \
    libcurl-devel \
    bzip2 \
    man \
    rpm-build \
    && dnf remove -y 'dnf-command(config-manager)' \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include
