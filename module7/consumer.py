import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from kafka import KafkaConsumer
from models import ride_deserializer

server = 'localhost:9092'
topic_name = 'green-trips'

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='rides-console',
    value_deserializer=ride_deserializer
)

print(f"Listening to {topic_name}...")

count = 0
trip_count = 0
for message in consumer:
    count += 1
    ride = message.value
    pickup_dt = datetime.fromtimestamp(ride.lpep_pickup_datetime / 1000)
    trip_distance = ride.trip_distance
    if (trip_distance > 5.0):
        trip_count += 1
        print(f"Received: PU={ride.PULocationID}, DO={ride.DOLocationID}, "
            f"distance={ride.trip_distance}, amount=${ride.total_amount:.2f}, "
            f"pickup={pickup_dt}")
        print(f"Total trips with distance > 5.0: {trip_count}")

consumer.close()
