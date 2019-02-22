#!/bin/bash
cd /tmp/
apt-get update -qq
apt-get install -qq -y git curl wget php7.2-cli zip php7.2-curl php7.2-bz2 php7.2-zip php7.2-xml php7.2-mbstring 
git clone --quiet https://github.com/creationix/nvm.git $HOME/.nvm
~/.nvm/install.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 8
nvm use 8

cd /tmp/

EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/bin --filename=composer --quiet
rm composer-setup.php
