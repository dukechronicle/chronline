FROM ruby:2.1.2-onbuild

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN touch /etc/profile.d/lang.shudo touch /etc/profile.d/lang.sh
RUN chmod 777 /etc/profile.d/lang.sh
RUN echo 'export LANGUAGE="en_US.UTF-8"' >> /etc/profile.d/lang.sh
RUN echo 'export LANG="en_US.UTF-8"' >> /etc/profile.d/lang.sh
RUN echo 'export LC_ALL="en_US.UTF-8"' >> /etc/profile.d/lang.sh

RUN apt-get update --fix-missing
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
# RUN update-locale LANG=en_US.UTF-8

RUN apt-get -y install build-essential libssl-dev
RUN apt-get -y install libmagickwand-dev imagemagick
RUN apt-get -y install libxslt-dev libxml2-dev libcurl4-openssl-dev libpq-dev


### Supervisor

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# Install nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 0.10.33

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Install phantomjs
RUN npm install -g bower phantomjs

# Install required gem
RUN gem install bundler

# Install ImageMagick
RUN apt-get -y install libmagickwand-dev imagemagick

# Other dependencies
RUN apt-get -y install libxslt-dev libxml2-dev libcurl4-openssl-dev libpq-dev

# install JRE
RUN apt-get -y install openjdk-7-jre

RUN echo "source ~/.bashrc" >> ~/.bash_profile
RUN echo "source ~/.profile" >> ~/.bash_profile

# Setup folder permissions
RUN chmod 0777 /usr/src/app/log
RUN mkdir -p /tmp/rails-cache
RUN chmod 0777 /tmp/rails-cache

ENV PORT 80

ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD env | grep _ >> /etc/environment && supervisord -c /etc/supervisor/conf.d/supervisord.conf
