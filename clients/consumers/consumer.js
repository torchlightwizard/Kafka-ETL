const { kafka } = require("../clients/client")
const fs = require("node:fs/promises")

const consumer = kafka.consumer({groupId: "group18"})
const path = __dirname + "/../../logs/node_consumer.logs"

async function write(path, content) {
	try {
		await fs.appendFile(path, content)
		await fs.appendFile(path, "\n")
	} catch (err) {
		console.log(err)
	}
}

async function consume () {
        await consumer.connect()
        await consumer.subscribe({topic: "node-topic", fromBeginning: true})
        await consumer.run({
                eachMessage: async ({topic, partition, message}) => {
			await write(path, message.value.toString())
		}
        })

	// await consumer.disconnect()
}

consume ()
