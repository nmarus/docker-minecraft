FROM ubuntu:trusty
MAINTAINER Nick Marus <nmarus@gmail.com>
ENV dockername=minecraft

#setup container
VOLUME ["/minecraft"]
EXPOSE 25565

#update, install prerequisites, clean up apt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get -y install openjdk-7-jre-headless libmozjs-24-bin wget && \
  apt-get clean

#get js interpreter
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

#get jsawk
RUN wget -q -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk

#setup container user
RUN useradd -M -s /bin/false minecraft --uid 1000 && \
  mkdir -p /minecraft && \
  chown -R minecraft:minecraft /minecraft && \
  chmod -R 755 /minecraft

#create config files for container startup
COPY start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/start.sh"]
