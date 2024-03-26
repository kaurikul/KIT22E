FROM debian:latest

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-gd \
    php-json \
    php-mbstring \
    php-xml \
    php-mysql \
    php-zip \
    php-curl \
    libapache2-mod-php \
    curl \
    unzip

# Enable Apache mods
RUN a2enmod php7.4
RUN a2enmod rewrite

# Set the Apache server name to localhost
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Download and install Drupal
RUN curl -sSL https://www.drupal.org/download-latest/tar.gz -o drupal.tar.gz \
    && tar -xzvf drupal.tar.gz --strip-components=1 -C /var/www/html/ \
    && rm drupal.tar.gz

# Change ownership of the Drupal folder for Apache
RUN chown -R www-data:www-data /var/www/html/

# Cleanup to reduce Docker image size
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose port 80
EXPOSE 80

# Set the working directory to the Apache web root
WORKDIR /var/www/html/

# Configure the container to run Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
