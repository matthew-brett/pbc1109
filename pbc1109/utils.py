''' pbc utilities '''

from __future__ import division

import numpy as np


def mm2vox(xyz, hdr):
    ''' convert line points from mm to voxels given trackvis header

    Parameters
    ----------
    xyz : array-like, shape (N,3)
       line of N points, with xyz mm coordinates
    hdr : mapping-like
       something with key 'voxel_size' contain array shape (3,)

    Returns
    -------
    vxyz : array shape (N,3)
       points in voxel coordinates

    Examples
    --------
    >>> pts = [[1, 1, 1], [2.1, 3.4, 4.7]]
    >>> hdr = {'voxel_size': np.array([1, 2, 3])}
    >>> mm2vox(pts, hdr)
    array([[ 1.,  0.,  0.],
           [ 2.,  1.,  1.]])
    '''
    return np.floor(xyz / hdr['voxel_size']).astype(np.int32)


def vox2mm(vxyz, hdr):
    ''' convert line points from mm to voxels given trackvis header

    Parameters
    ----------
    vxyz : array-like, shape (N,3)
       line of N points, with xyz voxel coordinates
    hdr : mapping-like
       something with key 'voxel_size' contain array shape (3,)

    Returns
    -------
    xyz : array shape (N,3)
       points in mm coordinates

    Examples
    --------
    >>> pts = [[1, 1, 1], [2, 3, 4]]
    >>> hdr = {'voxel_size': np.array([1, 2, 3])}
    >>> vox2mm(pts, hdr)
    array([[ 1,  2,  3],
           [ 2,  6, 12]])
    '''
    return vxyz * hdr['voxel_size']
