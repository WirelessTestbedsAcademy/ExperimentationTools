import abc

from abc import ABC, abstractmethod

class MeasurementLogger(ABC):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def start_logging(self):
        pass
		
    @abc.abstractmethod
    def log_measurement(self, name, value):
        pass

    @abc.abstractmethod
    def stop_logging(self):
        pass
