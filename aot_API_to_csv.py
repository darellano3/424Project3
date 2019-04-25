#!/usr/bin/env python3

import pandas as pd
import requests

class JSON_AOT_Parser:
    # CONSTANT endpoints for AOT
    NODES_ENDPOINT = 'https://api.arrayofthings.org/api/nodes?size=200'
    SENSORS_ENDPOINT = 'https://api.arrayofthings.org/api/sensors?size=200'
    OBSERVATIONS_ENDPOINT = 'https://api.arrayofthings.org/api/observations?size=5000'

    def __init__(self):
        # nodes dataframe
        r = requests.get(self.NODES_ENDPOINT)
        data = r.json()['data']
        self.nodes = pd.DataFrame(data)
        # clean node data (Chicago only)
        self.processNodes()

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

    # write dataframes to csv
    parser.nodes.to_csv('nodes.csv')
    parser.sensors.to_csv('sensors.csv')
    parser.observations.to_csv('observations.csv')

if __name__ == '__main__':
    main()
