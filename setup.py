#!/usr/bin/env python
''' Installation script for pbc1109 package '''
from glob import glob
from distutils.core import setup

setup(name='pbc1109',
      version='0.1a',
      description='Routines for the Pittsburgh brain connectivity'
                  'competition November 2009',
      author='PBC python team',
      author_email='matthew.brett@gmail.com',
      url='http://github.com/matthew-brett/pbc1109',
      packages=['pbc1109'],
      scripts=glob('scripts/*.py')
      )

