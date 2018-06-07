FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server net-tools supervisor nano build-essential libpcre3 libpcre3-dev libssl-dev git
RUN mkdir /var/run/sshd && mkdir log
RUN useradd vuta && echo 'vuta:Echo@1927' | chpasswd
RUN echo adduser vuta sudo
RUN echo 'root:Echo@1927' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -p /build
WORKDIR /build
RUN git clone git://github.com/arut/nginx-rtmp-module.git
RUN wget http://nginx.org/download/nginx-1.15.0.tar.gz
RUN tar xzf nginx-1.15.0.tar.gz

WORKDIR /build/nginx-1.15.0
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
RUN make
RUN make install

RUN mkdir -p /var/demo_videos
COPY demo.mp4 /var/demo_videos
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80 1935 22
CMD ["supervisord", "-c","/etc/supervisor/supervisord.conf"]