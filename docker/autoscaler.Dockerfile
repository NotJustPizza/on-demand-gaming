FROM shared as builder

WORKDIR /opt/src/autoscaler
RUN go build -o build/ .

FROM golang:1.21.4-alpine3.18 as prod

WORKDIR /opt/bin
COPY --from=builder /opt/src/autoscaler/build .

CMD ["autoscaler"]
