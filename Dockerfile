FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
	git \
	vim \
	wget \
	unzip \
	screen \
	sudo \
	sed \
	make \
	libconfig-yaml-perl \
	python-serial \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -d /home/espbuilder -m espbuilder && \
	usermod -a -G dialout,staff espbuilder && \
	mkdir -p /etc/sudoers.d && \
	echo "espbuilder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/espbuilder && \
	chmod 0440 /etc/sudoers.d/espbuilder

USER espbuilder

RUN cd /home/espbuilder \
	&& git clone https://github.com/thunderace/Esp8266-Arduino-Makefile.git \
	&& cd Esp8266-Arduino-Makefile \
	&& bash -c "./install-x86_64-pc-linux-gnu.sh" \
	&& cd libraries \
	&& git clone https://github.com/adafruit/Adafruit_NeoPixel.git \
	&& cd /tmp \
	&& git clone https://github.com/knolleary/pubsubclient.git \
	&& mv pubsubclient/src /home/espbuilder/Esp8266-Arduino-Makefile/libraries/PubSubClient \
	&& rm -rf /tmp/pubsubclient

CMD (cd /home/espbuilder/ && /bin/bash)