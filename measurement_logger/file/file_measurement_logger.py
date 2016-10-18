from measurement_logger.measurement_logger import MeasurementLogger
import datetime


class FileMeasurementLogger(MeasurementLogger):
    def __init__(self, measurement_db_name, measurement_definitions, directory):
        super(FileMeasurementLogger, self).__init__(measurement_db_name, measurement_definitions)
        self.filenames = []
        for key in self.measurement_definitions:
            self.filenames.append(measurement_db_name + "_upi_" + key)
        self.file_writers = {}
        self.directory = directory
        pass

    def log_measurement(self, name, value):
        self.log.debug("{};{}".format(datetime.datetime.now(), value))
        self.file_writers[name].write("{};{}\n".format(datetime.datetime.now(), value))
        pass

    def start_logging(self):
        for fname in self.filenames:
            self.file_writers[fname] = open(self.directory + fname, 'a')
        pass

    def stop_logging(self):
        for fname in self.filenames:
            self.file_writers[fname].close()
        pass
