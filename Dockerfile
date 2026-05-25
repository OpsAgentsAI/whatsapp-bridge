FROM golang:1.26-alpine AS build
RUN apk add --no-cache build-base sqlite-dev git
WORKDIR /src
COPY whatsapp-bridge/ ./
ENV CGO_ENABLED=1
ENV GOFLAGS=-mod=mod
RUN go mod tidy && go build -ldflags='-s -w' -o /whatsapp-bridge

FROM alpine:3.20
RUN apk add --no-cache ca-certificates sqlite-libs tzdata
WORKDIR /data
COPY --from=build /whatsapp-bridge /app/whatsapp-bridge
EXPOSE 8080
VOLUME ["/data"]
CMD ["/app/whatsapp-bridge"]
