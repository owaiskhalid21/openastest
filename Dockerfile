FROM ubuntu:18.04

RUN mkdir myapp
COPY . /myapp
# jDK installation
RUN tar -zxvf myapp/jdk-8u261-linux-x64.tar.gz
RUN apt-get update && apt-get -y install sudo 
RUN apt-get -y install vim
RUN mkdir /usr/lib/java
RUN mv jdk1.8.0_261/ /usr/lib/java
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/java/jdk1.8.0_261/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/java/jdk1.8.0_261/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/java/jdk1.8.0_261/bin/javaws" 1 
RUN echo $'export JAVA_HOME=/usr/lib/java/jdk1.8.0_261 \n\
export PATH="$PATH:$JAVA_HOME/bin"' > ~/.bashrc
# service installation and starting
RUN cp /myapp/bin/openas2.d /etc/init.d/
RUN chmod 750 /etc/init.d/openas2.d
RUN apt-get update
RUN cp /myapp/bin/openas2.service /etc/systemd/system/
RUN chmod 744 /myapp/bin/start-openas2.sh
RUN chmod 644 /etc/systemd/system/openas2.service
CMD ["systemctl daemon-reload"]
CMD ["systemctl enable openas2.service"] 
CMD ["systemctl start openas2.service"]
CMD ["systemctl status openas2.service"]
CMD ["ExecStart=/root/myapp/bin/start-openas2.sh"]
CMD ["bash /root/myapp/bin/start-openas2.sh"]
CMD ["bash service openas2.d start"]
CMD service openas2.d start && tail -F /var/log/mysql/error.log


EXPOSE 9085

