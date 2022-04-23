FROM centos:7

ENV container docker
ENV PATH=/usr/lib:$PATH

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY ./elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
RUN yum update -y && yum install -y --enablerepo=elasticsearch elasticsearch 

ADD elasticsearch.yml /etc/elasticsearch/

RUN mkdir /usr/share/elasticsearch/snapshots &&\
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots
RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data
RUN systemctl enable elasticsearch.service    
USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
