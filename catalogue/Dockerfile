FROM node:14

EXPOSE 8080

WORKDIR /opt/server

COPY package.json /opt/server/

RUN npm install

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-catalogue
ENV OTEL_PROPAGATORS=baggage,tracecontext,b3multi,b3

ENV SPLUNK_PROFILER_ENABLED='true'
ENV SPLUNK_PROFILER_MEMORY_ENABLED='true'
ENV SPLUNK_PROFILER_LOGS_ENDPOINT=http://otelcol:4317

ENV SPLUNK_METRICS_ENABLED='true'
ENV OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://otelcol:4317

COPY server.js /opt/server/

CMD ["node", "-r", "@splunk/otel/instrument", "server.js"]

