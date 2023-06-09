import json
import random
import time

# Define time interval of datas in seconds
interval_hours =3/60
time_interval = 60 * 60 * interval_hours

# Unix timestamp bounds
start_timestamp = 1679735700
# current time's Unix timestamp
end_timestamp = int(time.time())

# generated value's movement range in percentage
movement_range = 0.01

# Calculate number of inner JSON objects
num_objects = int((end_timestamp - start_timestamp) / time_interval)


# default Firebase database form
Firebase_database = {
    "UsersData": {
    # "9VKdbC8eQNSez2wD8CQbQ1bHGqt1": {
    "V9cbUq9BIzLqPzL9dEhQzO2JRYG2": {
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
co_min, co_max = 1, 120
co2_min, co2_max = 1, 1500
humidity_min, humidity_max = 30, 70
ph_min, ph_max = 5, 9
pm_min, pm_max = 1, 120
upm_min, upm_max = 1, 70
temperature_min, temperature_max = 10, 30
tvoc_min, tvoc_max = 1, 500
water_temp_min, water_temp_max = 10, 22

co = random.randint(co_min, co_max)
co2 = random.randint(co2_min, co2_max)
humidity = random.randint(humidity_min, humidity_max)
ph = round(random.uniform(ph_min, ph_max), 2)
pm = random.randint(pm_min, pm_max)
upm = random.randint(upm_min, upm_max)
temperature = round(random.uniform(temperature_min, temperature_max), 2)
tvoc = random.randint(tvoc_min, tvoc_max)
water_temp = round(random.uniform(water_temp_min, water_temp_max), 2)
water_level = random.choice(["L", "M", "H"])
uv = random.choice(["OFF", "ON"])
led = random.choice(["OFF", "ON"])
pump = random.choice(["OFF", "ON"])

def force_increase(min, max):
    return round(random.uniform(min,(max+min) / 2 / 2),2)

def force_decrease(min, max):
    return round(random.uniform((max+min)/2 * 1.5, max),2)

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
    if co < co_min: co =  force_increase(co_min, co_max)
    elif co > co_max: co =  force_decrease(co_min, co_max)
    
    co2 = round(random.uniform(co2 - co2 * movement_range, co2 + co2 * movement_range), 2)
    if co2 < co2_min: co2 = force_increase(co2_min, co2_max)
    elif co2 > co2_max: co2 = force_decrease(co2_min, co2_max)

    humidity = round(random.uniform(humidity - humidity * movement_range, humidity + humidity * movement_range), 2)
    if humidity < humidity_min: humidity = force_increase(humidity_min, humidity_max)
    elif humidity > humidity_max: humidity =  force_decrease(humidity_min, humidity_max)

    ph = round(random.uniform(ph - ph * movement_range, ph + ph * movement_range), 2)
    if ph < ph_min: ph =   force_increase(ph_min, ph_max)
    elif ph > ph_max: ph = force_decrease(ph_min, ph_max)

    pm = round(random.uniform(pm - pm * movement_range, pm + pm * movement_range), 2)
    if pm < pm_min: pm =  force_increase(pm_min, pm_max)
    elif pm > pm_max: pm = force_decrease(pm_min, pm_max)

    upm = round(random.uniform(upm - upm * movement_range, upm + upm * movement_range), 2)
    if upm < upm_min: upm =  force_increase(upm_min, upm_max)
    elif upm > upm_max: upm = force_decrease(upm_min, upm_max)

    temperature = round(random.uniform(temperature - temperature * movement_range, temperature + temperature * movement_range), 2)
    if temperature < temperature_min: temperature =  force_increase(temperature_min, temperature_max)
    elif temperature > temperature_max: temperature =  force_decrease(temperature_min, temperature_max)

    tvoc = round(random.uniform(tvoc - tvoc * movement_range, tvoc + tvoc * movement_range), 2)
    if tvoc < tvoc_min: tvoc =  force_increase(tvoc_min, tvoc_max)
    elif tvoc > tvoc_max: tvoc =  force_decrease(tvoc_min, tvoc_max)

    water_temp = round(random.uniform(water_temp - water_temp * movement_range, water_temp + water_temp * movement_range), 2)
    if water_temp < water_temp_min: water_temp = force_increase(water_temp_min, water_temp_max)
    elif water_temp > water_temp_max: water_temp =  force_decrease(water_temp_min, water_temp_max)



    # 99.9% chance of led being same as previous value
    if random.randint(1, 1000) <= 999:
        led = led
    else:
        led = random.choice(["OFF", "ON"])

    # 90% chance of pump being same as previous value
    if random.randint(1, 1000) <= 999:
        pump = pump
    else:
        pump = random.choice(["OFF", "ON"])

    # 90% chance of uv being same as previous value
    if random.randint(1, 1000) <= 999:
        uv = uv
    else:
        uv = random.choice(["OFF", "ON"])

    # 90% chance of water_level being same as previous value
    if random.randint(1, 100) <= 99:
        water_level = water_level
    else:
        water_level = random.choice(["L", "M", "H"])

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
# Firebase_database['UsersData']['9VKdbC8eQNSez2wD8CQbQ1bHGqt1']['readings'] = _data
Firebase_database['UsersData']['V9cbUq9BIzLqPzL9dEhQzO2JRYG2']['readings'] = _data

# write final firebase JSON data to file
with open('readingsdata.json', 'w') as f:
    json.dump(Firebase_database, f, indent=4)