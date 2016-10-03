if [ "$IAMSTATIC" == "true" ] && [ "$(go env GOHOSTOS)" == "linux" ] && [ "$DOCKER_EXPERIMENTAL" ]; then
	if  [ "${GOOS}/${GOARCH}" == "darwin/amd64" ]; then
		export CGO_ENABLED=1
		export CC=o64-clang
		export LDFLAGS='-linkmode external -s'
		export LDFLAGS_STATIC_DOCKER='-extld='${CC}
	else
		export BUILDFLAGS=( "${BUILDFLAGS[@]/pkcs11 /}" ) # we cannot dlopen in pkcs11 in a static binary
	fi
fi
