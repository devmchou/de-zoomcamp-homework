# Homework

## Question 1. Redpanda version

Run `rpk version` inside the Redpanda container:

```bash
docker exec -it workshop-redpanda-1 rpk version
```

What version of Redpanda are you running?

```
docker exec -it module7-redpanda-1 rpk version

rpk version: v25.3.9
Git ref:     836b4a36ef6d5121edbb1e68f0f673c2a8a244e2
Build date:  2026 Feb 26 07 48 21 Thu
OS/Arch:     linux/amd64
Go version:  go1.24.3

Redpanda Cluster
  node-1  v25.3.9 - 836b4a36ef6d5121edbb1e68f0f673c2a8a244e2
```

## Question 2. Sending data to Redpanda

Create a topic called `green-trips`:

```bash
docker exec -it workshop-redpanda-1 rpk topic create green-trips
```

Now write a producer to send the green taxi data to this topic.

Read the parquet file and keep only these columns:

- `lpep_pickup_datetime`
- `lpep_dropoff_datetime`
- `PULocationID`
- `DOLocationID`
- `passenger_count`
- `trip_distance`
- `tip_amount`
- `total_amount`

Convert each row to a dictionary and send it to the `green-trips` topic.
You'll need to handle the datetime columns - convert them to strings
before serializing to JSON.

Measure the time it takes to send the entire dataset and flush:

```python
from time import time

t0 = time()

# send all rows ...

producer.flush()

t1 = time()
print(f'took {(t1 - t0):.2f} seconds')
```

How long did it take to send the data?

- [X] 10 seconds
- [ ] 60 seconds
- [ ] 120 seconds
- [ ] 300 seconds


## Question 3. Consumer - trip distance

Write a Kafka consumer that reads all messages from the `green-trips` topic
(set `auto_offset_reset='earliest'`).

Count how many trips have a `trip_distance` greater than 5.0 kilometers.

How many trips have `trip_distance` > 5?

- [ ] 6506
- [ ] 7506
- [X] 8506
- [ ] 9506


## Part 2: PyFlink (Questions 4-6)

## Question 4. Tumbling window - pickup location

Create a Flink job that reads from `green-trips` and uses a 5-minute
tumbling window to count trips per `PULocationID`.

Write the results to a PostgreSQL table with columns:
`window_start`, `PULocationID`, `num_trips`.

After the job processes all data, query the results:

```sql
SELECT PULocationID, num_trips
FROM <your_table>
ORDER BY num_trips DESC
LIMIT 3;
```

Which `PULocationID` had the most trips in a single 5-minute window?

- [ ] 42
- [X] 74
- [ ] 75
- [ ] 166


## Question 5. Session window - longest streak

Create another Flink job that uses a session window with a 5-minute gap
on `PULocationID`, using `lpep_pickup_datetime` as the event time
with a 5-second watermark tolerance.

A session window groups events that arrive within 5 minutes of each other.
When there's a gap of more than 5 minutes, the window closes.

Write the results to a PostgreSQL table and find the `PULocationID`
with the longest session (most trips in a single session).

How many trips were in the longest session?

- [ ] 12
- [ ] 31
- [ ] 51
- [X] 81


## Question 6. Tumbling window - largest tip

Create a Flink job that uses a 1-hour tumbling window to compute the
total `tip_amount` per hour (across all locations).

Which hour had the highest total tip amount?

- [ ] 2025-10-01 18:00:00
- [X] 2025-10-16 18:00:00
- [ ] 2025-10-22 08:00:00
- [ ] 2025-10-30 16:00:00

---
Work Notes:

Producer script:  [producer.ipynb](notebooks/producer.ipynb)

Question 3:  Used script [consumer.py](consumer.py)

Questions 4-6:  Created the following tables in PostgresSQL:

```
CREATE TABLE processed_events_aggregated (
    window_start TIMESTAMP,
    PULocationID INTEGER,
    num_trips BIGINT
    PRIMARY KEY (window_start, PULocationID)
);

CREATE TABLE processed_tipevents_aggregated (
    window_start TIMESTAMP,
    total_tip_amount DOUBLE PRECISION,
    PRIMARY KEY (window_start)
);

CREATE TABLE processed_sessionevents_aggregated (
    window_start TIMESTAMP,
    window_end TIMESTAMP,
    PULocationID INTEGER,
    num_trips BIGINT,
    PRIMARY KEY (window_start, PULocationID)
);
```
Ran these scripts
- [question4.py](src/job/question4.py)
- [question5.py](src/job/question5.py)
- [question6.py](src/job/question6.py)

For question 5, ran SQL in pgcli:
```
select * from processed_sessionevents_aggregated order by num_trips desc limit 3;
```