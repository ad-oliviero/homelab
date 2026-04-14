FROM ubuntu:24.04

RUN apt update
RUN apt install -y git software-properties-common
RUN rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:lemonade-team/stable
RUN apt install -y lemonade-server

EXPOSE 8000

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
