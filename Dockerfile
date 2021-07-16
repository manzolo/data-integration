FROM openjdk:8
MAINTAINER Andrea Manzi manzolo@libero.it

# Set Environment Variables
ENV PDI_VERSION=9.0 PDI_BUILD=9.0.0.0-423 \
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration \
	KETTLE_HOME=/data-integration

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install xauth
RUN apt update && apt install -y xauth wget zip unzip gtk2.0 libxtst-dev libwebkitgtk-1.0 lsb-release libcanberra-gtk-module

# Download PDI
RUN wget --progress=dot:giga https://sourceforge.net/projects/pentaho/files/Pentaho%20${PDI_VERSION}/client-tools/pdi-ce-${PDI_BUILD}.zip \
	&& unzip -q *.zip \
	&& rm -f *.zip \
	&& mkdir /jobs \
	&& mkdir /libs

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
