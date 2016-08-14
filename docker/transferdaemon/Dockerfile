FROM jonatanschlag/honeyssh-base:latest
MAINTAINER jonatanschlag

ENV DEBIAN_FRONTEND noninteractive

ADD setup.sh /tmp/setup.sh
RUN mkdir -p /opt/honeyssh-transfer-daemon/ca
ADD root-pub.pem /opt/honeyssh-transfer-daemon/ca/root-pub.pem
 
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

USER pot 

# Define default command.
CMD ["/opt/honeyssh-transfer-daemon/daemon"]

