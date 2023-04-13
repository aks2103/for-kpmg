import json

# defines a function get_value that searches for a specific key in a nested JSON object and returns its value if found.

def get_value(nested_obj, search_key):
    if search_key in nested_obj:
        return nested_obj[search_key]
    for k, v in nested_obj.items():
        if isinstance(v, dict):
            item = get_value(v, search_key)
            if item is not None:
                return item


# loads a JSON file named "data.json" and stores its contents in a variable named nested_obj using the json.load function.
with open('data.json', 'r') as file:
    nested_obj = json.load(file)

# enter a key to search for within the JSON object, which is stored in the search_key variable.
search_key = input("Enter key: ")
result = get_value(nested_obj, search_key)
print(result)