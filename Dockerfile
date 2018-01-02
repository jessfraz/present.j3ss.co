FROM alpine:latest as builder
MAINTAINER Jessica Frazelle <jess@linux.com>

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN	apk add --no-cache \
	ca-certificates

COPY . /usr/src

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		go \
		git \
		gcc \
		libc-dev \
		libgcc \
	&& go get golang.org/x/tools/cmd/present \
	&& cd /go/src/golang.org/x/tools \
	&& CGO_ENABLED=0 go build -a -tags netgo -ldflags '-extldflags "-static"' -o /usr/bin/present ./cmd/present \
	&& ldd /usr/bin/present \
	&& mv /go/src/golang.org/x/tools/cmd/present/*/ /usr/src \
	&& apk del .build-deps \
	&& rm -rf /go \
	&& echo "Build complete."

FROM scratch

COPY --from=builder /usr/bin/present /usr/bin/present
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs
COPY --from=builder /usr/src /usr/src

WORKDIR /usr/src

ENTRYPOINT [ "present" ]
CMD [ "--help" ]
