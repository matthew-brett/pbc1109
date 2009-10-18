''' Counting incidence of tracks in voxels of volume '''

import numpy as np


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
    tcs = np.zeros(vol_dims, dtype=np.uint16)
    vox_sizes = np.array(vox_sizes, dtype=np.float)
    for t in tracks:
        ti = np.round(t / vox_sizes).astype(np.int32)
        assert ti.dtype.kind == 'i'
        for p in ti:
            tcs[p] += 1
    return tcs
