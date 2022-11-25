import datetime
import shutil

import pymongo
import json
import os
import glob
import re

filename_timestamp = datetime.datetime.now()  # provisional timestamp used for file naming; not final

# ============================================================
# define link to MongoDB client and name of the database
client_link = "mongodb+srv://HamidO:123Hamid123@cluster0.f2htr.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
database_name = "TierhalterApp"


# ============================================================
# connect to the database
print("---connecting to mongoDB---")
client = pymongo.MongoClient(client_link)  # access the MongoDB client
database = client.get_database(database_name)  # access the given database

# access all the different collections
collections = [database.get_collection("Krankheiten"), database.get_collection("Krankheitstyp"),
               database.get_collection("Pferdegeschlecht"), database.get_collection("Pferderasse"),
               database.get_collection("Symptom")]


# ============================================================
# write the data of all collections to a separate json file

# iterate over all collections
print("---fetch relevant data---")
for col in collections:
    # find all documents of the last 20 days
    cursor = col.find(
        {'timestamp': {'$lt': datetime.datetime.now(),
                       '$gt': datetime.datetime.now() - datetime.timedelta(days=20)}})

    # append all documents to a list
    docs = []
    for doc in list(cursor):
        docs.append(doc)

    # create a directory for the current collection
    dir_path = os.path.join(os.getcwd(), col.name)
    if os.path.exists(dir_path):
        shutil.rmtree(dir_path)
    os.mkdir(dir_path)

    # convert the document list to json format and write it to a file
    complete_json = json.dumps(docs, default=str, indent=4)
    with open(os.path.join(col.name, filename_timestamp.strftime('%Y%m%d_%H%M%S') + '.json'), 'w') as f:
        f.write(complete_json)


# ============================================================
# rework the created json files

# access the json files in the subdirectories
json_files = glob.glob('**/*.json')

# iterate over all json files
for file in json_files:
    new_objects = []  # this list will contain the reworked json objects
    with open(file, 'r') as f:
        json_data = json.load(f)
        # iterate over all objects (dictionaries) in the file
        for obj in json_data:
            # filter out every key value pair where the value is null or an empty list
            new_object_data = {k: v for k, v in obj.items() if v}
            # iterate over all keys in the 'new' dictionary
            for key in new_object_data:
                if isinstance(new_object_data[key], list):
                    try:
                        new_object_data[key] = list(map(int, new_object_data[key]))
                    except:
                        pass
                else:
                    try:
                        new_object_data[key] = int(new_object_data[key])
                    except:
                        pass
            del new_object_data['timestamp']
            new_object_data['id'] = new_object_data.pop('_id')
            new_objects.append(new_object_data)

    with open(file, 'w', encoding='cp1252') as f:
        f.write(json.dumps(new_objects, indent=4, ensure_ascii=False))


# ============================================================
# update 'versions.json'

versions = {}
with open('versions.json', 'r') as v:
    versions = json.load(v)

for file in json_files:
    with open(file, 'r') as f:
        file_data = json.load(f)
        if file_data:
            dir_name = re.findall(r'^.*?\\', file)[0][:-1]
            versions[dir_name] = filename_timestamp

with open('versions.json', 'w') as v:
    v.write(json.dumps(versions, default=str, indent=4))
