''' File defining PBC data locations '''
# this needed for python 2.5
from __future__ import with_statement

import os
from os.path import join as pjoin
from glob import glob

import numpy as np

import dipy.io.trackvis as tv
from dipy.io.utils import allopen


def load_txt(fname):
    ''' Load text file with values separated by more than one space

    Parameters
    ----------
    fname : filename

    Returns
    -------
    values : list
       list of values on each line
    '''
    lines = []
    with open(fname, 'rt') as f:
        for line in f:
            lines.append([val.strip() for val in line.split('  ')
                          if val.strip()])
    return lines


class DataError(Exception):
    pass


class SubjScan(object):
    ''' Class to fetch and cache data for a subject, scan pair '''
    def __init__(self, data_path, subject_no, scan_no):
        self.data_path = data_path
        self.subject_no = subject_no
        self.scan_no = scan_no
        subject_path = pjoin(data_path, 'brain%d' %
                                   subject_no)
        ss_root = 'brain%d_scan%d_' % (subject_no, scan_no)
        self._glob_prefix = pjoin(subject_path, ss_root)
        self._cache = {}

    @property
    def streams(self):
        if 'streams' in self._cache:
            return self._cache['streams']
        trk_fname = get_onefile(
            self._glob_prefix + 'fiber_track_mni.trk')
        if trk_fname is None:
            return None
        streams, hdr = tv.read(trk_fname)
        self._cache['hdr'] = hdr
        self._cache['streams'] = streams
        return streams

    @property
    def hdr(self):
        if 'hdr' in self._cache:
            return self._cache['hdr']
        streams = self.streams
        if not streams is None:
            return self._cache['hdr']
        
    @property
    def labels(self):
        if 'labels' in self._cache:
            return self._cache['labels']
        labels_fname = get_onefile(
            self._glob_prefix + 'fiber_labels.txt')
        if labels_fname is None:
            return None
        arr  = np.fromfile(labels_fname, dtype=np.uint, sep=' ')
        labels = arr.reshape((-1,2))
        self._cache['labels'] = labels
        return labels

    @property
    def bundle_ids(self):
        if 'bundle_ids' in self._cache:
            return self._cache['bundle_ids']
        ids_fname = get_onefile(
            self._glob_prefix + 'bundle_ids.txt')
        if ids_fname is None:
            return None
        bundle_ids = load_txt(ids_fname)
        self._cache['bundle_ids'] = bundle_ids
        return bundle_ids
    

class PBCData(object):
    ''' Data repository class for PBC data file structure

    Example
    -------
    # Create datasource
    ds = PBCData('/some/path/to/data')
    # get data dictionary-like for subject 1, scan 1
    data = ds.get_data(1,1)
    '''
    def __init__(self, data_path):
        if not os.path.isdir(data_path):
            raise DataError('path "%s" is not a directory' % data_path)
        self.data_path = data_path
        
    def get_data(self, subject_no, scan_no):
        ''' Get data dictionary-like for `subject` no and `scan` no

        Parameters
        ----------
        subject_no : int
           subject number, first subject is 1
        scan_no : {1,2}
           scan number 
        '''
        return SubjScan(self.data_path, subject_no, scan_no)


def get_onefile(globber, must_have=False):
    ''' Glob for a single file using `globber`

    Raise an error if more than one file found.  Optionally
    (depending on `must_have` raise an error for no files found.
    Otherwise, if no files found, return None

    Parameters
    ----------
    globber : string
       glob pattern for file
    must_have : {False, True}, optional
       If True, raise Error if no file found

    Returns
    -------
    fname : string or None
       name of single file found, or None if no file found and
       `must_have` is False
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
