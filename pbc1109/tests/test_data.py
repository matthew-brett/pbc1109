""" Testing data module

"""

import os
from tempfile import mkstemp

import numpy as np

from nose.tools import assert_true, assert_false, \
    assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import pbc1109.data as pd

data_path = os.path.join(os.path.dirname(__file__), 'data')


def test_load_txt():
    inp_str = \
'''one value   another
1  1.5  1.7  
'''
    try:
        fd, fname = mkstemp()
        os.fdopen(fd, 'wt').write(inp_str)
        vals = pd.load_txt(fname)
        yield assert_equal, vals, [['one value', 'another'],
                                   ['1', '1.5', '1.7']]
    finally:
        os.unlink(fname)


def test_example_data():
    ds = pd.PBCData(data_path)
    # this data does exist
    md = ds.get_data(3, 5)
    labels = md.labels
    yield assert_array_equal, labels, [[1, 1],
                                       [2, 0],
                                       [3, 3],
                                       [4, 6],
                                       [5, 8]]
    yield assert_equal, md.bundle_ids, [['0', 'a bundle name'],
                                        ['1', 'another bundle name']]
    
    streams = md.streams
    yield assert_equal, len(streams), 2
    yield assert_equal, md.hdr['id_string'], 'TRACK'
    # this data does not
    md = ds.get_data(2, 3)
    yield assert_equal, md.labels, None
    yield assert_equal, md.streams, None
    yield assert_equal, md.hdr, None
    yield assert_equal, md.bundle_ids, None
