# -----------------------------------------------------------------------------
# docker-minecraft
#
# Builds a basic docker image that can run a Minecraft server.
#
# Authors: Isaac Bythewood, Kepler Sticka-Jones
# Created: Oct 21st, 2013
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is the LTS version of Ubuntu.
FROM ubuntu

# Make sure we don't get notifications we can't answer during building.
ENV DEBIAN_FRONTEND noninteractive

# An annoying error message keeps appearing unless you do this.
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Set up required repositories.
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

# Download and install everything from the repos.
RUN apt-get --yes update; apt-get --yes upgrade
RUN apt-get --yes install openjdk-7-jre-headless

# Create folder that we will be running the Minecraft Server instance in.
RUN mkdir /data
VOLUME ["/data"]

# Download Minecraft Server
ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.7.4/minecraft_server.1.7.4.jar minecraft_server.jar

# Fix all permissions
RUN chmod +x minecraft_server.jar

# 25565 is for Minecraft server, /data contains static files and database /start runs it.
EXPOSE 25565
ENTRYPOINT ["java", "-jar", "minecraft_server.jar", "nogui"]
CMD ["-Xmx1G", "-Xms1G"]
