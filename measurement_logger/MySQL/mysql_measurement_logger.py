from measurement_logger.measurement_logger import MeasurementLogger
import mysql.connector
import ast
import _thread


class MySQLMeasurementLogger(MeasurementLogger):

    def mysql_thread(self,event_name, event_values):
        cursor = self.connection.cursor()
        cursor.execute(self.queries[event_name], event_values)
        self.connection.commit()
        cursor.close()

    def __init__(self, facility, program_name, group_name, measurement_definitions = None ):
        self.facility = facility
        self.program_name = program_name
        self.group_name = group_name
        self.queries = {}
        if measurement_definitions != None:
            self.measurement_names = measurement_definitions.keys()
            for key in self.measurement_names:
                self.queries[key] = "INSERT INTO " + key + " ("
                measurement_keys = ast.literal_eval("{'" + measurement_definitions[key].replace(" ", "','").replace(":","':'") + "'}")
                for element in measurement_keys:
                    self.queries[key] += element + ","
                self.queries[key] += ") VALUES (" + "%u,"*len(measurement_keys) + ")"
        else:
            self.measurement_names = []
        pass
        self.connection = None

    def log_measurement(self, event_name, event_value):
		try:
			_thread.start_new_thread(self.mysql_thread, (event_name, event_value,))
		except Exception as e:
			self.log.info("Error: unable to start thread (" + str(e) + ")")
		pass

    def start_logging(self, db_host, db_name, db_username = 'root', db_password = 'root'):
        self.connection = mysql.connector.connect(user=db_username, password=db_password, host=db_host, database=db_name)
        pass

    def stop_logging(self):
        self.connection.close()
        pass
