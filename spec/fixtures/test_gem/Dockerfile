FROM ruby:2.7.2-alpine3.12
MAINTAINER Ronan Duddy <dev@ronanduddy.xyz>

ENV BUILD_PACKAGES build-base less git

RUN apk update && \
    apk upgrade && \
    apk add --no-cache $BUILD_PACKAGES

WORKDIR /usr/src/app

COPY . .
RUN bundle install
