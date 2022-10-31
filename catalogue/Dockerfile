FROM node:14

ENV INSTANA_AUTO_PROFILE true

EXPOSE 8080

WORKDIR /opt/server

COPY package.json /opt/server/

RUN npm install


ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-catalogue
ENV OTEL_PROPAGATORS=baggage,tracecontext,b3multi,b3

COPY server.js tracer.js monitoring.js /opt/server/

CMD ["node", "-r", "./tracer.js", "server.js"]

