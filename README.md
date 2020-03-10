# ksql-BAWAG

Transaction caching using ksqlDB, based on Confluent Docker images.

## Demo walkthrough

### 1. Start all containers

    docker-compose up -d

### 2. Populate the first topic. This is done using a script but also show the connect possibilities here.

    cd bin
    ./produce.sh

### 3. Go to GUI. Show the cluster health overview, the topic overview. Go into topic and show unstructured data.

GUI at localhost:9021

### 4. Create a STREAM on top of the Kafka topic. This is an abstraction in order to work with the data in real time apps.

    CREATE STREAM odl_movements_raw (
        DATUM VARCHAR,
        IBAN VARCHAR,
        DAT_ACCT VARCHAR,
        NUM_OPERATION VARCHAR,
        NUM_TRANSACTION VARCHAR,
        MOVEMENT_TYPE VARCHAR,
        ACCOUNT_NUMBER VARCHAR,
        BANK_CODE VARCHAR,
        VALUE_DATE VARCHAR,
        BOOKING_TEXT VARCHAR,
        USAGE VARCHAR,
        ACCOUNT_STATEMENT_DATE VARCHAR,
        ACCOUNT_STATEMENT_NUMBER VARCHAR,
        AMOUNT VARCHAR,
        CURRENCY VARCHAR,
        GVC_CODE VARCHAR,
        SUPPLEMENT_REFERENCE VARCHAR,
        IMAGE_REFERENCE VARCHAR,
        INSTITUTE_REFERENCE VARCHAR,
        CUSTOMER_DATA VARCHAR,
        COUNTER_ACCOUNT_WORDING VARCHAR,
        COUNTER_IBAN VARCHAR,
        COUNTER_BIC VARCHAR,
        COUNTER_ACCOUNT_NUMBER VARCHAR,
        COUNTER_BANK_CODE VARCHAR,
        LAST_MODIFIED VARCHAR,
        TEXT_CODE VARCHAR,
        ORIGINAL_BALANCE VARCHAR,
        CHANNEL VARCHAR,
        ADDITIONAL_INFO VARCHAR,
        CATEGORY_NAME VARCHAR,
        PARENT_CATEGORY_NAME VARCHAR,
        CUSTOMER_CATEGORY_NAME VARCHAR,
        RISK_CATEGORY VARCHAR
    )
    WITH (
        KAFKA_TOPIC='ODL_MOVEMENTS_RAW',
        VALUE_FORMAT='DELIMITED'
    );


### 5. Now let’s create our first “real” realtime app. This cleanses the input data and brings them into a structured, binary format.

    CREATE STREAM odl_movements_keyed
    WITH (
        TIMESTAMP='DATUM',
        TIMESTAMP_FORMAT='yyyy-MM-dd HH:mm:ss.SSS Z',
        VALUE_FORMAT='AVRO'
    ) 
    AS 
    SELECT
        *
    FROM
        odl_movements_raw
    EMIT CHANGES
    PARTITION BY
        IBAN;


Note how this not only enforces structure but also creates a message key that can be used for lookups and aggregations. Also note the familiar SQL syntax.

### 6. In a real time app, there are two fundamental abstractions: Streams and Tables. Streams model change, and Tables model state. A Table shows the last known state of an item. Let us create a table with all the amounts and target accounts of transactions, per account per week.

    CREATE TABLE odl_movements_iban_monthly
    AS
    SELECT
        COLLECT_LIST(amount) AS amounts,
        COLLECT_LIST(counter_iban) AS counter_ibans
    FROM odl_movements_keyed
    WINDOW TUMBLING (SIZE 30 DAYS)
    GROUP BY iban
    EMIT CHANGES;

Here you see a few specifics about real time stream programming flowing into KSQL. Aggregations and also joins usually have a time window clause.

Note how we collect several transactions into a bucket in order to retrieve them with a point query later.

### 7. Use a point query to retrieve one customer’s last transactions over a week.

    select * from odl_movements_iban_qtr where rowkey='d871fa21e640eba52a03399421a504b4';

### 8. Queries can also be executed via REST API or via CLI. The CLI shows the result in better detail.

    docker exec -it bawag-ksql-cli ksql http://ksql-server:8088

    select * from odl_movements_iban_qtr where rowkey='d871fa21e640eba52a03399421a504b4';

