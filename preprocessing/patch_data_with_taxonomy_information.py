#!/usr/bin/env python

"""

Usage: patch_data_with_taxonomy_information.py <data_file> <tax_file>

"""

import sys
import json
from docopt import docopt

if __name__ == '__main__':
    arguments = docopt(__doc__)
    with open(arguments['<data_file>']) as fp:
        data = json.load(fp)
    with open(arguments['<tax_file>']) as fp:
        tax = fp.readlines()
        tax = [i.strip().split() for i in tax]
        
    for layer in data:
      for field in data[layer]:
        if field == 'related-species':
          for species in data[layer][field]:
            for name in tax:
              if name[0] == species[0]:
                species.append(name[1])

    with open(arguments['<data_file>'], 'w') as fp:
      fp.write(json.dumps(data))