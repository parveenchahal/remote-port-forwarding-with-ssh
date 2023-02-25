FROM ubuntu
RUN apt update
RUN apt -y install openssh-server
RUN sed -i 's/#GatewayPorts no/GatewayPorts yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
WORKDIR /
COPY startup.sh .
CMD ["bash", "startup.sh"]

