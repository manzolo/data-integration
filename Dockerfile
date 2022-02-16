FROM openjdk:8-buster
MAINTAINER Andrea Manzi manzolo@libero.it

# Set Environment Variables
ENV PDI_VERSION=9.0 PDI_BUILD=9.0.0.0-423 \
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration \
	KETTLE_HOME=/data-integration

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install prerequisites (xauth, zip, ecc.)
RUN sh -c 'echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" > /etc/apt/sources.list.d/universe.list' \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 3B4FE6ACC0B21F32 \
	&& apt update \
	&& apt install -y xauth wget zip unzip gtk2.0 libxtst-dev libwebkitgtk-1.0-0 lsb-release libcanberra-gtk-module \
	&& apt-get clean
   
# Download PDI
RUN wget --progress=dot:giga https://sourceforge.net/projects/pentaho/files/Pentaho%20${PDI_VERSION}/client-tools/pdi-ce-${PDI_BUILD}.zip \
	&& unzip -q *.zip \
	&& rm -f *.zip \
	&& mkdir /jobs \
	&& mkdir /libs

# Remove universe repository
RUN rm -rf /etc/apt/sources.list.d/universe.list && apt update && apt upgrade -y && apt autoremove  && apt autoclean  && apt clean

# Aditional Drivers
WORKDIR $KETTLE_HOME

RUN wget https://downloads.sourceforge.net/project/jtds/jtds/1.3.1/jtds-1.3.1-dist.zip \
	&& unzip -o jtds-1.3.1-dist.zip -d lib/ \
	&& rm jtds-1.3.1-dist.zip \
	&& wget https://github.com/FirebirdSQL/jaybird/releases/download/v3.0.4/Jaybird-3.0.4-JDK_1.8.zip \
	&& unzip -o Jaybird-3.0.4-JDK_1.8.zip -d lib \
	&& rm -rf lib/docs/ Jaybird-3.0.4-JDK_1.8.zip

# First time run
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
	&& kitchen.sh -file samples/transformations/files/test-job.kjb

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
