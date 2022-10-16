FROM fedora:36

RUN dnf install -yq iputils net-tools iproute telnet bind-utils && \
    dnf install -yq hostname && \
    dnf install -yq util-linux tree && \
    dnf install -yq glibc-langpack-en lsof wget && \
    dnf install -yq openssl && \
    dnf install -yq dumb-init && \
    dnf update -yq vim-minimal && \
    dnf install -yq java-1.8.0-openjdk && \
    dnf install -y openssh-clients openssh-server && \
    dnf clean all && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -P ""  && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -P "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -P "" && \
    mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ""  && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN echo "alias ll='ls -al'" >> /etc/bashrc && \
    echo "alias ..='cd ..'" >> /etc/bashrc && \
    echo "alias ...='cd ../..'" >> /etc/bashrc && \
    echo "alias tailf='tail -f'" >> /etc/bashrc && \
    echo "set nu" >> /etc/vimrc

COPY ssh_config /etc/ssh/ssh_config

ENV JAVA_HOME /etc/alternatives/jre_1.8.0_openjdk
ENV HADOOP_HOME /opt/sh/hadoop
ENV HIVE_HOME /opt/sh/hive

ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

RUN wget -q https://downloads.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz  && \
    mkdir -p /opt/sh/hadoop && \
    tar -xf hadoop-3.3.4.tar.gz -C /opt/sh/hadoop --strip-components 1 && \
    rm -rf hadoop-3.3.4.tar.gz && \
    rm -rf /opt/sh/hadoop/share/doc && \
    echo "export JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk" >> /opt/sh/hadoop/etc/hadoop/hadoop-env.sh

RUN wget -q https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz  && \
    mkdir -p /opt/sh/hive && \
    tar -xf apache-hive-3.1.3-bin.tar.gz -C /opt/sh/hive --strip-components 1 && \
    rm -rf apache-hive-3.1.3-bin.tar.gz

COPY core-site.xml /opt/sh/hadoop/etc/hadoop/core-site.xml
COPY hdfs-site.xml /opt/sh/hadoop/etc/hadoop/hdfs-site.xml

COPY start.sh /opt/sh/start.sh

WORKDIR /opt/sh
