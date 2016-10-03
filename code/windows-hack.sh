LDFLAGS_STATIC='-linkmode external'
# Cgo -H windows is incompatible with -linkmode external.
if [ "$(go env GOOS)" == 'windows' ]; then
	LDFLAGS_STATIC=''
fi
