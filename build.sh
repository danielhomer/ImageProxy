#!/usr/bin/env bash

echo "Building Linux Binary..."
docker build -t imageproxy .
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app -e GOOS=linux imageproxy go build -v -o main-linux --ldflags '-extldflags "-lstdc++ -static"'
echo "Build completed - Binary named main-linux";

exit 0


# GOOS=linux GOARCH=amd64 go build  -ldflags '-w -s -extldflags "-static"' -a -installsuffix cgo -o main

# cmake $BASEDIR/opencv -DWITH_JPEG=ON -DWITH_PNG=ON -DWITH_WEBP=ON -DWITH_JASPER=OFF -DWITH_TIFF=OFF -DWITH_OPENEXR=OFF -DWITH_OPENCL=OFF -DBUILD_JPEG=OFF -DBUILD_PNG=OFF -DBUILD_ZLIB=OFF -DENABLE_SSE41=ON -DENABLE_SSE42=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=off -DBUILD_opencv_flann=off -DCMAKE_LIBRARY_PATH=$PREFIX/LIB -DCMAKE_INCLUDE_PATH=$PREFIX/INCLUDE -DCMAKE_INSTALL_PREFIX=$PREFIX
# cmake $BASEDIR/opencv -DWITH_JPEG=ON -DWITH_PNG=ON -DWITH_WEBP=ON -DWITH_JASPER=OFF -DWITH_TIFF=OFF -DWITH_OPENEXR=OFF -DWITH_OPENCL=OFF -DBUILD_JPEG=OFF -DBUILD_PNG=OFF -DBUILD_ZLIB=OFF -DENABLE_SSE41=ON -DENABLE_SSE42=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=off -DBUILD_opencv_flann=off -DCMAKE_LIBRARY_PATH=$PREFIX/LIB -DCMAKE_INCLUDE_PATH=$PREFIX/INCLUDE -DCMAKE_INSTALL_PREFIX=$PREFIX