FROM golang:1.21.4-alpine3.18

WORKDIR /opt/src
COPY src .

RUN go mod download
