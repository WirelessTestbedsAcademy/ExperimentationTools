from setuptools import setup, find_packages

def readme():
    with open('README.md') as f:
        return f.read()

setup(
    name='measurement_tools',
    version='0.1.0',
    package_dir={
        'measurement_logger': 'measurement_logger',
        'mysql_measurement_logger': 'measurement_logger/mysql_logger',
        'oml_measurement_logger': 'measurement_logger/oml_logger',
        'file_measurement_logger': 'measurement_logger/file_logger',
        'stdout_measurement_logger': 'measurement_logger/stdout_logger'},
    packages=['measurement_logger', 'mysql_measurement_logger', 'oml_measurement_logger', 'file_measurement_logger', 'stdout_measurement_logger'],
    url='',
    license='',
    author='Jan Bauwens, Peter Ruckebusch',
    author_email='jan.bauwens@intec.ugent.be, peter.ruckebusch@intec.ugent.be',
    description='Measurement logger implementations',
    long_description='Implementation of different measurements loggers (OML, MySQL, stdout, etc).',
    keywords='measurement logger',
    install_requires=['pymysql', 'oml4py'],
)
