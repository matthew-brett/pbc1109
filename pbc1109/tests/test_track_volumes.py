""" Testing 

"""

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import pbc1109.track_volumes as tv
#import pbc1109.tvs as tv

def tracks_to_expected(tracks, vol_dims):
    expected = np.zeros(vol_dims, dtype=np.uint16)
    for t in tracks:
        ti = np.round(t).astype(np.int32)
        for p in ti:
            expected[tuple(p)] +=1
    return expected


def test_track_volumes():
    vol_dims = (1, 2, 3)
    tracks = ([[0, 0, 0],
               [0, 1, 1]],)
    tracks = [np.array(t) for t in tracks]
    expected = tracks_to_expected(tracks, vol_dims)
    tcs = tv.track_counts(tracks, vol_dims, [1,1,1])
    yield assert_array_equal, tcs, expected

    vol_dims = (5, 10, 15)
    tracks = ([[0, 0.1, 0],
               [1, 1, 1],
               [2, 2, 2]],
              [[0.7, 0, 0],
               [1, 1, 1],
               [1, 2, 2]])
    tracks = [np.array(t) for t in tracks]
    expected = tracks_to_expected(tracks, vol_dims)
    tcs = tv.track_counts(tracks, vol_dims, [1,1,1])
    yield assert_array_equal, tcs, expected
    
               
              
def test_unique_elements():
    vol_dims = np.array((5, 10, 15))
    track = np.array([
            [-1, 0, 0],
            [0, 0, 0],
            [1, 1, 1],
            [1, 1, 1],
            [2, 0, 0],
            [2, 2, 2],
            [6, 2, 2]])
    n = track.shape[0]
    expected_u_els = []
    up_dims = np.tile(vol_dims, (n, 1))
    for pno in (1, 2, 4, 5, 6): # unique point indices
        t = track[pno]
        t[t<0] = 0
        too_high = t >= vol_dims
        t[too_high] = vol_dims[too_high]
        x, y, z = t
        expected_u_els.append(
            x +
            y*vol_dims[0] +
            z*vol_dims[0]*vol_dims[1])
    expected_u_els.sort()
    u_els = tv._unique_elements(track, vol_dims)
    yield assert_array_equal, u_els, expected_u_els
             
