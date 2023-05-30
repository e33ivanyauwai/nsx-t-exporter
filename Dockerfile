FROM golang:1.18-alpine as build
LABEL maintainer "Cloud PaaS Infra"

RUN apk --no-cache add ca-certificates \
 && apk --no-cache add --virtual build-deps git build-base

COPY ./ /go/src/github.com/sapcc/github.com/sapcc/nsx-t-exporter
WORKDIR /go/src/github.com/sapcc/github.com/sapcc/nsx-t-exporter

RUN go get \
 && go test ./... \
 && go build -o /bin/start

FROM alpine:3.18

RUN apk --no-cache add ca-certificates \
 && addgroup nsxt \
 && adduser -S -G nsxt nsxt
USER nsxt
COPY --from=build /bin/start /bin/start
ENV LISTEN_PORT=9191
EXPOSE 9191
ENTRYPOINT [ "/bin/start" ]
