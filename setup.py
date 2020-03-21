#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import io
import subprocess

from setuptools import find_packages, setup, Command

# Package meta-data.
NAME = 'quop_mpi'
DESCRIPTION = 'A framework for simulation of the QAOA algorithms.'
URL = 'https://github.com/Edric-Matwiejew/QuOp_MPI'
EMAIL = 'Edric.Matwiejew@research.uwa.au'
AUTHOR = 'Edric Matwiejew'
REQUIRES_PYTHON = '>=3.6.0'
VERSION = '0.0.2'

# What packages are required for this module to be exeuted?
REQUIRED = [
        'numpy', 'scipy', 'mpi4py', 'h5py', 'networkx']

# What packages are optional?
EXTRAS = {}

EXTENSION = subprocess.run(
        ['python3-config --extension-suffix'],
        shell = True,
        stdout = subprocess.PIPE).stdout.decode('utf-8').strip()

here = os.path.abspath(os.path.dirname(__file__))

with io.open(os.path.join(here, 'README.md'), encoding = 'utf-8') as f:
    long_description = '\n' + f.read()

setup(
        name = NAME,
        version = VERSION,
        description = DESCRIPTION,
        long_description = long_description,
        long_description_content_type = 'text/markdown',
        author = AUTHOR,
        author_email = EMAIL,
        python_requires = REQUIRES_PYTHON,
        url = URL,
        packages = find_packages(),
        package_data = {
            'quop_mpi': ['*' + EXTENSION],
            },
        install_requires = REQUIRED,
        extras_require = EXTRAS,
        license = 'GPLv3',
        )

