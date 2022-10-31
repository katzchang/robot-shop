FROM golang:1.18

WORKDIR /go/src/app

COPY *.go .

RUN go mod init dispatch && go get
RUN go install

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-dispatch

CMD dispatch
