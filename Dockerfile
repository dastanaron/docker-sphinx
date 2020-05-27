FROM alpine:latest

ARG FILE=sphinx-3.2.1-f152e0b-linux-amd64-musl.tar.gz

# Install packages
RUN apk add --update --no-cache mariadb-connector-c-dev \
	postgresql-dev \
	wget

RUN mkdir -p /usr/local/sphinx/
RUN mkdir -p /var/log/sphinx/
RUN mkdir -p /etc/sphinx/
RUN mkdir -p /var/data/sphinx/

RUN wget -q http://sphinxsearch.com/files/${FILE} -O /usr/local/sphinx/sphinx.tar.gz
RUN cd /usr/local/sphinx/ && tar -C ./ -zxvf sphinx.tar.gz --strip-components 1 && rm sphinx.tar.gz

ENV PATH "${PATH}:/usr/local/sphinx/bin"

COPY ./config/sphinx.conf /etc/sphinx/default.conf

# if you need show log in stdout
#RUN ln -sv /dev/stdout /var/log/sphinx/query.log
#RUN ln -sv /dev/stdout /var/log/sphinx/log/searchd.log

RUN indexer -v

CMD searchd --nodetach --config /etc/sphinx/default.conf
