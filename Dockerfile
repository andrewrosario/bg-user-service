FROM ruby:2.5.5
RUN apt-get update -qq && apt-get install -y build-essential nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o- -L https://yarnpkg.com/install.sh | bash

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /bg-user-service
WORKDIR /bg-user-service
COPY Gemfile /bg-user-service/Gemfile
COPY Gemfile.lock /bg-user-service/Gemfile.lock
RUN gem install bundler -v 2.1.4
RUN bundle install
COPY . /bg-user-service
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
