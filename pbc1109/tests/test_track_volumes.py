""" Testing 

"""

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import pbc1109.track_volumes as tv
import pbc1109

def test_track_indices_asdict():
    vol_dims = (5, 10, 15)
    tracks = ([[0, 0.1, 0],[1, 1, 1], [2, 2, 2]], [[0.7, 0, 0], [1, 1, 1],[1, 2, 2]])
    tracks = [np.array(t) for t in tracks]
    vold=pbc1109.track_indices_asdict(tracks,vol_dims)
    yield assert_equal, len(vold[(1,1,1)]), 2    
    

def tracks_to_expected(tracks, vol_dims):
    # simulate expected behavior of module
    vol_dims = np.array(vol_dims, dtype=np.int32)
    counts = np.zeros(vol_dims, dtype=np.int32)
    elements = {}
    for t_no, t in enumerate(tracks):
        u_ps = set()
        ti = np.round(t).astype(np.int32)
        for p_no, p in enumerate(ti):
            if np.any(p < 0):
                p[p<0] = 0
            too_high = p >= vol_dims
            if np.any(too_high):
                p[too_high] = vol_dims[too_high]-1
            p = tuple(p)
            if p in u_ps:
                continue
            u_ps.add(p)
            val = t_no
            if counts[p]:
                elements[p].append(val)
            else:
                elements[p] = [val]
            counts[p] +=1
    return counts, elements


def test_track_volumes():
    # simplest case
    vol_dims = (1, 2, 3)
    tracks = ([[0, 0, 0],
               [0, 1, 1]],)
    tracks = [np.array(t) for t in tracks]
    ex_counts, ex_els = tracks_to_expected(tracks, vol_dims)
    tcs, tes = tv.track_counts(tracks, vol_dims, [1,1,1])
    yield assert_array_equal, tcs, ex_counts
    yield assert_array_equal, tes, ex_els
    # check only counts returned for return_elements=False
    tcs = tv.track_counts(tracks, vol_dims, [1,1,1], False)
    yield assert_array_equal, tcs, ex_counts

    # non-unique points, non-integer points, points outside
    vol_dims = (5, 10, 15)
    tracks = ([[-1, 0, 1],
               [0, 0.1, 0],
               [1, 1, 1],
               [1, 1, 1],
               [2, 2, 2]],
              [[0.7, 0, 0],
               [1, 1, 1],
               [1, 2, 2],
               [1, 11, 0]])
    tracks = [np.array(t) for t in tracks]
    ex_counts, ex_els = tracks_to_expected(tracks, vol_dims)
    tcs, tes = tv.track_counts(tracks, vol_dims, [1,1,1])
    yield assert_array_equal, tcs, ex_counts
    yield assert_array_equal, tes, ex_els
    # points with non-unit voxel sizes
    vox_sizes = [1.4, 2.1, 3.7]
    float_tracks = []
    for t in tracks:
        float_tracks.append(t * vox_sizes)
    tcs, tes = tv.track_counts(float_tracks, vol_dims, vox_sizes)
    yield assert_array_equal, tcs, ex_counts
    yield assert_array_equal, tes, ex_els
    
               
              
             
