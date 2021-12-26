FROM ubuntu:21.04 as download

RUN apt-get update -y && \
    apt-get install git -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://gitee.com/Discuz/DiscuzX.git && \
    cd DiscuzX && \
    DISCUZ_LATEST_VERSION=$(git tag | tail -n 1) && \
    git checkout ${DISCUZ_LATEST_VERSION} && \
    sed -i "s/20180101/${DISCUZ_LATEST_VERSION#*-}/g" ./upload/source/discuz_version.php

FROM php:7-apache

EXPOSE 80

RUN apt-get update -y && \
    apt-get install -y rsync libpng-dev zlib1g-dev && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install mysqli gd

COPY --from=download /DiscuzX/upload /var/www/html

RUN rsync -a ./config /tmp/discuz_x && \
    rsync -a ./data /tmp/discuz_x && \
    rsync -a ./uc_server/data /tmp/discuz_x/uc_server && \
    rsync -a ./uc_client/data /tmp/discuz_x/uc_client && \
    chmod a+w -R /tmp/discuz_x

COPY ./init.sh /
RUN chmod +x /init.sh
CMD ["/init.sh"]
