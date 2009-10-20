''' A type of -*- python -*- file

Counting incidence of tracks in voxels of volume

'''
import numpy as np
cimport numpy as cnp

cdef extern from "math.h":
    double floor(double x)


def track_counts(tracks, vol_dims, vox_sizes):
    ''' Counts of points in `tracks` that pass through voxels in volume

    Parameters
    ----------
    tracks : sequence
       sequence of tracks.  Tracks are ndarrays of shape (N, 3), where N
       is the number of points in that track, and ``tracks[t][n]`` is
       the n-th point in the t-th track.  Points are of form x, y, z in
       *mm* coordinates.
    vol_dim : sequence length 3
       volume dimensions in voxels, x, y, z.
    vox_sizes : sequence length 3
       voxel sizes in mm

    Returns
    -------
    tcs : ndarray shape `vol_dim`
       An array where entry ``tcs[x, y, z]`` is the number of tracks
       that passed through voxel at voxel coordinate x, y, z
    
    '''
    vol_dims = np.asarray(vol_dims).astype(np.int)
    vox_sizes = np.asarray(vox_sizes).astype(np.double)
    n_voxels = np.prod(vol_dims)
    # output track counts array, flattened
    cdef cnp.ndarray[cnp.int_t, ndim=1] tcs = \
        np.zeros((n_voxels,), dtype=np.int)
    # native C containers for vol_dims and vox_sizes
    cdef int vd[3]
    cdef double vxs[3]
    # cython numpy pointer to individual track array
    cdef cnp.ndarray[cnp.float_t, ndim=2] t
    # cython numpy pointer to point in track array
    cdef cnp.ndarray[cnp.float_t, ndim=1] in_pt
    # processed point
    cdef int out_pt[3]
    # various temporary loop and working variables
    cdef int tno, pno, cno, v
    cdef cnp.npy_intp el_no
    # fill native C arrays from inputs
    for cno from 0 <=cno < 3:
        vd[cno] = vol_dims[cno]
        vxs[cno] = vox_sizes[cno]
    # x slice size (C array ordering)
    cdef int yz = vd[2] * vd[1]
    for tno from 0 <= tno < len(tracks):
        in_inds = set()
        t = tracks[tno].astype(np.float)
        # the loop below is time-critical
        for pno from 0 <= pno < t.shape[0]:
            in_pt = t[pno]
            # set coordinates outside volume to volume edges
            for cno from 0 <=cno < 3:
                v = <int>floor(in_pt[cno] / vxs[cno] + 0.5)
                if v < 0:
                    v = 0
                elif v >= vd[cno]:
                    v = vd[cno]-1 # last element in volume
                out_pt[cno] = v
            # calculate element number in flattened tcs array
            el_no = (out_pt[0] * yz +
                     out_pt[1] * vd[2] +
                     out_pt[2])
            # discard duplicates
            if el_no in in_inds:
                continue
            in_inds.add(el_no)
            # set value
            tcs[el_no] += 1
    return tcs.reshape(vol_dims)


