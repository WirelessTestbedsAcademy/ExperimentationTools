import abc
import logging


class MeasurementLogger():
    __metaclass__ = abc.ABCMeta

    def __init__(self, measurement_db_name, measurement_definitions):
        self.measurement_db_name = measurement_db_name
        self.measurement_definitions = measurement_definitions
        self.log = logging.getLogger("MeasurementLogger")

    @abc.abstractmethod
    def start_logging(self):
        pass

    @abc.abstractmethod
    def log_measurement(self, name, value):
        pass

    @abc.abstractmethod
    def stop_logging(self):
        pass
