const { kafka } = require("../clients/client")

const producer = kafka.producer()

async function produce () {
        await producer.connect()

        await producer.send({
                topic: "node-topic",
                messages: [{value: "testing node producer"}]
        })

        await producer.disconnect()
}

produce()
