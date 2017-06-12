from measurement_logger.measurement_logger import MeasurementLogger
import pymysql as PyMySQL
import _thread


class MySQLMeasurementLogger(MeasurementLogger):

    def create_experiment_entry(self, experiment_name="wishful_test"):
        connection = PyMySQL.connect(user=self.db_username, password=self.db_password, host=self.db_host, database=self.measurement_db_name)
        cursor = connection.cursor()
        cursor.execute("INSERT INTO experiments (experiment_name) VALUES (%s)", experiment_name)
        connection.commit()
        experiment_id=cursor.lastrowid
        cursor.close()
        connection.close()
        return experiment_id

    def __init__(self, measurement_db_name, measurement_definitions, db_host, db_username='root', db_password='root'):
        super(MySQLMeasurementLogger, self).__init__(measurement_db_name, measurement_definitions)
        self.queries = {}
        # decoder = json.JSONDecoder(object_pairs_hook=collections.OrderedDict)
        # measurement_definitions = ast.literal_eval(measurement_definitions)
        # measurement_names = measurement_definitions.keys()
        for key in measurement_definitions:
            self.queries[key] = "INSERT INTO " + key + " (experiment_id,"
            for element in measurement_definitions[key].split(" "):
                self.queries[key] += element.split(":")[0] + ","
            self.queries[key] = self.queries[key][:-1] + ") VALUES (%s," + ("%s," * len(measurement_definitions[key].split(" ")))[:-1] + ")"
        print(self.queries)
        self.db_host = db_host
        self.db_username = db_username
        self.db_password = db_password
        self.experiment_id = self.create_experiment_entry()

    def mysql_thread(self, name, values):
        query_values = []
        for entry in values:
            query_values.append(str(entry))
        self.log.debug("QUERY: " + str(self.queries[name] % tuple([self.experiment_id] + query_values)))
        connection = PyMySQL.connect(user=self.db_username, password=self.db_password, host=self.db_host, database=self.measurement_db_name)
        cursor = connection.cursor()
        cursor.execute(self.queries[name], [self.experiment_id] + query_values)
        connection.commit()
        cursor.close()
        connection.close()

    def log_measurement(self, name, value):
        try:
            _thread.start_new_thread(self.mysql_thread, (name, value,))
        except Exception as e:
            self.log.info("Error: unable to start thread (" + str(e) + ")")
        pass

    def start_logging(self):
        pass

    def stop_logging(self):
        pass
