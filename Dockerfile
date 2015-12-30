# docker-minecraft
# https://github.com/nmarus/docker-minecraft
# Nicholas Marus <nmarus@gmail.com>

FROM ubuntu:trusty
MAINTAINER Nick Marus <nmarus@gmail.com>

# Setup Container
VOLUME ["/minecraft"]
EXPOSE 25565

# Setup APT
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update, Install Prerequisites, Clean Up APT
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get -y install openjdk-7-jre-headless libmozjs-24-bin wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Get js interpreter
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100

# Get jsAwk
RUN wget -q -O /usr/bin/jsawk https://github.com/micha/jsawk/raw/master/jsawk
RUN chmod +x /usr/bin/jsawk

# Setup container user
RUN useradd -M -s /bin/false minecraft --uid 1000 && \
  mkdir -p /minecraft && \
  chown -R minecraft:minecraft /minecraft && \
  chmod -R 755 /minecraft

#create config files for container startup
COPY start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/start.sh"]
