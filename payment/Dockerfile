FROM python:3.9

EXPOSE 8080
USER root

ENV INSTANA_SERVICE_NAME=payment

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt
RUN splunk-py-trace-bootstrap

COPY *.py /app/
COPY payment.ini /app/

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-payment
ENV SPLUNK_METRICS_ENABLED=true
ENV SPLUNK_METRICS_ENDPOINT=http://otelcol:9943
ENV SPLUNK_PROFILER_ENABLED=true

#CMD ["python", "payment.py"]
CMD ["uwsgi", "--ini", "payment.ini"]

