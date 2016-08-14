FROM jonatanschlag/honeyssh-base:latest
MAINTAINER jonatanschlag

ENV DEBIAN_FRONTEND noninteractive

ADD setup.sh /tmp/setup.sh
RUN mkdir -p mkdir -p /opt/securehoney/keys
ADD honeykey /opt/securehoney/keys/honeykey
ADD honeykey.pub /opt/securehoney/keys/honeykey.pub
 
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

USER pot 

# Define default command.
CMD ["/opt/securehoney/sshpot"]

