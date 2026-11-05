FROM golang:1.26-alpine AS build
ARG GOME_VERSION=v1.0.2
ENV CGO_ENABLED=0 GOBIN=/out
RUN go install \
    "github.com/stingbo/gome/cmd/server@${GOME_VERSION}" \
    "github.com/stingbo/gome/cmd/match@${GOME_VERSION}" \
    "github.com/stingbo/gome/cmd/notice@${GOME_VERSION}" \
    "github.com/stingbo/gome/cmd/client@${GOME_VERSION}"

FROM alpine:3.23
RUN apk add --no-cache jq \
    && adduser -D gome \
    && mkdir -p /app/logs \
    && chown -R gome:gome /app
COPY --from=build /out/ /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/gome-entrypoint
WORKDIR /app
USER gome
EXPOSE 8088
ENTRYPOINT ["/usr/local/bin/gome-entrypoint"]
CMD ["server"]
