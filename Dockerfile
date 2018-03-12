FROM centos:7

MAINTAINER Rahul rui <rahulrui@ideaculture.com>

WORKDIR /app

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV TOMCAT_VERSION 8.0.50

#生成缓存
RUN yum update -y && yum makecache
#时区设置
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#安装中文支持   
RUN yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common 
#配置显示中文 
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 
#设置环境变量 
ENV LC_ALL zh_CN.utf8 
RUN echo "export LC_ALL=zh_CN.utf8" >> /etc/profile
#可以先卸载一些不需要的软件 这样build出来的镜像会更小
RUN yum clean all

COPY jdk-8u161-linux-x64.tar.gz /tmp
RUN tar -zxf /tmp/jdk-8u161-linux-x64.tar.gz -C /app && \
rm -rf /tmp/jdk-8u161-linux-x64.tar.gz

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /app/jdk1.8.0_161

RUN yum install wget -y
# Get Tomcat
RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzf /tmp/tomcat.tgz -C /app && \
mv /app/apache-tomcat-${TOMCAT_VERSION} /app/tomcat && \
rm /tmp/tomcat.tgz && \
rm -rf /app/tomcat/webapps/examples && \
rm -rf /app/tomcat/webapps/docs && \
rm -rf /app/tomcat/webapps/ROOT

# Add admin/admin user
#ADD tomcat-users.xml /app/tomcat/conf/

ENV CATALINA_HOME /app/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/app/tomcat/webapps"


# Launch Tomcat
CMD ["/app/tomcat/bin/catalina.sh", "run"]
