# Use the official WordPress image as the base image
FROM wordpress:5.8-php7.4-apache
USER root

# Set environment variables
ENV IONCUBE_VERSION=10.4.5

# Update and install required packages
RUN apt-get update && apt-get install -y wget unzip && \
# Download ionCube
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip && \
unzip ioncube_loaders_lin_x86-64.zip && \
# Copy ionCube to the PHP extension directory
cp ioncube/ioncube_loader_lin_7.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ && \
# Clean up
rm -rf ioncube_loaders_lin_x86-64.zip ioncube && \
apt-get remove -y wget unzip && apt-get autoremove -y && apt-get clean

# Enable ionCube in the PHP configuration
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube_loader_lin_7.4.so" > /usr/local/etc/php/conf.d/00-ioncube.ini

# Restart Apache to apply changes
RUN service apache2 restart

# Expose the default HTTP port
EXPOSE 80
