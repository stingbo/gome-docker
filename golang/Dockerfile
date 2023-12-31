FROM golang:1.21.5
LABEL maintainer="sting_bo@163.com"
ENV DEBIAN_FRONTEND noninteractive

# 修改镜像源
# 如果 /etc/apt/sources.list 不存在，则创建并写入内容
RUN if [ ! -f /etc/apt/sources.list ]; then \
    echo "Creating /etc/apt/sources.list" \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://mirrors.aliyun.com/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    else \
    echo "Modifying existing /etc/apt/sources.list" \
    && sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
    && sed -i "s@security.debian.org/debian-security@mirrors.aliyun.com/debian-security@g" /etc/apt/sources.list; \
    fi

RUN apt-get clean && apt-get update

ENV PROTOBUF_VERSION 3.13.0
ENV PROTOBUF protobuf-all-${PROTOBUF_VERSION}.tar.gz
ENV PROTOBUF_PATH protobuf-${PROTOBUF_VERSION}
COPY $PROTOBUF ./

RUN buildDeps=" \
    " \
    runtimeDeps=" \
        autoconf \
        automake \
        libtool \
        curl \
        make \
        g++ \
        unzip \
        vim \
        curl \
        git \
        supervisor \
    " \
    && apt-get install --assume-yes apt-utils -y $buildDeps $runtimeDeps --no-install-recommends \
    && tar xfz $PROTOBUF \
    && cd $PROTOBUF_PATH && ./configure && make && make install && ldconfig /usr/local/lib \
    && cd ../ && rm -rf $PROTOBUF $PROTOBUF_PATH \
    && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone \
    && rm -r /var/lib/apt/lists/*

WORKDIR $GOPATH/src
ENV GO111MODULE="on"
ENV GOPROXY="https://goproxy.cn"
#COPY ./supervisord.conf /etc/supervisor
#COPY ./start.sh /root/startup.sh
#ENV APP_FILE /root/startup.sh
#CMD $APP_FILE

EXPOSE 8088
