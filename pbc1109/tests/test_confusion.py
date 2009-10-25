import numpy as np

import pbc1109.data as pd

import pbc1109.venn as venn

from nose.tools import assert_true, assert_false, \
    assert_equal, assert_raises

from numpy.testing import assert_array_almost_equal

def test_confusion_matrix():
    cm = venn.ConfusionMatrix(np.array([[0,0],[0,0],[1,1],[1,2]]))
    yield assert_array_almost_equal, cm.counts, np.array([[ 2.,  0.,  0.],[ 0.,  1.,  1.]])
    yield assert_array_almost_equal, cm.row_counts, np.array([2,2])
    yield assert_array_almost_equal, cm.col_counts, np.array([2,1,1])

'''
cm = venn.ConfusionMatrix(np.array([[0,0],[0,0],[1,1],[1,2]]))

Scoring fibre bundle label 1
Number of overlapping bundles is 2
Score 1.000000
[[ 0.  0.]
 [ 1.  2.]]
'''
