ZOOKEEPER_PORT := 2181
ZOOKEEPER_TIMEOUT := 5
KAFKA_PORT := 9092
KAFKA_TIMEOUT := 5
CONSOLE_TOPIC := console-topic
NODE_TOPIC := node-topic

start: start-kafka
	@echo "Started Both"

stop: stop-zookeeper
	@echo "Stopped Both"

start-zookeeper:
	@screen -aS zookeeper -d -m $(HOME)/kafka/bin/zookeeper-server-start.sh $(HOME)/kafka/config/zookeeper.properties
	@timeout $(ZOOKEEPER_TIMEOUT) bash -c 'while ! echo ruok | nc localhost $(ZOOKEEPER_PORT) | grep imok > /dev/null 2>&1 && echo "Attempting to connect to Zookeeper"; do sleep 1; done'
	@if [ $$? -ne 0 ]; then echo "Failed to start Zookeeper"; exit 1; else echo "Started Zookeeper"; exit 0; fi

start-kafka: start-zookeeper
	@screen -aS kafka -d -m $(HOME)/kafka/bin/kafka-server-start.sh $(HOME)/kafka/config/server.properties
	@timeout $(KAFKA_TIMEOUT) bash -c 'while ! nc -zv localhost $(KAFKA_PORT) > /dev/null 2>&1; do sleep 1 && echo "Attempting to connect to Kafka" ; done'
	@if [ $$? -ne 0 ]; then echo "Failed to start Kafka"; else echo "Started Kafka"; exit 0; fi

stop-zookeeper: stop-kafka
	@if ! nc -zv localhost $(ZOOKEEPER_PORT) > /dev/null 2>&1; then echo "ZooKeeper is already stopped"; exit 0; else $(HOME)/kafka/bin/zookeeper-server-stop.sh; fi
	@if [ $$? -eq 0 ]; then echo "ZooKeeper stopped"; else echo "Failed to stop ZooKeeper"; exit 1; fi

stop-kafka:
	@if ! nc -zv localhost $(KAFKA_PORT) > /dev/null 2>&1; then echo "Kafka is already stopped"; exit 0; else $(HOME)/kafka/bin/kafka-server-stop.sh; fi
	@if [ $$? -eq 0 ]; then echo "Kafka stopped"; else echo "Failed to stop Kafka"; exit 1; fi

create-console-topic:
	@$(HOME)/kafka/bin/kafka-topics.sh --create --topic $(CONSOLE_TOPIC) --bootstrap-server localhost:${KAFKA_PORT}

create-node-topic:
	@$(HOME)/kafka/bin/kafka-topics.sh --create --topic $(NODE_TOPIC) --bootstrap-server localhost:${KAFKA_PORT}

list-topics:
	@$(HOME)/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:$(KAFKA_PORT)

console-produce:
	@screen -aS console_producer -d -m $(HOME)/kafka/bin/kafka-console-producer.sh --topic $(CONSOLE_TOPIC) --bootstrap-server localhost:${KAFKA_PORT}

console-consume:
	@screen -aS console_consumer -d -m $(HOME)/kafka/bin/kafka-console-consumer.sh --topic ${CONSOLE_TOPIC} --from-beginning --bootstrap-server localhost:${KAFKA_PORT}

node-produce:
	@screen -aS node_producer -d -m 'cd ./clients && npm start:producer'

node-consume:
	@screen -aS node_consumer -d -m 'cd ./clients && npm start:consumer'

delete-brokers:
	if [ -d /tmp/kafka-logs ]; then rm -r /tmp/kafka-logs; fi
	if [ -d /tmp/zookeeper ]; then rm -r /tmp/zookeeper; fi
