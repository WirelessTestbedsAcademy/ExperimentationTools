from setuptools import setup, find_packages

def readme():
    with open('README.md') as f:
        return f.read()

setup(
    name='measurement_tools',
    version='0.1.0',
    packages=find_packages(),
    url='',
    license='',
    author='Jan Bauwens',
    author_email='jan.bauwens@intec.ugent.be',
    description='Measurement logger implementations',
    long_description='Implementation of different measurements loggers (OML, MySQL, stdout, etc).',
    keywords='measurement logger',
)
