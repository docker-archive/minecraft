# Minecraft 1.11 Dockerfile - Example with notes

# Use the offical Debian Docker image with a specified version tag, Jessie, so not all
# versions of Debian images are downloaded.
FROM debian:jessie

MAINTAINER Michael Chiang <mchiang@docker.com>

# Drives which version we are going to install
ENV MINECRAFT_VERSION 1.12.2

# Use APT (Advanced Packaging Tool) built in the Linux distro to download Java, a dependency
# to run Minecraft.
# First, we need to ensure the right repo is available for JRE 8
# Then we update apt
# Then we pull in all of our dependencies, 
# Finally, we download the correct .jar file using wget
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list; \
    apt-get -y update; \
    apt install -y -t jessie-backports openjdk-8-jre-headless ca-certificates-java wget; \
    wget -q https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/minecraft_server.${MINECRAFT_VERSION}.jar;
# We do the above in a single line to reduce the number of layers in our container

# Sets working directory for the CMD instruction (also works for RUN, ENTRYPOINT commands)
# Create mount point, and mark it as holding externally mounted volume
WORKDIR /data
VOLUME /data

# Expose the container's network port: 25565 during runtime.
EXPOSE 25565

#Automatically accept Minecraft EULA, and start Minecraft server
CMD echo eula=true > /data/eula.txt && java -jar /minecraft_server.${MINECRAFT_VERSION}.jar
