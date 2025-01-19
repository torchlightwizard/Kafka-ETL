# Kaggle Datasets Used

1. Finance Data<br/>
Link: https://www.kaggle.com/datasets/nitindatta/finance-data?select=Finance_data.csv<br/>
File: Finance_data.csv<br/>

2. Finance & Accounting Courses - Udemy (13K+ course)<br/>
Link: https://www.kaggle.com/datasets/jilkothari/finance-accounting-courses-udemy-13k-course<br/>
File: udemy_output_All_Finance__Accounting_p1_p626.csv<br/>

3. Cryptocurrency Data<br/>
Link: https://www.kaggle.com/datasets/namanmanchanda/cryptocurrency-data?select=DOGE-USD-2.csv<br/>
File: DOGE-USD-2.csv<br/>



# Setup
Folders and config files to include.<br/>
1. `logs` folder in root dir.
2. `.env` file in `/clients` folder.
3. `data` folder in root dir.

Installation and setup process in detail.<br/>
1. Place kafka folder in your `/home/user/` directory, given by $HOME environment variable.<br/>
2. Add this line `4lw.commands.whitelist=ruok` in `$HOME/kafka/config/zookeeper.properties`. It will enable us to check Zookeepers health and active status.<br/>
3. Use commands in Makefile:
	make start: will start both zookeeper and kafka in order
	make stop: will stop both kafka and zookper in order
	make delete-brokers: will reset the whole kafka, all your topics and consumers attached to them gone, poof, good for starting new environment to experiment in
	make list-topics: will list all topics in your clusters
4. Create an `.env`file in `/clients` folder. You need to define:
	HOST
	BROKER_PORT
5. Use commands in `/clients/package.json`
	npm i
	npm run start:producer
	npm run start:consumer

# Architecture
1. Producers (Dataset1, Dataset2, Dataset3) -> Topics (?) -> Processor (Consumer + Producer) -> Topic (Central Data) -> Consumers (Server1, Server2, Server3)<br/>
