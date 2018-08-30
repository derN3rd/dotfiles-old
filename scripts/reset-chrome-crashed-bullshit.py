#!/usr/bin/python3

import json

with open("/home/max/.config/google-chrome/Default/Preferences", "r+") as f:
    data = json.load(f)
    data["exit_type"] = "none"
    data["exited_cleanly"] = True

with open("/home/max/test.json", 'w') as f:
    json.dump(data, f)
