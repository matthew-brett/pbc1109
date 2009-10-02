function setGlobalTrack (filename)

% setGlobalTrack reads in a TrackVis track file and sets it to
% the global variable PghBC2009_DEF.track so that all other
% routines can access it without passing copies around.  To
% access the global variables in a matlab function, put the line
% global PghBC2009_DEF;
% at the top of the function.
% For more information about the track data structure please
% run help read_trk_hdr
% 
% Input:
%       filename: Name of track file output from trackvis
%                 The extension of file is .trk
% Output: none, global variable PghBC2009_DEF.track is set with the
%         track data structure

%
% $Id: setGlobalTrack.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%



global PghBC2009_DEF;

PghBC2009_DEF.track = read_trk( filename );
