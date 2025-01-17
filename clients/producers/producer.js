const { kafka } = require("../clients/client")

const producer = kafka.producer()

async function produce () {
        await producer.connect()

        await producer.send({
                topic: "collectdata",
                messages: [{value: "this is from the app"}]
        })

        await producer.disconnect()
}

produce()
