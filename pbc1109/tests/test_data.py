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

import pbc1109.venn as venn

def test_confusion_matrix():
    cm = venn.ConfusionMatrix(np.array([[0,0],[0,0],[1,1],[1,2]]))
    yield assert_array_almost_equal, cm.counts, np.array([[ 2.,  0.,  0.],[ 0.,  1.,  1.]])
    ds = pd.PBCData('/home/ian/Data/PBC/pbc2009icdm')
    expert_labels = ds.get_data(1,1).labels[:,1]
    np.random.seed(0)
    random_labels = np.random.randint(12,size=250000)
    cm=venn.ConfusionMatrix(np.c_[expert_labels,random_labels])
    yield assert_array_almost_equal, cm.counts[5,8], 97.0

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
