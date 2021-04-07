FROM debian:stable-slim
LABEL name="cardano-node-explorer"
LABEL maintainer="https://github.com/hawkingnetwork"

ARG NODEJS_MAJOR_VERSION=12
ARG RELEASE=1.5.0

ENV DEBIAN_FRONTEND=nonintercative

WORKDIR /

RUN apt-get update && apt-get install curl -y &&\
  curl --proto '=https' --tlsv1.2 -sSf -L https://deb.nodesource.com/setup_${NODEJS_MAJOR_VERSION}.x | bash - &&\
  apt-get install nodejs git -y

RUN curl --proto '=https' --tlsv1.2 -sSf -L https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
  apt-get update && apt-get install gcc g++ make gnupg2 yarn -y

# Clone source code
RUN git clone https://github.com/input-output-hk/cardano-explorer-app.git /app
WORKDIR /app
RUN git fetch --all --recurse-submodules --tags
RUN git tag
RUN git checkout tags/${RELEASE}

# Creating non root user cardano
RUN useradd -m cardano

# # Add permissions
RUN chown -R cardano:cardano /app
RUN chmod g+s /app

# Image clean-up
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean



COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chown cardano:cardano /entrypoint.sh
# Switch user
USER cardano:cardano

EXPOSE 4000

CMD ["/entrypoint.sh"]