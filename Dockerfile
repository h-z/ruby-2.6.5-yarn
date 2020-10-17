FROM ruby:2.6.5
LABEL maintainer="hz@muszaki.info"

RUN apt-get update -qq && \
    apt-get install -y -qq sqlite3 libsqlite3-dev apt-transport-https && \
    apt-get remove yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y -qq nodejs yarn
RUN printf "install: -N\nupdate: -N\n" >> ~/.gemrc

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler && bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5

COPY package.json /myapp/package.json
COPY yarn.lock /myapp/yarn.lock

RUN yarn install
