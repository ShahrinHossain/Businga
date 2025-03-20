import json
import requests

# Load data from routes.json file
with open('routes.json', 'r') as file:
    routes_data = json.load(file)

# Define the API endpoint URL
url = "http://127.0.0.1:8000/users/add-route/"  # Update this URL based on your Django server

# Loop through each route and send a POST request
for route in routes_data:
    # Prepare the request body
    payload = {
        "stoppages": route["stoppages"]
    }

    # Send the POST request
    response = requests.post(url, json=payload)

    # Check the response status
    if response.status_code == 201:
        print(f"Successfully created route with stoppages: {route['stoppages']}")
    else:
        print(f"Failed to create route with stoppages: {route['stoppages']}")
        print(f"Status code: {response.status_code}, Response: {response.json()}")