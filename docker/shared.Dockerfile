FROM golang:1.22.1-alpine3.19

WORKDIR /opt/src
COPY src .

RUN go mod download
