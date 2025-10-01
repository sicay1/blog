FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /srv/jekyll

# Install Jekyll and Bundler
RUN gem install jekyll bundler

# Copy Gemfile first
COPY Gemfile ./

# Install gems
RUN bundle install

# Copy the rest of the project
COPY . .

# Expose default Jekyll port
EXPOSE 4000

# Serve the site
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--quiet", "--config", "_config_local.yml"]
