#!/usr/bin/env python
''' Installation script for pbc1109 package '''
from os.path import join as pjoin
from glob import glob
from distutils.core import setup
from distutils.extension import Extension

import numpy as np

from build_helpers import make_cython_ext

# we use cython to compile the module if we have it
try:
    import Cython
except ImportError:
    has_cython = False
else:
    has_cython = True
    
tv_ext, cmdclass = make_cython_ext(
    'pbc1109.track_volumes',
    has_cython,
    include_dirs = [np.get_include()])


setup(name='pbc1109',
      version='0.1a',
      description='Routines for the Pittsburgh brain connectivity'
                  'competition November 2009',
      author='PBC python team',
      author_email='matthew.brett@gmail.com',
      url='http://github.com/matthew-brett/pbc1109',
      packages=['pbc1109'],
      package_data={'pbc1109': ['tests/data/brain3/*',
                                'tests/*.py']},
      ext_modules = [tv_ext],
      cmdclass    = cmdclass,
      scripts=glob('scripts/*.py')
      )
