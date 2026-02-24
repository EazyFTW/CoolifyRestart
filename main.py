import os
import requests
import sys

def restart_services():
    api_base = os.getenv("COOLIFY_URL", "https://app.coolify.io")
    api_token = os.getenv("COOLIFY_TOKEN")
    uuids = os.getenv("COOLIFY_UUIDS", "").split(",")

    if not api_token:
        print("Error: COOLIFY_TOKEN is not set.")
        sys.exit(1)

    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json",
        "Accept": "application/json"
    }

    for uuid in uuids:
        uuid = uuid.strip()
        if not uuid:
            continue
            
        print(f"Triggering restart for UUID: {uuid}...")
        url = f"{api_base.rstrip('/')}/api/v1/services/{uuid}/restart"
        
        try:
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                print(f"Successfully triggered restart for {uuid}")
            else:
                print(f"Failed to restart {uuid}: {response.status_code} - {response.text}")
        except Exception as e:
            print(f"Error connecting to API for {uuid}: {e}")

if __name__ == "__main__":
    restart_services()
