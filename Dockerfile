FROM debian:stretch

EXPOSE 80

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install python python-pip redis-server gunicorn git-core runit uwsgi uwsgi-plugin-python nginx
RUN groupadd netconfig && useradd -g netconfig -G sudo netconfig

ADD requirements.txt /home/netconfig/requirements.txt
WORKDIR /home/netconfig
RUN pip install --upgrade pip && pip install -r requirements.txt

ADD docker/runit /etc/service
ADD docker/nginx.site /etc/nginx/sites-available/netconfig
RUN rm /etc/nginx/sites-enabled/default && ln -sf /etc/nginx/sites-available/netconfig /etc/nginx/sites-enabled

ADD . /home/netconfig
RUN chown -R netconfig /home/netconfig

ENTRYPOINT ["runsvdir", "-P", "/etc/service"]
