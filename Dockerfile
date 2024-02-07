FROM golang:1.21-alpine AS dev

ENV GOPRIVATE github.com/uniphore,gitlab.com/uniphore
ENV GOFLAGS=-mod=vendor
ENV CGO_ENABLED 0
ENV GOARCH amd64
ENV GOOS linux

WORKDIR /app

COPY cmd cmd
COPY pkg pkg
COPY internal internal

COPY go.mod .
COPY go.sum .
COPY vendor vendor

RUN go build -tags nomsgpack -o api ./cmd/api/main.go

# Production image
FROM alpine AS app

RUN addgroup -S nonroot && adduser -S nonroot -G nonroot -H

WORKDIR /app

COPY --from=dev /app/api .

USER nonroot
