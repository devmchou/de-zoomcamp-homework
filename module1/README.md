# de-zoomcamp-homework
DataTalksClub data engineering Zoom camp - homework repo

# Module 1 Homework: Docker & SQL

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

```
docker run -it --rm --entrypoint=bash python:3.13
pip --version
```
- [X] 25.3
- [ ] 24.3.1
- [ ] 24.2.1
- [ ] 23.3.1

Bash output:

```pip 25.3 from /usr/local/lib/python3.13/site-packages/pip (python 3.13)```

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- [ ] postgres:5433
- [ ] localhost:5432
- [ ] db:5433
- [ ] postgres:5432
- [X] db:5432

The above yaml defines internal container port 5432 and exposed host port 5433.  pgAdmin is running in a container and should use the Docker internal container port to connect.

Ran `docker-compose up` and tested new server registration connection with pgAdmin to verify port 5432 connection.

## Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

- [ ] 7,853
- [X] 8,007
- [ ] 8,254
- [ ] 8,421

Ran Jupyter notebook [module1.ipynb]()

Related code:

```
import pyarrow.parquet as pq
import datetime

parquet = "../data/green_tripdata_2025-11.parquet"
start_date = datetime.datetime.strptime('2025-11-01', "%Y-%m-%d")
end_date = datetime.datetime.strptime('2025-12-01', "%Y-%m-%d")

# Read with filter directly
table = pq.read_table(parquet, filters=[
    ('lpep_pickup_datetime', '>=', start_date), 
    ('lpep_dropoff_datetime', '<', end_date),
    ('trip_distance', '<=', 1.0)])

# Get the number of rows in the filtered table
filtered_count = len(table) 
filtered_count
```

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

- [X] 2025-11-14
- [ ] 2025-11-20
- [ ] 2025-11-23
- [ ] 2025-11-25

Ran Jupyter notebook [module1.ipynb]()

Related code:

```
parquet = "../data/green_tripdata_2025-11.parquet"

table_trips_under100 = pq.read_table(parquet, filters=[
    ('lpep_pickup_datetime', '>=', start_date), 
    ('lpep_dropoff_datetime', '<', end_date),
    ('trip_distance', '<', 100.0)])

df = table_trips_under100.to_pandas()
df.loc[df['trip_distance']==df['trip_distance'].max(), 'lpep_pickup_datetime']
```

## Question 5. Biggest pickup zone

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?

- [X] East Harlem North
- [ ] East Harlem South
- [ ] Morningside Heights
- [ ] Forest Hills

Ran Jupyter notebook [module1.ipynb]()

Related code:
```
date_of_interest = datetime.datetime.strptime('2025-11-18', "%Y-%m-%d")
date_of_interest2 = datetime.datetime.strptime('2025-11-19', "%Y-%m-%d")

# Read with filter directly
table_trips_on_date = pq.read_table(parquet, filters=[
    ('lpep_pickup_datetime', '>=', date_of_interest),
    ('lpep_pickup_datetime', '<', date_of_interest2),    
])

df_ondate = table_trips_on_date.to_pandas()

# Group by 'PULocationID' and sum the numeric columns ('Value1', 'Value2')
summed_df_ondate = df_ondate.groupby('PULocationID').agg({'total_amount': 'sum'})
summed_df_ondate[summed_df_ondate['total_amount']==summed_df_ondate['total_amount'].max()]
```

This yielded *PULocationID = 74*

## Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

- [ ] JFK Airport
- [X] Yorkville West
- [ ] East Harlem North
- [ ] LaGuardia Airport

Ran Jupyter notebook [module1.ipynb]()

Related code:
```
start_date = datetime.datetime.strptime('2025-11-01', "%Y-%m-%d")
end_date = datetime.datetime.strptime('2025-12-01', "%Y-%m-%d")

# Read with filter directly
table_trips_question6 = pq.read_table(parquet, filters=[
    ('lpep_pickup_datetime', '>=', start_date),
    ('lpep_pickup_datetime', '<', end_date),
    ('PULocationID', '==', 74)
])

df_question6 = table_trips_question6.to_pandas()
df_question6.loc[df_question6['tip_amount']==df_question6['tip_amount'].max(), 'DOLocationID']
```
This yielded *DOLocationID = 263*

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- [ ] terraform import, terraform apply -y, terraform destroy
- [ ] teraform init, terraform plan -auto-apply, terraform rm
- [ ] terraform init, terraform run -auto-approve, terraform destroy
- [X] terraform init, terraform apply -auto-approve, terraform destroy
- [ ] terraform import, terraform apply -y, terraform rm

