FROM node:carbon

# Create user meteor who will run all entrypoint instructions
RUN useradd meteor -G staff -m -s /bin/bash
WORKDIR /home/meteor

# Install git, curl
RUN apt-get update && \
   apt-get install -y git curl jq build-essential && \
   apt-get install -y gconf-service libasound2 libatk1.0-0 \
   libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 \
   libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 \
   libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
   libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
   libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates \
   fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
   apt-get clean && \
   rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g semver
RUN npm install -g node-gyp

# used for control chromium processes
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Install entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

RUN chown -R meteor:meteor /usr/bin/entrypoint.sh

EXPOSE 3000

# Execute entrypoint as user meteor
ENTRYPOINT ["dumb-init", "--", "su", "-c", "/usr/bin/entrypoint.sh", "meteor"]
CMD []
