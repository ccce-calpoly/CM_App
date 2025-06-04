const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

exports.testHello = onRequest((request, response) => {
  logger.info("Hello from a test function!", { structuredData: true });
  response.send("Hello from Firebase Test Function!");
});
