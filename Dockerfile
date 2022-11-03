FROM ubuntu:focal

RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
RUN mkdir -p /app
RUN chown appuser:appuser /app

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

RUN pip3 install argparse datetime

COPY . /app
WORKDIR /app

USER appuser
CMD [ "bash", "run.sh" ]
