const opentelemetry = require("@opentelemetry/sdk-node");
//const { JaegerExporter } = require("@opentelemetry/exporter-jaeger");
//const { PrometheusExporter } = require("@opentelemetry/exporter-prometheus");
const { OTLPTraceExporter } = require("@opentelemetry/exporter-trace-otlp-grpc");
const {
  getNodeAutoInstrumentations,
} = require("@opentelemetry/auto-instrumentations-node");
const { envDetector, processDetector } = require("@opentelemetry/resources");

const traceExporter = new OTLPTraceExporter();
console.log(traceExporter.url);
//const prometheusExporter = new PrometheusExporter({ startServer: true });

const sdk = new opentelemetry.NodeSDK({
  traceExporter: traceExporter,
  //metricReader: prometheusExporter,
  instrumentations: [getNodeAutoInstrumentations()],
  autoDetectResources: true,
  resourceDetectors: [processDetector, envDetector]
});

// You can optionally detect resources asynchronously from the environment.
// Detected resources are merged with the resources provided in the SDK configuration.
sdk.start().then(() => {
  console.log(sdk['_resource']);
});

// You can also use the shutdown method to gracefully shut down the SDK before process shutdown
// or on some operating system signal.
const process = require("process");
process.on("SIGTERM", () => {
  sdk
    .shutdown()
    .then(
      () => console.log("SDK shut down successfully"),
      (err) => console.log("Error shutting down SDK", err)
    )
    .finally(() => process.exit(0));
});

