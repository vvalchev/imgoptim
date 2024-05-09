# Build ECT - here is why
#https://www.olegkikin.com/png_optimizers/
FROM alpine as ect-builder

WORKDIR /tmp

RUN apk add --no-cache alpine-sdk cmake
RUN git clone --recursive --depth=1 --branch "v0.9.5" https://github.com/fhanau/Efficient-Compression-Tool.git
RUN cd Efficient-Compression-Tool && \
    mkdir build && \
    cd build && \
    cmake ../src && \
    make && \
    strip ect

# build the main image
FROM alpine

# install jpegoptim
RUN apk add --no-cache jpegoptim optipng pngcrush pngquant oxipng libstdc++
COPY --from=ect-builder /tmp/Efficient-Compression-Tool/build/ect /usr/bin/ect
