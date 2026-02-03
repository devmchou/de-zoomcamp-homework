# de-zoomcamp-homework
DataTalksClub data engineering Zoom camp - homework repo

# Module 2 Homework: Workflow Orchestration

Ran Kestra yaml [taxi_rowcount_annual_revised.yaml](taxi_rowcount_annual_revised.yaml)
with several test inputs

Checked Kestra outputs:

Inspected the get_file_size task for the following run:
- Run (Year: 2020, Month: 12, Taxi: Yellow)

```
The size of the file is 134481400 bytes.
```

Inspected the calculate_sum task for the following runs:
- Run (Year: 2020, Month: All, Taxi: Yellow)
- Run (Year: 2020, Month: All, Taxi: Green)
- Run (Year: 2021, Month: 03, Taxi: Yellow)

```
Yellow taxi total for 2020:         The total sum is: 24648499
Green taxi total for 2020:          The total sum is: 1734051
Yellow taxi total for March 2021:   The total sum is: 1925152
```

### Quiz Questions

Complete the quiz shown below. It's a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra, and ETL pipelines.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- [ ] 128.3 MiB
- [X] 134.5 MiB
- [ ] 364.7 MiB
- [ ] 692.6 MiB

2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- [ ] `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- [X] `green_tripdata_2020-04.csv`
- [ ] `green_tripdata_04_2020.csv`
- [ ] `green_tripdata_2020.csv`

3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- [ ] 13,537.299
- [X] 24,648,499
- [ ] 18,324,219
- [ ] 29,430,127

4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- [ ] 5,327,301
- [ ] 936,199
- [X] 1,734,051
- [ ] 1,342,034

5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- [ ] 1,428,092
- [ ] 706,911
- [X] 1,925,152
- [ ] 2,561,031

6) How would you configure the timezone to New York in a Schedule trigger?
- [ ] Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- [ ] Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- [X] Add a `timezone` property set to `UTC[ ]5` in the `Schedule` trigger configuration
- [ ] Add a `location` property set to `New_York` in the `Schedule` trigger configuration  