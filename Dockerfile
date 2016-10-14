FROM buildpack-deps:vivid

# fix broken default apt mirrors
RUN sed -i "s/httpredir.debian.org/`curl -s -D - http://httpredir.debian.org/demo/debian/ | awk '/^Link:/ { print $2 }' | sed -e 's@<http://\(.*\)/debian/>;@\1@g'`/" /etc/apt/sources.list

# install deps
RUN apt-get clean && apt-get -qq update && apt-get -qq install -y \
        build-essential \
        qt5-default \
        libboost-all-dev \
        libfftw3-dev \
        libavutil-ffmpeg-dev \
        libavresample-ffmpeg-dev \
        libavcodec-ffmpeg-dev \
        libavformat-ffmpeg-dev && \
    apt-get clean

# install libKeyFinder
RUN cd /tmp && \
    git clone https://github.com/ibsh/libKeyFinder.git && \
    cd libKeyFinder && \
    qmake LibKeyFinder.pro && \
    make && \
    make install && \
    rm -rf /tmp/libKeyFinder

# install keyfinder-cli
RUN cd /tmp && \
    git clone https://github.com/EvanPurkhiser/keyfinder-cli.git && \
    cd keyfinder-cli && \
    make && make install

WORKDIR /workspace
ENTRYPOINT ['keyfinder-cli']

