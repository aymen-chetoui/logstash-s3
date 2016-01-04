# Logstash in a Ubuntu container

FROM    ubuntu:14.04

MAINTAINER      aymen.chetoui@gmail.com

RUN     apt-get update \
        && apt-get install wget -y \
        && wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz \
        && mkdir /opt/jdk \
        && mv jdk-8u60-linux-x64.tar.gz /opt/jdk/ \
        && cd /opt/jdk/ && tar -xzvf /opt/jdk/jdk-8u60-linux-x64.tar.gz \
        && update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_60/bin/java 10000 \
        && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_60/bin/javac 10000 \
        && cd / && apt-get update \
        && apt-get update \
        && wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add - \
        && apt-get update \
        && echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list \
        && apt-get update \
        && apt-get install logstash -y \
        && apt-get install python -y \
        && apt-get install python-setuptools -y \
        && easy_install Jinja2 \
        && apt-get clean

RUN     cd /opt/logstash/ \
        && ln -s /lib/x86_64-linux-gnu/libcrypt.so.1 /usr/lib/x86_64-linux-gnu/libcrypt.so \
        && cd /

RUN     mkdir /jinja \
        && mkdir /jinja/templates

ADD     logstash_template.conf /jinja/templates/

ADD     jinja_generator.py /jinja/

CMD     python /jinja/jinja_generator.py \
        && mv logstash.conf /etc/logstash/conf.d \
        && /opt/logstash/bin/logstash -f  /etc/logstash/conf.d/logstash.conf
