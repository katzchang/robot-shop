FROM alpine AS build
ARG KEY

WORKDIR /instana

RUN apk add --update --no-cache curl

ENV ARTI_PATH='https://artifact-public.instana.io/artifactory/shared/com/instana/nginx_tracing/'

RUN if [ -n "$KEY" ]; then \
    sensor_version=$(curl --user "_:$KEY" ${ARTI_PATH} | grep -o '>[0-9]\+\.[0-9]\+\.[0-9]\+'| cut -f 2 -d '>'|sort -V|tail -1 ); \
    echo "Downloading sensor version ${sensor_version} for Nginx version 1.21.6" ; \
    curl \
    --output instana.zip \
    --user "_:$KEY" \
    ${ARTI_PATH}/${sensor_version}/linux-amd64-glibc-nginx-1.21.6.zip && \
    unzip instana.zip && \
    mv glibc-libinstana_sensor.so libinstana_sensor.so && \
    mv glibc-nginx-1.21.6-ngx_http_ot_module.so ngx_http_opentracing_module.so; \
    else echo "KEY not provided. Not adding tracing"; \
    touch dummy.so; \
    fi


#FROM nginx:1.21.6
FROM nginx:1.18.0

EXPOSE 8080

ENV CATALOGUE_HOST=catalogue \
    USER_HOST=user \
    CART_HOST=cart \
    SHIPPING_HOST=shipping \
    PAYMENT_HOST=payment \
    RATINGS_HOST=ratings \
    INSTANA_SERVICE_NAME=nginx-web

RUN apt-get update ; apt-get install unzip
ADD https://github.com/open-telemetry/opentelemetry-cpp-contrib/releases/download/webserver%2Fv1.0.0/opentelemetry-webserver-sdk-x64-linux.tgz.zip /opt
RUN cd /opt ; unzip opentelemetry-webserver-sdk-x64-linux.tgz.zip; tar xvfz opentelemetry-webserver-sdk-x64-linux.tgz
RUN cd /opt/opentelemetry-webserver-sdk; ./install.sh
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opentelemetry-webserver-sdk/sdk_lib/lib
#RUN echo "load_module /opt/opentelemetry-webserver-sdk/WebServerModule/Nginx/ngx_http_opentelemetry_module.so;\n$(cat /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf
COPY opentelemetry_module.conf /etc/nginx/conf.d

COPY entrypoint.sh /root/
ENTRYPOINT ["/root/entrypoint.sh"]

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY static /usr/share/nginx/html
