import json
import glob


json_files = glob.glob('**/*.json')

# iterate over all json files
for file in json_files:
    new_objects = []  # this list will contain the reworked json objects
    with open(file, 'r') as f:
        json_data = json.load(f)
        # iterate over all objects (dictionaries) in the file
        for obj in json_data:
            # filter out every key value pair where the value is null or an empty list
            new_object_data = {k: v for k, v in obj.items() if v is not None}
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
            new_objects.append(new_object_data)

    with open(file, 'w') as f:
        f.write(json.dumps(new_objects, indent=4))
