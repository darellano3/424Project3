#!/usr/bin/python

import pandas as pd
import requests
import os

class JSON_AOT_Parser:
    # CONSTANT endpoints for AOT
    NODES_ENDPOINT = 'https://api.arrayofthings.org/api/nodes?200'
    SENSORS_ENDPOINT = 'https://api.arrayofthings.org/api/sensors?200'
    OBSERVATIONS_ENDPOINT = 'https://api.arrayofthings.org/api/observations?size=5000'

    def __init__(self):
        # nodes dataframe
        r = requests.get(self.NODES_ENDPOINT)
        data = r.json()['data']
        self.nodes = pd.DataFrame(data)

        # sensors dataframe
        r = requests.get(self.SENSORS_ENDPOINT)
        data = r.json()['data']
        self.sensors = pd.DataFrame(data)

        # observations dataframe
        r = requests.get(self.OBSERVATIONS_ENDPOINT)
        data = r.json()['data']
        self.observations = pd.DataFrame(data)

    def processNodes(self):
        lats = []
        longs = []
        for row in self.nodes.itertuples(index=True, name='Pandas'):
            lats.append(row.location.get('geometry', {}).get('coordinates')[0])
            longs.append(row.location.get('geometry', {}).get('coordinates')[1])
        self.nodes['latitude'] = lats
        self.nodes['longitude'] = longs
        self.nodes = self.nodes.drop(['location'], axis=1)
        self.nodes = self.nodes[self.nodes.address != 'TBD']
        self.nodes = self.nodes[self.nodes.address != 'Georgia Tech']


    def processSensors(self):
        pass

    def processObservations(self):
        pass

def main():
    parser = JSON_AOT_Parser()
    parser.processNodes()

    # write dataframes to csv
    # linux
    if False: #os.name == 'posix: # replace 'False' with comment predicate
        parser.nodes.to_csv('data/nodes.csv')
        parser.sensors.to_csv('data/sensors.csv')
        parser.observations.to_csv('data/observations.csv')
    else: # windows
        parser.nodes.to_csv('data\\nodes.csv')
        parser.sensors.to_csv('data\\sensors.csv')
        parser.observations.to_csv('data\\observations.csv')

if __name__ == '__main__':
    main()
