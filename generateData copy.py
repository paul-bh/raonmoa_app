import json
import random
import time

# Define time interval of datas in seconds
interval_hours = 2.9/60
time_interval = 60 * 60 * interval_hours

# Unix timestamp bounds
start_timestamp = 1679735700
# current time's Unix timestamp
end_timestamp = int(time.time())

# generated value's movement range in percentage
movement_range = 0.1
# Calculate number of inner JSON objects
num_objects = int((end_timestamp - start_timestamp) / time_interval)

# default Firebase database form
Firebase_database = {
    "UsersData": {
    "9VKdbC8eQNSez2wD8CQbQ1bHGqt1": {
        "charts": {
        "co": "500",
        "co2": "0",
        "humidity": "80",
        "led": "ON",
        "ph": "7",
        "pm": "10",
        "pump": "ON",
        "temperature": "33.5",
        "timestamp": "1680045638",
        "tvoc": "0",
        "upm": "5",
        "uv": "ON",
        "waterLevel": "1000",
        "waterTemp": "20"
        },
        "control": {
            "pump": "OFF",
            "uv": "OFF",
            "led": "OFF"
        },
        "readings": {}}
    }
}


# Generate 'readings' JSON data
_data = {}
# make standard variables
co = random.uniform(1, 200)
co2 = random.uniform(1, 200)
humidity = random.uniform(30, 70)
led = random.choice(["OFF", "ON"])
ph = round(random.uniform(5, 9), 2)
pm = random.uniform(1, 120)
pump = random.choice(["OFF", "ON"])
temperature = random.uniform(10, 30)
tvoc = random.uniform(1, 500)
upm = random.uniform(1, 50)
uv = random.choice(["OFF", "ON"])
water_level = random.choice(["L", "M", "H"])
water_temp = random.uniform(10, 30)

for i in range(num_objects):
    print(i)
    # Calculate Unix timestamp
    timestamp = int(start_timestamp + i * time_interval)
    # Convert Unix timestamp to 'YYYYMMDD' in GMT+9 timezone
    date = time.strftime('%Y%m%d', time.gmtime(timestamp + 9*60*60))

    # Generate random values, but within the movement range.
    # also, make sure that the values are within bounds declared in standard variables
    # use random.uniform() to generate float values

    co = round(random.uniform(co - co * movement_range, co + co * movement_range), 2)
    if co < 1: co = round(random.uniform(1, co + co * movement_range), 2)
    elif co > 200: co = round(random.uniform(co - co * movement_range, 200), 2)

    co2 = round(random.uniform(co2 - co2 * movement_range, co2 + co2 * movement_range), 2)
    if co2 < 1: co2 = round(random.uniform(1, co2 + co2 * movement_range), 2)
    elif co2 > 200: co2 = round(random.uniform(co2 - co2 * movement_range, 200), 2)

    humidity = round(random.uniform(humidity - humidity * movement_range, humidity + humidity * movement_range), 2)
    if humidity < 30: humidity = round(random.uniform(30, humidity + humidity * movement_range), 2)
    elif humidity > 70: humidity = round(random.uniform(humidity - humidity * movement_range, 70), 2)

    # 90% chance of led being same as previous value
    if random.randint(1, 10) <= 9:
        led = led
    else:
        led = random.choice(["OFF", "ON"])

    ph = round(random.uniform(ph - ph * movement_range, ph + ph * movement_range), 2)
    if ph < 5: ph = round(random.uniform(5, ph + ph * movement_range), 2)
    elif ph > 9: ph = round(random.uniform(ph - ph * movement_range, 9), 2)

    pm = round(random.uniform(pm - pm * movement_range, pm + pm * movement_range), 2)
    if pm < 1: pm = round(random.uniform(1, pm + pm * movement_range), 2)
    elif pm > 120: pm = round(random.uniform(pm - pm * movement_range, 120), 2)

    # 90% chance of pump being same as previous value
    if random.randint(1, 10) <= 9:
        pump = pump
    else:
        pump = random.choice(["OFF", "ON"])

    temperature = round(random.uniform(temperature - temperature * movement_range, temperature + temperature * movement_range), 2)
    if temperature < 10: temperature = round(random.uniform(10, temperature + temperature * movement_range), 2)
    elif temperature > 30: temperature = round(random.uniform(temperature - temperature * movement_range, 30), 2)

    tvoc = round(random.uniform(tvoc - tvoc * movement_range, tvoc + tvoc * movement_range), 2)
    if tvoc < 1: tvoc = round(random.uniform(1, tvoc + tvoc * movement_range), 2)
    elif tvoc > 500: tvoc = round(random.uniform(tvoc - tvoc * movement_range, 500), 2)

    upm = round(random.uniform(upm - upm * movement_range, upm + upm * movement_range), 2)
    if upm < 1: upm = round(random.uniform(1, upm + upm * movement_range), 2)
    elif upm > 50: upm = round(random.uniform(upm - upm * movement_range, 50), 2)


    # 90% chance of uv being same as previous value
    if random.randint(1, 10) <= 9:
        uv = uv
    else:
        uv = random.choice(["OFF", "ON"])

    # 90% chance of water_level being same as previous value
    if random.randint(1, 10) <= 9:
        water_level = water_level
    else:
        water_level = random.choice(["L", "M", "H"])

    water_temp = round(random.uniform(water_temp - water_temp * movement_range, water_temp + water_temp * movement_range), 2)
    if water_temp < 10: water_temp =  round(random.uniform(10, water_temp + water_temp * movement_range), 2)
    elif water_temp > 30: water_temp = round(random.uniform(water_temp - water_temp * movement_range, 30), 2)

    # Create inner JSON object
    inner_data = {
        "co": co,
        "co2": co2,
        "humidity": humidity,
        "led": led,
        "ph": ph,
        "pm": pm,
        "pump": pump,
        "temperature": temperature,
        "timestamp": timestamp,
        "tvoc": tvoc,
        "upm": upm,
        "uv": uv,
        "waterLevel": water_level,
        "waterTemp": water_temp
    }

    # Add inner JSON object to data
    if date not in _data:
        _data[date] = {}
    _data[date][str(timestamp)] = inner_data
    print( _data[date][str(timestamp)])

# put inner data in firebase's 'readings' form
Firebase_database['UsersData']['9VKdbC8eQNSez2wD8CQbQ1bHGqt1']['readings'] = _data

# write final firebase JSON data to file
with open('readingsdata.json', 'w') as f:
    json.dump(Firebase_database, f, indent=4)