# Use an official Ruby runtime as a parent image
FROM ruby:3.3.1

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        nodejs \
        yarn \
        postgresql \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy .ruby-version before running Bundler
COPY .ruby-version ./

# Copy Gemfile, Gemfile.lock, and Gemfile.modules
COPY Gemfile Gemfile.lock Gemfile.modules ./
# Copy the necessary modules directory
COPY modules/auth_plugins /app/modules/auth_plugins
COPY modules/auth_plugins /app/modules/auth_saml
COPY modules/openid_connect /app/modules/openid_connect
# Copy the entire modules directory
COPY modules /app/modules

# Install bundler and dependencies
RUN gem install bundler:2.5.10 && \
    bundle _2.5.10_ install

# Copy application code
COPY . .
RUN bundle exec rake db:create
# Migrate the database
RUN bundle exec rake db:migrate
# To populate the initial data
RUN bundle exec rake db:seed

RUN bundle exec rake assets:precompile
# Expose port 3000 (adjust as needed)
EXPOSE 3000

# Command to start Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
