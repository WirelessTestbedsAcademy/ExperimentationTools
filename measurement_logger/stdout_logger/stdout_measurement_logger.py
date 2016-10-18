from measurement_logger.measurement_logger import MeasurementLogger
import datetime


class STDOUTMeasurementLogger(MeasurementLogger):
    def __init__(self, measurement_db_name, measurement_definitions):
        super(STDOUTMeasurementLogger, self).__init__(measurement_db_name, measurement_definitions)
        pass

    def log_measurement(self, name, value):
        self.log.info("{}_upi_{}: {};{}".format(self.measurement_db_name, name, datetime.datetime.now(), value))
        pass

    def start_logging(self):
        pass

    def stop_logging(self):
        pass
