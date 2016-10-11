from measurement_logger.measurement_logger import MeasurementLogger
import pymysql as PyMySQL
import ast
import _thread
import collections
import json
import numpy as np


class MySQLMeasurementLogger(MeasurementLogger):

    def mysql_thread(self,event_name, event_values):
        query_values = []
        for entry in event_values:
            query_values.append(str(entry))
        print("QUERY: " + str(self.queries[event_name]%tuple(query_values)))
        connection = PyMySQL.connect(user=self.db_username, password=self.db_password, host=self.db_host, database=self.db_name)
        cursor = connection.cursor()
        cursor.execute(self.queries[event_name], query_values)
        connection.commit()
        cursor.close()
        connection.close()

    def __init__(self, facility, program_name, group_name, db_host, db_name, db_username = 'root', db_password = 'root', measurement_definitions = None ):
        self.facility = facility
        self.program_name = program_name
        self.group_name = group_name
        self.queries = {}
        if measurement_definitions != None:
            decoder = json.JSONDecoder(object_pairs_hook=collections.OrderedDict)
            measurement_definitions = ast.literal_eval(measurement_definitions)
            self.measurement_names = measurement_definitions.keys()
            for key in self.measurement_names:
                self.queries[key] = "INSERT INTO " + key + " ("
                measurement_keys = decoder.decode("{\"" + measurement_definitions[key].replace(" ", "\",\"").replace(":","\":\"") + "\"}")
                for element in measurement_keys:
                    self.queries[key] += element + ","
                self.queries[key] = self.queries[key][:-1] + ") VALUES (" + ("%s,"*len(measurement_keys))[:-1] + ")"
        else:
            self.measurement_names = []
        pass
        self.connection = None
        self.db_host = db_host
        self.db_name = db_name
        self.db_username = db_username
        self.db_password = db_password

    def log_measurement(self, event_name, event_value):
        try:
            _thread.start_new_thread(self.mysql_thread, (event_name, event_value,))
        except Exception as e:
            self.log.info("Error: unable to start thread (" + str(e) + ")")
        pass

    def start_logging(self):
        pass

    def stop_logging(self):
        pass
