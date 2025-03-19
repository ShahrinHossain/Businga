import json
import requests

# Define the API endpoint
url = "http://127.0.0.1:8000/users/add-bus/"  # Update this if necessary

# List of bus data
buses_data = [
    {
        "registration_no": "Dhaka-1234",
        "condition": "Good",
        "ac_status": True,
        "location": "Mohakhali Bus Terminal",
        "company_id": 1
    },
    {
        "registration_no": "Chattogram-5678",
        "condition": "Average",
        "ac_status": False,
        "location": "Kamalapur Bus Stand",
        "company_id": 1
    },
    {
        "registration_no": "Rajshahi-9101",
        "condition": "Excellent",
        "ac_status": True,
        "location": "Gabtoli Terminal",
        "company_id": 1
    }
]

# Loop through each bus and send a POST request
for bus in buses_data:
    response = requests.post(url, json=bus)

    # Check the response status
    if response.status_code == 201:
        print(f"✅ Successfully added bus: {bus['registration_no']}")
    else:
        print(f"❌ Failed to add bus: {bus['registration_no']}")
        print(f"Status code: {response.status_code}, Response: {response.text}")  # Debugging info
