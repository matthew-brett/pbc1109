''' A type of -*- python -*- file

Counting incidence of tracks in voxels of volume

'''
import numpy as np
cimport numpy as cnp

cdef extern from "math.h":
    double floor(double x)


def track_counts(tracks, vol_dims, vox_sizes):
    ''' Count occurences of voxel points in `vtracks`

    Parameters
    ----------
    tracks : sequence
       sequence of tracks.  Tracks as ndarrays of shape (N, 3), where N
       is the number of points in that track, and ``vtracks[t][n]`` is
       the n-th point in the t-th track.  Points are of form x, y, z in
       *mm* coordinates.
    vol_dim : sequence lenth 3
       volume dimensions in voxels, x, y, z.
    vox_sizes : sequence length 3
       voxel sizes in mm

    Returns
    -------
    tcs : ndarray shape `vol_dim`
       An array where entry ``tcs[x, y, z]`` is the number of tracks
       that passed through voxel at coordinate x, y, z
    
    '''
    n_voxels = np.prod(vol_dims)
    cdef cnp.ndarray tcs = np.zeros((n_voxels,), dtype=np.int32)
    cdef cnp.ndarray vd = np.array(vol_dims).astype(np.int32)
    cdef cnp.ndarray vxs = np.array(vox_sizes).astype(np.float32)
    cdef cnp.ndarray t
    cdef cnp.ndarray in_pt
    cdef cnp.ndarray ct_els
    cdef int out_pt[3]
    cdef int tno, pno, cno
    cdef int xy = vd[0] * vd[1]
    for tno from 0 <= tno < len(tracks):
        in_inds = set()
        t = tracks[tno].astype(np.float32)
        for pno from 0 <= pno < t.shape[0]:
            in_pt = t[pno]
            for cno from 0 <=cno < 3:
                v = <int>floor(in_pt[cno] * vxs[cno] + 0.5)
                if v < 0:
                    v = 0
                elif v >= vd[cno]:
                    v = vd[cno]
                out_pt[cno] = v
            el_no = (out_pt[0] * xy +
                     out_pt[1] * vd[0] +
                     out_pt[2])
            if el_no in in_inds:
                continue
            in_inds.add(el_no)
            tcs[el_no] += 1
    return tcs.reshape(vol_dims)


def _unique_elements(vtrack, dims):
    ''' Convert voxel track coordinates to indices in flattened array

    Parameters
    ----------
    vtrack : array shape (N, 3)
       voxel xyz coordinates of points in track
    dims : sequence
       dimensions of 3D array to which `vtrack` coordinates refer

    Returns
    -------
    unique_els : array shape (N,)
       elements (indices into flattened array of shape `dims`) for each
       point in `vtrack`.
    '''
    xd, yd, zd = dims
    x, y, z = vtrack.T
    np.clip(x, 0, xd, x)
    np.clip(y, 0, yd, y)
    np.clip(z, 0, zd, z)
    el_nos = x + y*xd + z*xd*yd
    return np.unique(el_nos)
