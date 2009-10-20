''' pbc utilities '''

from __future__ import division

import numpy as np


def track_indices_asdict(tracks,vol_dims):
    ''' Create a 3d volume  where every cell is a list with the indices of tracks. Represent this volume as a dictionary where 
    key is the tuple of x,y,z voxel coordinates.
    
    Parameters
    --------------
    tracks : sequence
       sequence of tracks.  Tracks as ndarrays of shape (N, 3), where N
       is the number of points in that track, and ``vtracks[t][n]`` is
       the n-th point in the t-th track.  Points are of form x, y, z in
       *mm* coordinates.
    vol_dim : sequence length 3
       volume dimensions in voxels, x, y, z.
    vox_sizes : sequence length 3
       voxel sizes in mm    
    
    Returns
    ---------
    vold : dict of sequences
        dictionary of volume where key is a tuple (x,y,z) of voxel coordinetes. Therefore vold[(2,3,4)] returns a list of integers.
 
    Examples
    ------------
    
    >>> vol_dims = (5, 10, 15)
    >>> tracks = ([[0, 0.1, 0],[1, 1, 1], [2, 2, 2]], [[0.7, 0, 0], [1, 1, 1],[1, 2, 2]])
    >>> tracks = [np.array(t) for t in tracks]
    >>> vold=track_indices_asdict(tracks,vol_dims)
    >>> len(vold[(1,1,1)])
    '''
        
    vold={}    
            
    ti=0
    for t in tracks:        
        for p in t:            
            rp=tuple(np.round(p).astype(int))        
            '''                
            try:                                        
                if ti not in vold[rp]:                    
                    vold[rp].append(ti)                                
            except KeyError:                
                vold[rp]=[ti]                   
            '''
            #This is the same as in ''' above 
            vold.setdefault(rp,[]).append(ti)      
        ti+=1

    return vold


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
