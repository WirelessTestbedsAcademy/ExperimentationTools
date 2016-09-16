from measurement_logger.measurement_logger import MeasurementLogger
import oml4py
import socket

def __init__(self, facility, program_name, group_name, measurement_definitions):
    """ Function doc """
    # TODO: SPLIT IN DIFFERENT FILES!!
    self.oml_instance = None
    if facility == 'wilab':
        self.oml_instance = oml4py.OMLBase(program_name, group_name, socket.gethostname(),
                                           "tcp:am.wilab2.ilabt.iminds.be:3004")
    elif facility == 'portable':
        self.oml_instance = oml4py.OMLBase(program_name, group_name, socket.gethostname(),
                                           "tcp:oml.portable.ilabt.iminds.be:3003")
    if self.oml_instance != None:
        for measurement_name in measurement_definitions.keys():
            self.oml_instance.addmp(measurement_name, measurement_definitions[measurement_name])
        self.oml_instance.start()
    pass


def log_measurement(self, name, value):
    if self.oml_instance != None:
        self.oml_instance.inject(name, value)
    pass


def start_logging(self):
    self.oml_instance.start()
    pass


def stop_logging(self):
    self.oml_instance.close()
    pass