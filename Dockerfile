FROM ocaml/opam:alpine-3.13-ocaml-4.12 as build
RUN opam update

RUN opam pin add luv.0.5.10 https://github.com/aantron/luv/releases/download/0.5.10/luv-0.5.10.tar.gz -n
RUN opam pin add luv_unix.0.5.10 https://github.com/aantron/luv/releases/download/0.5.10/luv-0.5.10.tar.gz -n

# While waiting for the release:
RUN opam pin add hvsock.3.0.0 "https://github.com/djs55/ocaml-hvsock.git#release.3.0.0" -n
RUN opam pin add protocol-9p.2.0.1 "https://github.com/djs55/ocaml-9p.git" -n
RUN opam pin add protocol-9p-unix.2.0.1 "https://github.com/djs55/ocaml-9p.git" -n

ADD . /home/opam/vpnkit
RUN opam pin add vpnkit /home/opam/vpnkit -n
RUN opam depext vpnkit -y

RUN opam install vpnkit -y

FROM alpine:latest
COPY --from=build /home/opam/.opam/4.12/bin/vpnkit /vpnkit
