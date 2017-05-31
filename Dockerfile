FROM node:5.2

RUN apt-get update && apt-get install -y xvfb vim
#TODO chain to https://github.com/dockerfile/chrome/
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*


ENV CHROME_BIN=/usr/bin/google-chrome
ENV DISPLAY=:10

RUN wget -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 && chmod a+x /usr/local/bin/gosu


# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
#COPY package.json /usr/src/app/

COPY gosu-entrypoint.sh /

#http://stackoverflow.com/questions/38609531/npm-install-g-gulp-hangs
RUN npm config set proxy false
#RUN npm cache clean

RUN npm install -g grunt-cli
RUN npm install



# Bundle app source
COPY . /usr/src/app
RUN chmod +x /usr/src/app/gruntWithXvfb.sh

ENTRYPOINT ["/gosu-entrypoint.sh", "/usr/src/app/gruntWithXvfb.sh" ]

#https://github.com/jfrazelle/dockerfiles/issues/65#issuecomment-217214671
# run it as docker run --rm --security-opt seccomp:chrome.json pcl

