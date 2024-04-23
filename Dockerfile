FROM ubuntu:20.04

# Install Java
# https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-20-04
RUN apt update
RUN apt install default-jre -y

# Install NodeJS
# https://stackoverflow.com/a/57546198
ENV NODE_VERSION=20.12.2
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Install Sushi
# https://fshschool.org/docs/sushi/installation/
RUN npm install -g fsh-sushi

# Install Ruby
# https://stackoverflow.com/a/49578968
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends --no-install-suggests curl bzip2 build-essential libssl-dev libreadline-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/sstephenson/ruby-build/archive/v20240416.tar.gz | tar -zxvf - -C /tmp/ && \
  cd /tmp/ruby-build-* && ./install.sh && cd / && \
  ruby-build -v 3.1.0 /usr/local && rm -rfv /tmp/ruby-build-*

# https://jekyllrb.com/docs/installation/ubuntu/
# RUN apt-get install ruby-full build-essential zlib1g-dev -y
ENV GEM_HOME="$HOME/gems"
ENV PATH="$HOME/gems/bin:$PATH"

# Install Jekyll
#
# Building native extensions. This could take a while...
#0 132.9 ERROR:  Error installing jekyll:
#0 132.9        The last version of sass-embedded (~> 1.54) to support your Ruby & RubyGems was 1.63.6. Try installing it with `gem install sass-embedded -v 1.63.6` and then running the current command again
#0 132.9        sass-embedded requires Ruby version >= 3.1.0. The current ruby version is 2.7.0.0.
#0 166.2 ERROR:  Error installing bundler:
#0 166.2        The last version of bundler (>= 0) to support your Ruby & RubyGems was 2.4.22. Try installing it with `gem install bundler -v 2.4.22`
#0 166.2        bundler requires Ruby version >= 3.0.0. The current ruby version is 2.7.0.0.
# RUN gem install sass-embedded -v 1.63.6
RUN gem install jekyll bundler

WORKDIR /build

ENTRYPOINT ["/bin/sh", "-c" , "/build/_updatePublisher.sh && /build/_genonce.sh"]

# $ docker run -v $(pwd):/build -w /build  fish-builder 