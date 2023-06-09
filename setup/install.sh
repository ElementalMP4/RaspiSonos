echo Install dependencies
apt-get install git maven openjdk-17-jdk -y
mkdir -p /root/RaspiSonos

echo Pull things from git
git clone https://github.com/ElementalMP4/RaspiSonos /var/tmp/RaspiSonos
git clone https://github.com/ElementalMP4/librespot-java /var/tmp/librespot-java

echo Build librespot-java
cd /var/tmp/librespot-java/api
mvn clean package

echo Put librespot-java in the home dir
cp target/librespot-api-1.6.3.jar /root/RaspiSonos/librespot.jar

echo Set up the systemctl unit for librespot-java
cp /var/tmp/RaspiSonos/setup/librespot-java.sh /root/RaspiSonos/
cp /var/tmp/RaspiSonos/setup/LibrespotJava.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl enable LibrespotJava
systemctl start LibrespotJava

echo Build raspisonos-api
cd /var/tmp/RaspiSonos/raspisonos-api
mvn clean package

echo Put raspisonos-api in the home dir
cp target/original-RaspiSonos-API-0.0.1.jar /root/RaspiSonos/raspisonos-api.jar

echo Set up the systemctl unit for raspisonos-api
cp /var/tmp/RaspiSonos/setup/raspisonos-api.sh /root/RaspiSonos/
cp /var/tmp/RaspiSonos/setup/RaspiSonos-API.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl enable RaspiSonos-API
systemctl start RaspiSonos-API

echo Cleanup
sudo rm -rf /var/tmp/RaspiSonos /var/tmp/librespot-java