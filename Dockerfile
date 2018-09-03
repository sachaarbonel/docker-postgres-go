
# Multi-stage build setup (https://docs.docker.com/develop/develop-images/multistage-build/)

# Stage 1 (to create a "build" image, ~850MB)
FROM golang:1.9.7 AS builder
RUN go version

COPY . /go/src/github.com/Sach97/docker-helloworld-go/
WORKDIR /go/src/github.com/Sach97/docker-helloworld-go/
RUN set -x && \
    go get github.com/golang/dep/cmd/dep && \
    dep ensure -v

RUN go build -a -o app .

# Stage 2 (to create a downsized "container executable", ~7MB)

# If you need SSL certificates for HTTPS, replace `FROM SCRATCH` with:
#
#   FROM alpine:3.7
#   RUN apk --no-cache add ca-certificates
#
FROM scratch
WORKDIR /root/
COPY --from=builder /go/src/github.com/Sach97/docker-helloworld-go/app .

#EXPOSE 8123
ENTRYPOINT ["./app"]