from measurement_logger.measurement_logger import MeasurementLogger
import datetime


class STDOUTMeasurementLogger(MeasurementLogger):
    def __init__(self, measurement_db_name, measurement_definitions = None):
        super(STDOUTMeasurementLogger, self).__init__(measurement_db_name, measurement_definitions)
        pass

    def log_measurement(self, name, value):
        self.log.info("{} ({}): {}".format(name, self.measurement_db_name, value))
        pass

    def start_logging(self):
        pass

    def stop_logging(self):
        pass
