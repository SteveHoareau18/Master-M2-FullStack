FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o orders-api .
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
RUN addgroup -S cloudshop && adduser -S cloudshop -G cloudshop  
COPY --from=builder --chown=cloudshop:cloudshop /app/orders-api .
USER cloudshop
EXPOSE 8083

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8083/health || exit 1

CMD ["./orders-api"]