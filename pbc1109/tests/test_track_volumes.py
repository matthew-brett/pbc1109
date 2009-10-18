""" Testing 

"""

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import pbc1109.track_volumes as tv

def test_track_volumes():
    vol_dims = (5, 10, 15)
    tracks = ([[0, 0, 0],
               [1, 1, 1],
               [2, 2, 2]],
              [[1, 0, 0],
               [1, 1, 1],
               [1, 2, 2]])
    tracks = [np.array(t) for t in tracks]
    expected = np.zeros(vol_dims, dtype=np.uint16)
    for t in tracks:
        for p in t:
            expected[p] +=1
    tcs = tv.track_counts(tracks, vol_dims)
    yield assert_array_equal, tcs, expected
    
               
              
