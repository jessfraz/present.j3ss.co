FROM alpine:latest
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
	&& mv /go/bin/present /usr/bin/present \
	&& mv /go/src/golang.org/x/tools/cmd/present/*/ /usr/src \
	&& apk del .build-deps \
	&& rm -rf /go \
	&& echo "Build complete."

WORKDIR /usr/src

ENTRYPOINT [ "present" ]
