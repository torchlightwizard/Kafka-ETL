const { Kafka } = require("kafkajs");
require("dotenv").config()

const kafka = new Kafka({
        clientId: "my-app",
        brokers: [`${process.env.HOST}:${process.env.BROKER_PORT}`]
})

module.exports = { kafka }
