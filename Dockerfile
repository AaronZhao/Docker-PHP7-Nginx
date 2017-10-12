FROM centos:7
MAINTAINER zhaowei@outlook.com
RUN rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/epel/epel-release-latest-7.noarch.rpm \
	&& rpm -Uvh https://sp.repo.webtatic.com/yum/el7/webtatic-release.rpm \
	&& yum install -y wget \
		sed \ 
		gcc \
		gcc-c++ \
		gd \
		gd-devel \
		gmp-devel \
		epel-release \
		net-tools \
		ntpdate \
		ntp \
		openssh-clients \ 
		curl \
		crontabs \
		openssl \
		openssl-devel \
		nginx \
		squid \
		php71w \
		php71w-fpm \
		php71w-gd \
		php71w-soap \
		php71w-pdo_mysql \
		php71w-pear \
		php71w-devel \	
		php71w-mbstring \
		php71w-mcrypt \
	&& yum clean all \
	&& sed -i 's/http_access deny all/#http_access deny all/g' /etc/squid/squid.conf \
	&& cd /tmp \
	&& wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py \
	&& python get-pip.py \
	&& pip install supervisor \
	&& mkdir -p /etc/supervisor.d/*.conf \
	&& pecl install mongodb \
	&& pecl install yaf \
	&& wget -c https://github.com/phpredis/phpredis/archive/3.1.4.tar.gz \
        && tar zxvf 3.1.4.tar.gz \
        && cd phpredis-3.1.4 \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && cd .. \
        && rm -rf phpredis* \
	&& rm 3.1.4.tar.gz \ 
	&& echo "" >> /etc/php.ini \
	&& echo "extension=redis.so" >> /etc/php.ini \
	&& echo "extension=yaf.so" >> /etc/php.ini \
	&& echo "extension=mongodb.so" >> /etc/php.ini 
COPY ./supervisord.conf /etc/
COPY ./default.conf /etc/nginx/conf.d/
COPY ./nginx.conf /etc/supervisor.d/
COPY ./php.conf /etc/supervisor.d/
COPY ./ntpdate.conf /etc/supervisor.d/
COPY ./nginx.conf.def /etc/nginx/nginx.conf
COPY ./index.php /data/work/code/
EXPOSE 80 443 3128
WORKDIR /data/work/code
CMD ["supervisord","-c","/etc/supervisord.conf"]
