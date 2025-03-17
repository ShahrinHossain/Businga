import json
import requests

# Load user data from JSON file
with open('users.json', 'r') as file:
    users_data = json.load(file)

# Define the API endpoint URL for registration
url = "http://127.0.0.1:8000/users/register/"  # Update this URL based on your Django server

# Loop through each user and send a POST request
for user in users_data:
    response = requests.post(url, json=user)

    # Check the response status
    if response.status_code == 201:
        print(f"Successfully created user: {user['username']}")
    else:
        print(f"Failed to create user: {user['username']}")
        print(f"Status code: {response.status_code}, Response: {response.json()}")
