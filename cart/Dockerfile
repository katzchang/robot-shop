FROM node:14

ENV INSTANA_AUTO_PROFILE true

EXPOSE 8080

WORKDIR /opt/server

COPY package.json /opt/server/

RUN npm install

COPY server.js /opt/server/
COPY tracing.js /opt/server/


ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-cart
#ENV OTEL_RESOURCE_ATTRIBUTES=
#ENV SPLUNK_METRICS_ENABLED=true
#ENV SPLUNK_METRICS_ENDPOINT=http://otelcol:9943
#ENV SPLUNK_PROFILER_ENABLED=true

CMD ["node", "-r", "./tracing.js", "./server.js"]

