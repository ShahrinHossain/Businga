import json
import requests

# Load data from JSON file
with open('stoppages.json', 'r') as file:
    stoppages_data = json.load(file)

# Define the API endpoint URL
url = "http://127.0.0.1:8000/users/add-stoppage/"  # Update this URL based on your Django server

# Loop through each stoppage and send a POST request
for stoppage in stoppages_data:
    response = requests.post(url, json=stoppage)

    # Check the response status
    if response.status_code == 201:
        print(f"Successfully created stoppage: {stoppage['name']}")
    else:
        print(f"Failed to create stoppage: {stoppage['name']}")
        print(f"Status code: {response.status_code}, Response: {response.json()}")
