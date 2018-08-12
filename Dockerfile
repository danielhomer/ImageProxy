FROM golang:1.10.3

WORKDIR /go/src/app
COPY . .

RUN apt-get update && apt-get install -y \
    autogen \
    autoconf \
    libtool \
    nasm \
    bzip2 \
    patch \
    cmake

RUN go get -d -v ./...
RUN go install -v ./...
RUN /go/src/github.com/discordapp/lilliput/deps/build-deps-linux.sh
