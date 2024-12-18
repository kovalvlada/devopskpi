FROM alpine:latest
WORKDIR /home/optimaserver
COPY ./funca_program .
RUN apk add libstdc++ && apk add libc6-compat
ENTRYPOINT [ "./funca_program" ]