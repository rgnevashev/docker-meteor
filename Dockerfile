FROM node:argon

# Create user meteor who will run all entrypoint instructions
RUN useradd meteor -G staff -m -s /bin/bash
WORKDIR /home/meteor

# Install git, curl
RUN apt-get update && \
   apt-get install -y git curl jq build-essential && \
   apt-get clean && \
   rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g semver
RUN npm install -g node-gyp

# Install entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Add known_hosts file
# COPY known_hosts .ssh/known_hosts

RUN chown -R meteor:meteor /usr/bin/entrypoint.sh

# Allow node to listen to port 80 even when run by non-root user meteor
# https://github.com/moby/moby/issues/5650
# RUN setcap 'cap_net_bind_service=+ep' /usr/bin/node

EXPOSE 3000

# Execute entrypoint as user meteor
ENTRYPOINT ["su", "-c", "/usr/bin/entrypoint.sh", "meteor"]
CMD []
