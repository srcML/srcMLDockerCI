FROM opensuse/leap:15.2
LABEL org.srcml.email="srcmldev@gmail.com" \
      org.srcml.url="srcml.org" \
      org.srcml.distro="opensuse" \
      org.srcml.osversion="15.2" \
      org.srcml.boost="1.64.0"

# Update and install dependencies
RUN zypper --non-interactive install --no-recommends \
    curl \
    tar \
    gzip \
    gcc-c++ \
    make \
    ninja \
    which \
    java-headless \
    libxml2-devel \
    libxslt-devel \
    libarchive-devel \
    libcurl-devel \
    libopenssl-devel \
    zip \
    bzip2 \
    man \
    rpm-build

# Download and install a newer binary version of cmake
RUN curl -L https://cmake.org/files/v3.20/cmake-3.20.4-linux-$(uname -m).tar.gz | tar xz --strip-components=1 -C /usr/local/

# Download and install only needed boost files
RUN curl -L http://www.sdml.cs.kent.edu/build/srcML-1.0.0-Boost.tar.gz | \
    tar xz -C /usr/local/include

# Download, build, and install antlr from source
# libantlr packages for this platform do not build with -fPIC
# Modifications:
# * Download new config.guess and config.sub to handle newer architectures
# * Compile with -fPIC by changing line 59 in scripts/cxx.sh.in
# * Remove initialization of EOF_CHAR on line 475 of CharScanner.hpp
# * Add initialization of EOF_CHAR on line 102 of CharScanner.cpp
# * Insert #include <string.h> in CharScanner.hpp
ARG ANTLR_SRC_URL=http://www.antlr2.org/download/antlr-2.7.7.tar.gz
RUN curl -L $ANTLR_SRC_URL | tar xz -C / \
    && cd /antlr-2.7.7 \
    && curl -L http://savannah.gnu.org/cgi-bin/viewcvs/*checkout*/config/config/config.guess > scripts/config.guess \
    && curl -L http://savannah.gnu.org/cgi-bin/viewcvs/*checkout*/config/config/config.sub > scripts/config.sub \
    && sed -i -e '59s/-pipe/-pipe -fPIC/' scripts/cxx.sh.in \
    && sed -i -e '474s/= EOF/;/' lib/cpp/antlr/CharScanner.hpp \
    && sed -i -e '102s/EOF_CHAR;/EOF_CHAR = std::char_traits<char>::eof();/' lib/cpp/src/CharScanner.cpp \
    && sed -i -e '1 i\#include <string.h>' lib/cpp/antlr/CharScanner.hpp \
    && ./configure --disable-examples && make install \
    && cp antlr.jar /usr/share/java/. \
    && rm -fR /antlr-2.7.7
# # install does not setup classpath
ENV CLASSPATH /usr/share/java/antlr.jar
