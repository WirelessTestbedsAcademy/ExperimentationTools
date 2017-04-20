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

    @classmethod
    def load_config(cls, config):
        measurement_config = config['measurement_config']
        module_name = measurement_config['module']
        class_name = measurement_config['class_name']
        py_module = __import__(module_name)
        globals()[module_name] = py_module
        module_class = getattr(py_module, class_name)
        module = module_class(**measurement_config['kwargs'])
        return module
