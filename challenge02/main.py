import os
import json
import subprocess
from dotenv import load_dotenv

load_dotenv()  # load environment variables from .env file

project_id = os.environ.get("PROJECT_ID")
instance_name = os.environ.get("INSTANCE_NAME")
zone = os.environ.get("ZONE")


def get_metadata(project_id, instance_name, zone):
    cmd = f"gcloud compute set project {project_id}"
    cmd = f"gcloud compute instances describe {instance_name} --project={project_id} --zone={zone} --format json > metadata.json"
    subprocess.check_output(cmd, shell=True)
    with open('metadata.json') as f:
        metadata = json.load(f)
    return metadata


metadata = get_metadata(project_id, instance_name, zone)

# get key as user input
search_key = input("Enter key: ")
result = None
if search_key in metadata:
    result = metadata[search_key]
print(result)
