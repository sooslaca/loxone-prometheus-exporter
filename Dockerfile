FROM golang:1.16 as builder

ENV PROJECT github.com/sooslaca/loxone-prometheus-exporter
ENV GO111MODULE on
WORKDIR /go/src/$PROJECT

COPY go.mod /go/src/$PROJECT
COPY go.sum /go/src/$PROJECT

RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /exporter .

FROM alpine:3.16 as release
COPY --from=builder /exporter /exporter

ENTRYPOINT ["/exporter"]
