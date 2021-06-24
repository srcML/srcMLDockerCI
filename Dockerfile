FROM centos:7
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="centos" \
      org.srcml.osversion="7" \
      org.srcml.boost="1.69.0"

# Update and install dependencies
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum install -y \
    which \
    zip \
    unzip \
    gcc-c++ \
    make \
    ninja-build \
    antlr \
    antlr-C++ \
    libxml2 \
    libxml2-devel \
    libxslt-devel \
    libarchive-devel \
    openssl-devel \
    libcurl-devel \
    bzip2 \
    man \
    rpm-build \
    && yum clean all \
    && rm -rf /var/cache/yum

# Download and install a newer binary version of cmake
RUN curl -L https://cmake.org/files/v3.20/cmake-3.20.4-linux-$(uname -m).tar.gz | tar xz --strip-components=1 -C /usr/local/

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include
