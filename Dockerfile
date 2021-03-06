FROM ubuntu:xenial

RUN apt-get update ; \
    apt-get dist-upgrade -y ; \
    apt-get install -y wget libgoogle-perftools-dev vim-tiny unzip; \
    apt-get build-dep nginx -y;\
    wget http://nginx.org/download/nginx-1.11.1.tar.gz; \
    tar zxvf nginx-1.11.1.tar.gz ;\
    cd nginx-1.11.1; \
    ./configure --prefix=/usr/ --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/tmp/nginx/client_body --http-proxy-temp-path=/tmp/nginx/proxy --http-fastcgi-temp-path=/tmp/nginx/fastcgi --http-uwsgi-temp-path=/tmp/nginx/uwsgi --http-scgi-temp-path=/tmp/nginx/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-file-aio --with-ipv6 --with-http_ssl_module  --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-pcre --with-pcre-jit --with-google_perftools_module --with-debug --with-threads  --with-http_v2_module --with-cc-opt=" -Ofast " ;\
    make ; make install; \
    useradd nginx;\
    rm -rf /var/lib/apt/lists/*;\
    cd ..;\
    rm -rf nginx-1.11.1*; 

    
ENV CONSUL_TEMPLATE_VERSION 0.14.0
RUN wget -O consul-template.zip  https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip ;\
    unzip consul-template.zip -d /bin/ ; \
    rm consul-template.zip;

ENV CONTAINERPILOT_VER 2.1.4
ENV CONTAINERPILOT file:///etc/containerpilot.json 

RUN wget -O containerpilot.tar.gz          "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" ;\
        tar  zxvf containerpilot.tar.gz -C /bin/; \
        rm containerpilot.tar.gz;

COPY containerpilot.json /etc

ENV TERM xterm
VOLUME ["/tmp/nginx"]

EXPOSE 80 443
ENV HOME /root
WORKDIR /root

COPY nginx.conf.ctmpl /etc/nginx/nginx.conf.ctmpl

CMD ["/bin/containerpilot", "nginx", "-g", "daemon off;"]




