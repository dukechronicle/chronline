# Setup Locales
sudo touch /etc/profile.d/lang.shudo touch /etc/profile.d/lang.sh
sudo chmod 777 /etc/profile.d/lang.sh
sudo echo 'export LANGUAGE="en_US.UTF-8"' >> /etc/profile.d/lang.sh
sudo echo 'export LANG="en_US.UTF-8"' >> /etc/profile.d/lang.sh
sudo echo 'export LC_ALL="en_US.UTF-8"' >> /etc/profile.d/lang.sh

sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
sudo update-locale LANG=en_US.UTF-8

