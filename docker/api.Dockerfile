FROM shared as builder

WORKDIR /opt/src/api
RUN go build -o build/ .

FROM golang:1.22.1-alpine3.19 as prod

WORKDIR /opt/bin
COPY --from=builder /opt/src/api/build .

CMD ["api"]
