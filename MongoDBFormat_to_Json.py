import datetime
import pymongo
import json
import os
import glob

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

# iterate over all collections and find all documents of each collection
print("---fetch relevant data---")
for col in collections:
    cursor = col.find(
        {'timestamp': {'$lt': datetime.datetime.now(),
                       '$gt': datetime.datetime.now() - datetime.timedelta(days=20)}})

    # append all documents to a list
    docs = []
    for doc in list(cursor):
        docs.append(doc)

    # create a directory for the current collection
    os.mkdir(os.path.join(os.getcwd(), col.name))

    # convert the document list to json format and write it to a file
    complete_json = json.dumps(docs, default=str, indent=4)
    with open(os.path.join(col.name, filename_timestamp.strftime('%Y%m%d_%H%M%S') + '.json'), 'w') as f:
        f.write(complete_json)

# ============================================================
# rework the created json files

# access the json files in the subdirectories
json_files = glob.glob('**/*.json')

new_objects = []  # this list will contain the reworked json objects
# iterate over all json files
for file in json_files:
    data = json.loads(open(file).read())
    # iterate over all objects in the current json file
    for obj in data:
        obj['id'] = obj.pop('_id')  # renaming is impossible, so you have to add a new key and copy the value
        del obj['timestamp']
        # iterate over all keys in the current object
        for key in obj:
            print(obj[key])  # here the key value pairs have to be reworked
        # append the reworked object
        new_objects.append(obj)

    # write the reworked objects to the file
    with open(file, 'w') as f:
        f.write(json.dumps(new_objects, default=str, indent=4))
