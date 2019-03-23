FROM ubuntu:bionic
MAINTAINER PMMP Team <team@pmmp.io>

EXPOSE 19132/tcp
EXPOSE 19132/udp

RUN apt-get update && apt-get --no-install-recommends -y install \
	sudo \
	ca-certificates \
	jq \
	curl \
	unzip

RUN groupadd -g 1000 pocketmine && useradd -r -d /pocketmine -p "" -u 1000 -m -g pocketmine -g sudo pocketmine

WORKDIR /pocketmine
ADD bin /pocketmine/bin
ADD PocketMine-MP.phar /pocketmine/PocketMine-MP.phar
ADD start.sh /pocketmine/start.sh
RUN chmod +x bin/php7/bin/php start.sh

RUN curl -o /install-plugin https://raw.githubusercontent.com/SOF3/PocketMine-Docker/master/install-plugin.sh
RUN chmod +x /install-plugin

RUN chown -R pocketmine:pocketmine . /install-plugin

USER pocketmine

# RUN sudo mkdir /data /plugins
VOLUME ["/data", "/plugins"]
# CMD ./start.sh --no-wizard --enable-ansi --data=/data --plugins=/plugins
CMD bash -c 'sudo chown 1000 /data /plugins -R && ./start.sh --no-wizard --enable-ansi --data=/data --plugins=/plugins'
