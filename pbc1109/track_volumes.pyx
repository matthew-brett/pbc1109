''' Counting incidence of tracks in voxels of volume '''

import numpy as np


def track_counts(vtracks, vol_dims):
    ''' Count occurences of voxel points in `vtracks`

    Parameters
    ----------
    vtracks : sequence
       sequence of tracks.  Tracks as ndarrays of shape (N, 3), where N
       is the number of points in that track, and ``vtracks[t][n]`` is
       the n-th point in the t-th track.  Points are of form x, y, z in
       *voxel* coordinates.
    vol_dim : sequence lenth 3
       volume dimensions in voxels, x, y, z.

    Returns
    -------
    tcs : ndarray shape `vol_dim`
       An array where entry ``tcs[x, y, z]`` is the number of tracks
       that passed through voxel at coordinate x, y, z
    
    '''
    tcs = np.zeros(vol_dims, dtype=np.uint16)
    for t in vtracks:
        for p in t:
            tcs[p] += 1
    return tcs
