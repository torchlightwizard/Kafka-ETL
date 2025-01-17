const { Kafka } = require("kafkajs");

const kafka = new Kafka({
        clientId: "my-app",
        brokers: [""]
})

module.exports = { kafka }
