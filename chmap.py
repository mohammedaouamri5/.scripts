import os
import argparse
 

use =  lambda __map : f"""
input {'{'}
    kb_layout = {__map}
{'}'}
"""
defult_map = "fr"

def set_KEYMAP(__map): 
    file_path = os.path.join(
        os.path.expanduser("~"),
        '.config', 
        'hypr', 
        'langage.conf'
        )    
    with open(file_path, mode="w") as file:
        file.write(
            use(__map)
        )
    with open(os.path.expanduser("~")+"/"+'.scripts/KEYMAP', mode="w") as file:
        file.write(
            __map
        )




MAPS = ["fr", "en", "ara"]



def chmap():  
    with open(os.path.expanduser("~")+"/"+'.scripts/KEYMAP', mode="r") as file:
        KEYMAP = file.read()
    KEYMAP = KEYMAP
    index = MAPS.index(KEYMAP)
    _next = MAPS[(index+1)%len(MAPS)]
    print(_next)
    set_KEYMAP(_next)

chmap()