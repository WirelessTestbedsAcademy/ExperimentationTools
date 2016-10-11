import logging
import datetime

from measurement_logger.measurement_logger import MeasurementLogger

class STDOUTMeasurementLogger(MeasurementLogger):
    def __init__(self, facility, program_name, group_name, measurement_definitions = None):
        """ Function doc """
        FORMAT = '%(asctime)-15s %(message)s'
        logging.basicConfig(format=FORMAT)
        self.log = logging.getLogger()
        self.log.setLevel(logging.INFO)
        self.facility = facility
        self.program_name = program_name
        self.group_name = group_name
        if measurement_definitions != None:
            self.measurement_names = measurement_definitions.keys()
        else:
            self.measurement_names = []
        pass

    def log_measurement(self, name, value):
        print("{}: {} @ {} received msg {}".format(datetime.datetime.now(), self.program_name, self.facility, value))
        pass

    def start_logging(self):
        pass

    def stop_logging(self):
        pass
