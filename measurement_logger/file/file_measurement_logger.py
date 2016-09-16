from measurement_logger.measurement_logger import MeasurementLogger


class FileMeasurementLogger(MeasurementLogger):
    def __init__(self, facility, program_name, group_name, filename, measurement_definitions = None ):
        self.facility = facility
        self.program_name = program_name
        self.group_name = group_name
        if measurement_definitions != None:
            self.measurement_names = measurement_definitions.keys()
        else:
            self.measurement_names = []
        pass
        self.filename = filename
        self.file_writer = None

    def log_measurement(self, name, value):
        self.file_writer.write("%s;%s;%s;%s;%s\n" %( self.facility, self.program_name, self.group_name, name, str(value)))
        pass

    def start_logging(self):
        self.file_writer = open(self.filename,'w')
        pass

    def stop_logging(self):
        self.file_writer.close()
        pass