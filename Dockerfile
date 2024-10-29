# Use PHP with Apache as the base image
FROM php:8.3-cli as web

ENV NVM_VERSION=0.39.7
ENV NODE_VERSION=20.15.1
ENV NVM_DIR=/root/.nvm

# Ubuntu main packages
RUN apt install -y curl

# PHP dependencies
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions mysqli pdo pdo_mysql

# Install BE compiler
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Install FE compiler
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install "${NODE_VERSION}"
RUN . "$NVM_DIR/nvm.sh" && nvm use "v${NODE_VERSION}"
RUN . "$NVM_DIR/nvm.sh" && nvm alias default "v${NODE_VERSION}"
ENV PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Copy the application code
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Frontend bundle
RUN npm ci
RUN npm run build

# Install project dependencies
RUN composer install

# BE test
RUN php artisan test

# App startup and entrypoint
COPY ./start-initialize /usr/local/bin/start-initialize
RUN chmod +x /usr/local/bin/start-initialize
COPY ./start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container
EXPOSE 8123
ENTRYPOINT ["start-container"]
