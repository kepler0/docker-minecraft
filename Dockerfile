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
RUN apt-get --yes install curl openjdk-7-jre-headless supervisor pwgen



# Load in all of our config files.
ADD ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD ./supervisor/conf.d/minecraft.conf /etc/supervisor/conf.d/minecraft.conf
ADD ./scripts/start /start


# Fix all permissions
RUN chmod +x /start


# 80 is for nginx web, /data contains static files and database /start runs it.
EXPOSE 25565
VOLUME ["/data"]
CMD ["/start"]

