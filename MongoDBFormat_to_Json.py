import datetime
import pymongo
import json


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
collections = []
collections.append(database.get_collection("Krankheiten"))
collections.append(database.get_collection("Krankheitstyp"))
collections.append(database.get_collection("Pferdegeschlecht"))
collections.append(database.get_collection("Pferderasse"))
collections.append(database.get_collection("Symptom"))


# ============================================================
# write the data of all collections to a separate json file

# iterate over all collections and find all documents of each collection
print("---fetch relevant data---")
for col in collections:
    cursor = col.find(
        {'timestamp':{'$lt':datetime.datetime.now(),
            '$gt':datetime.datetime.now() - datetime.timedelta(days=20)}})

    # append all documents to a list
    docs = []
    for doc in list(cursor):
        docs.append(doc)

    # convert the list to json format and write it to a file
    complete_json = json.dumps(docs, default=str, indent=4)
    with open('json-data</' + col.name + '.json', 'w') as f:
        f.write(complete_json)
