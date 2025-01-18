const { kafka } = require("../clients/client")

const consumer = kafka.consumer({groupId: "group2"})

async function consume () {
        await consumer.connect()
        await consumer.subscribe({topic: "collectdata", fromBeginning: true})

        await consumer.run({
                eachMessage: async ({topic, partition, message}) => console.log(message.value.toString())
        })

	await consumer.disconnect()
}

consume ()
