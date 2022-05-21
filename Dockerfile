FROM debian:latest
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget git unzip screen gcc libpcre3-dev libssl-dev make -y
RUN wget https://github.com/gitiy1/nginxbbr/raw/main/zlib-1.2.12.tar.gz && \
    tar -zxvf zlib-1.2.12.tar.gz && \
    wget https://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6 && \
    ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-http_sub_module --with-zlib=../zlib-1.2.12 && \
    make && \
    make install && \
    useradd www && \
    chown -Rf www:www /usr/local/nginx/ && \
    mkdir /var/log/nginx  && \
    echo 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf  && \
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf  && \
    sysctl -p  && \
    echo -e "BBR启动成功！"'
ADD nginx.conf /usr/local/nginx/conf
EXPOSE 80
ENTRYPOINT [ "/usr/local/nginx/sbin/nginx", "-g", "daemon off;" ]