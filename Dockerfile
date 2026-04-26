ARG RUBY_VERSION=4.0
FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    libssl-dev \
    pkg-config \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -N

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY docker/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
