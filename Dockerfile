FROM ghcr.io/clacky-ai/rails-base-template:latest

COPY --chown=ruby:ruby Gemfile* ./
# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"
RUN bundle install

COPY --chown=ruby:ruby package.json package-lock.json ./
RUN npm install

ENV NODE_ENV="production" \
  PATH="${PATH}:/home/ruby/.local/bin:/node_modules/.bin:/usr/local/bundle/bin" \
  USER="ruby" \
  PORT="3000"

WORKDIR /rails
# Copy application code
COPY --chown=ruby:ruby . .

# Fix line endings for bin files (Windows CRLF to Unix LF) and make them executable
USER root
RUN find ./bin -type f -exec sed -i 's/\r$//' {} \; && \
    chmod +x ./bin/*
USER ruby

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Override the base image ENTRYPOINT
ENTRYPOINT []

# Start the server by default, this can be overwritten at runtime
EXPOSE ${PORT}
CMD ["./bin/rails", "server"]