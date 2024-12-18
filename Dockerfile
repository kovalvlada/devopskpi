# Stage 1: Build environment
FROM alpine:latest AS build
RUN apk add --no-cache \
    build-base \
    automake \
    autoconf \
    libtool

WORKDIR /home/optima
COPY . .
RUN autoreconf --install
RUN ./configure
RUN make

# Stage 2: Runtime environment
FROM alpine:latest
RUN apk add --no-cache \
    libstdc++ \
    libc6-compat

WORKDIR /app
COPY --from=build /home/optima/funca_program /app/funca_program

EXPOSE 8081
ENTRYPOINT ["/app/funca_program"]