# from 104.196.166.17: bytes=32 time=218ms TTL=118
# We're online
# Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
# Error: A JNI error has occurred, please check your installation and try again
# Exception in thread "main" java.lang.UnsupportedClassVersionError: org/hl7/fhir/igtools/publisher/Publisher has been compiled by a more recent version of the Java Runtime 
# (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
#         at java.lang.ClassLoader.defineClass1(Native Method)
#         at java.lang.Clas



# FROM openjdk:23-jdk
FROM ubuntu:20.04

# https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-20-04
RUN apt update
RUN apt install default-jre -y

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

# https://fshschool.org/docs/sushi/installation/
RUN npm install -g fsh-sushi

# https://rvm.io/rvm/install
# RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
# RUN rvm install 2.5

# https://github.com/rbenv/rbenv
# RUN apt install rbenv -y
# RUN rbenv install rbx-3.82

# https://phoenixnap.com/kb/install-ruby-ubuntu
# RUN apt update
# RUN apt install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev -y
# RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
# ENV PATH="$HOME/.rbenv/bin:$PATH"
# # RUN ~/.rbenv/bin/rbenv init
# # RUN eval "$(rbenv init -)" >> ~/.bashrc
# RUN eval "$(/root/.rbenv/bin/rbenv init - sh)" >> /tmp/.bashrc
# RUN source /tmp/.bashrc
# RUN rbenv -v
# RUN rbenv install rbx-3.82

# RUN apt install curl g++ gcc autoconf automake bison libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev -y
# RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# RUN curl -sSL https://get.rvm.io | bash -s stable
# RUN source ~/.rvm/scripts/rvm
# RUN rvm list known
# RUN rvm install ruby-3

# https://stackoverflow.com/a/40850761
# RUN apt-get install -y openssl
# RUN \curl -L https://get.rvm.io | bash -s stable
# RUN /bin/bash -l -c "rvm requirements"
# RUN /bin/bash -l -c "rvm install ruby-3.1.0"
# RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

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

# Building native extensions. This could take a while...
#0 132.9 ERROR:  Error installing jekyll:
#0 132.9        The last version of sass-embedded (~> 1.54) to support your Ruby & RubyGems was 1.63.6. Try installing it with `gem install sass-embedded -v 1.63.6` and then running the current command again
#0 132.9        sass-embedded requires Ruby version >= 3.1.0. The current ruby version is 2.7.0.0.
#0 166.2 ERROR:  Error installing bundler:
#0 166.2        The last version of bundler (>= 0) to support your Ruby & RubyGems was 2.4.22. Try installing it with `gem install bundler -v 2.4.22`
#0 166.2        bundler requires Ruby version >= 3.0.0. The current ruby version is 2.7.0.0.
# RUN gem install sass-embedded -v 1.63.6
RUN gem install jekyll bundler
# RUN /bin/bash -l -c "gem install jekyll bundler"

WORKDIR /build

# COPY input .
# COPY input-cache ./input-cache

# COPY _gencontinuous.sh _genonce.sh _updatePublisher.sh ig.ini sushi-config.yaml ./

# RUN _updatePublisher.sh

# CMD [ "/build/_genonce.sh" ]
ENTRYPOINT ["/bin/sh", "-c" , "/build/_updatePublisher.sh && /build/_genonce.sh"]

# $ docker run -v $(pwd):/build -w /build  fish-builder 