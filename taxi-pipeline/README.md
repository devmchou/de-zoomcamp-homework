# Homework: Build Your Own dlt Pipeline


Ran dlt pipeline Python script:  [taxi_pipeline.py](taxi_pipeline.py)

Performed queries:
```
SELECT min(trip_pickup_date_time), max(trip_pickup_date_time) from taxi_pipeline_dataset.trips;

SELECT count(*) from taxi_pipeline_dataset.trips where payment_type='Credit';

SELECT SUM(tip_amt) from taxi_pipeline_dataset.trips;
```

### Question 1: What is the start date and end date of the dataset?

- [ ] 2009-01-01 to 2009-01-31
- [X] 2009-06-01 to 2009-07-01
- [ ] 2024-01-01 to 2024-02-01
- [ ] 2024-06-01 to 2024-07-01

### Question 2: What proportion of trips are paid with credit card?

- [ ] 16.66%
- [X] 26.66%
- [ ] 36.66%
- [ ] 46.66%

### Question 3: What is the total amount of money generated in tips?

- [ ] $4,063.41
- [X] $6,063.41
- [ ] $8,063.41
- [ ] $10,063.41

