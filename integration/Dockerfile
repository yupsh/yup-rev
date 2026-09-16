# Integration harness: build the yup-rev binary for Linux, then run it inside a
# Debian image (GNU coreutils) so its flags, inputs, and outputs can be checked
# against the real `rev` reference. Invoked by `make integration`.
FROM golang:1.26 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /out/yup-rev .

FROM debian:stable-slim
# rev ships in util-linux, not coreutils; install it for the parity reference.
RUN apt-get update && apt-get install -y --no-install-recommends util-linux && rm -rf /var/lib/apt/lists/*
COPY --from=build /out/yup-rev /usr/local/bin/yup-rev
COPY integration/run.sh /run.sh
ENTRYPOINT ["/bin/sh", "/run.sh"]
