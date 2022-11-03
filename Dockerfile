FROM ubuntu:focal

SHELL ["/bin/bash", "-c"]
WORKDIR /app

RUN groupadd -g 999 appuser
RUN useradd -r -u 999 -g appuser appuser
RUN adduser appuser sudo
RUN chown appuser:appuser .
RUN chpasswd <<<"appuser:root"

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:stefansundin/truecrypt
RUN add-apt-repository ppa:unit193/encryption
RUN apt-get install -y \
  dialog \
  truecrypt \
  veracrypt \
  curl \
  python3 \
  python3-pip \
  gunicorn \
  httperf \
  nmap \
  siege \
  ext4magic \
  foremost \
  scalpel

COPY . .

USER appuser
CMD [ "run.sh" ]
