#!/usr/bin/env python

"""Data patcher

Usage:
    patch_data_with_env_contributions.py <data_file> <env_stats_file> <irma_mappings_file>

"""
import sys
import json
from docopt import docopt

if __name__ == '__main__':
    arguments = docopt(__doc__)
    with open(arguments['<data_file>']) as fp:
        data = json.load(fp)
    with open(arguments['<irma_mappings_file>']) as fp:
        irma_mappings = json.load(fp)
    with open(arguments['<env_stats_file>']) as fp:
        temp = fp.readlines()
        temp = [i.strip().split() for i in temp]
        
        env_stats = {}
        for i in temp:
            if i[0] in env_stats:
                env_stats[i[0]].append([i[1], i[2]])
            else:
                env_stats[i[0]] = [[i[1], i[2]]]

    for k, v in data.iteritems():
        if k in env_stats:
            data[k]['related-species'] = []
            for i, species in enumerate(env_stats[k]):
                latin = env_stats[k][i][0]
                contrib = env_stats[k][i][1]
                id = irma_mappings[latin]['id']
                common = irma_mappings[latin]['common']
                data[k]['related-species'].append([latin, id, common, contrib])

    with open(arguments['<data_file>'], 'w') as fp:
        json.dump(data, fp, indent=4, separators=(',', ': '))
            

    




