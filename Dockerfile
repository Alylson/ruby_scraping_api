FROM ruby:3.3.1-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    dos2unix \
    build-essential git \
    libvips \
    pkg-config \
    curl \
    libsqlite3-0 \
    libmariadb-dev-compat \
    libmariadb-dev \
    wget \
    gnupg2 && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qq && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY Gemfile ./
RUN bundle install

COPY . .

RUN chmod +x ./bin/*

EXPOSE 3003

CMD ["bash", "-c", "rm -f /app/tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
