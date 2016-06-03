FROM ruby:alpine

MAINTAINER ettober@gmail.com

RUN mkdir -p /app
WORKDIR /app

RUN apk update && apk upgrade
RUN apk add ruby-bundler curl-dev ruby-dev build-base ruby-io-console

RUN rm -rf /var/cache/apk/*

COPY Gemfile* ./

ENV PUMA_PORT 9292
RUN bundle install --jobs 20 --retry 5

EXPOSE 9292

ENTRYPOINT ["bundle", "exec"]

CMD ["puma", "-p", "9292"]
