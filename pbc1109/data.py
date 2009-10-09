''' File defining PBC data locations '''

from os.path import join as pjoin
from glob import glob

import numpy as np

import dipy.io.trackvis as tv


class DataError(Exception):
    pass


class PBCData(object):
    ''' Data repository class for PBC data file structure

    Example
    -------
    # Create datasource
    ds = PBCData('/some/path/to/data')
    # get data dictionary for subject 1, scan 1
    data = ds.get_data(1,1)
    '''
    def __init__(self, data_path):
        self.data_path = data_path
        self._cache = {}
        
    def get_data(self, subject, scan, refresh=False):
        ''' Get data dictionary for `subject` no and `scan` no

        Parameters
        ----------
        subject : int
           subject number, first subject is 1
        scan : {1,2}
           scan number, 
        '''
        if not refresh and (subject, scan) in self._cache:
            return self._cache[(subject, scan)]
        data = {}
        subject_path = pjoin(self.data_path, 'brain%d' % subject)
        ss_root = 'brain%d_scan%d_' % (subject, scan)
        glob_prefix = pjoin(subject_path, ss_root)
        trk_fname = self._get_onefile(glob_prefix +
                                      'fiber_track_mni.trk')
        if trk_fname:
            data['streams'], data['hdr'], _ = tv.read(trk_fname)
        labels_fname = self._get_onefile(glob_prefix +
                                      'fiber_labels.txt')
        if labels_fname:
            arr  = np.fromfile(labels_fname, dtype=np.uint, sep=' ')
            data['labels'] = arr.reshape((-1,2))
        self._cache[(subject, scan)] = data
        return data

    def _get_onefile(self, globber, must_have=False):
        ''' Glob for a single file using `globber`

        Raise an error if more than one file found.  Optionally
        (depending on `must_have` raise an error for no files found.
        Otherwise, if no files found, return None
        '''
        fnames = glob(globber)
        if len(fnames) == 0:
            if must_have:
                raise DataError('Got nothing from globbing %s'
                                % globber)
            return None
        if len(fnames) > 1:
            raise DataError('Too many track files')
        return fnames[0]
