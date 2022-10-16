FROM ttbb/base:jdk17-ssh

ENV HADOOP_HOME /opt/sh/hadoop
ENV HIVE_HOME /opt/sh/hive

RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz  && \
    mkdir -p /opt/sh/hadoop && \
    tar -xf hadoop-3.3.4.tar.gz -C /opt/sh/hadoop --strip-components 1 && \
    rm -rf hadoop-3.3.4.tar.gz && \
    rm -rf /opt/sh/hadoop/share/doc

RUN https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz  && \
    mkdir -p /opt/sh/hive && \
    tar -xf apache-hive-3.1.3-bin.tar.gz -C /opt/sh/hive --strip-components 1 && \
    rm -rf apache-hive-3.1.3-bin.tar.gz

COPY core-site.xml /opt/sh/hadoop/etc/hadoop/core-site.xml
COPY hdfs-site.xml /opt/sh/hadoop/etc/hadoop/hdfs-site.xml
