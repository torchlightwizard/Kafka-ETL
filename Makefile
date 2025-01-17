start-zookeeper:
	@screen -aS zookeeper -d -m $(HOME)/kafka/bin/zookeeper-server-start.sh $(HOME)/kafka/config/zookeeper.properties

start-kafka:
	@screen -aS kafka -d -m $(HOME)/kafka/bin/kafka-server-start.sh $(HOME)/kafka/config/server.properties
