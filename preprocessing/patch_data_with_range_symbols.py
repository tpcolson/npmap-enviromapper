#!/usr/bin/env python

"""

Usage: patch_data_with_range_symbols.py <data_file>

"""

import sys
import json
from docopt import docopt

symbols = {
  "con_slope": "°",
  "con_avg_yearly_rainfall": "\"",
  "con_solar_rad": "WH/m^2",
  "con_elevation": "m",
  "con_aspect": "°"
}

if __name__ == '__main__':
    arguments = docopt(__doc__)
    with open(arguments['<data_file>']) as fp:
        data = json.load(fp)
        
    for layer in data:
      for field in data[layer]:
        if field == 'ranges':
          new_range = []
          for r in data[layer][field]:
            new_range.append("[" + str(r[0]) + symbols[layer] + ", " + str(r[1]) + symbols[layer] + "]")
            del r
          data[layer][field] = new_range

    with open(arguments['<data_file>'], 'w') as fp:
      fp.write(json.dumps(data))