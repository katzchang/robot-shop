#
# Build
#
FROM debian:10 AS build

RUN apt-get update && apt-get -y install maven

WORKDIR /opt/shipping

COPY pom.xml /opt/shipping/
RUN mvn dependency:resolve
COPY src /opt/shipping/src/
RUN mvn package

#
# Run
#
FROM openjdk:8-jdk
ARG VERSION

EXPOSE 8080

WORKDIR /opt/shipping

ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol:4317
ENV OTEL_SERVICE_NAME=rs-shipping
ENV OTEL_RESOURCE_ATTRIBUTES=service.version\=${VERSION}

ENV SPLUNK_METRICS_ENABLED=true
ENV SPLUNK_METRICS_ENDPOINT=http://otelcol:9943
ENV SPLUNK_PROFILER_ENABLED=true

RUN curl -L https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent.jar -o /opt/shipping/splunk-otel-javaagent.jar

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar

CMD [ "java", "-Xmn512m", "-Xmx1024m", "-javaagent:/opt/shipping/splunk-otel-javaagent.jar", "-jar", "shipping.jar" ]
