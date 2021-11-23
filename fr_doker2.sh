# Clone repository
cd /opt
sudo mkdir fruitnanny
sudo chown pi:pi fruitnanny
git clone https://github.com/ivadim/fruitnanny

# Generate certificates
cd /opt/fruitnanny
openssl req -x509 -sha256 -nodes -days 2650 -newkey rsa:2048 -keyout configuration/ssl/fruitnanny.key -out configuration/ssl/fruitnanny.pem -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=root/CN=`hostname -f`"

# Generate apache passwords
sudo mkdir /etc/nginx/
sudo sh -c "echo -n 'fr:' >> /etc/nginx/.htpasswd"
sudo sh -c "openssl passwd -1 "123" -apr1 >> /etc/nginx/.htpasswd"

# Run the system with notifications
# cd /opt/fruitnanny
# docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d
