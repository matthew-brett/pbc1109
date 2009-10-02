function setGlobalFiberLabelVol()

% setGlobalFiberLabelVol create a 3D matlab cell data structure with each cell 
% contain list of fiber passing through the corresponding voxels and sets it to
% the global variable PghBC2009_DEF.FiberLabelVol so that all other
% routines can access it without passing copies around.  To
% access the global variables in a matlab function, put the line
% global PghBC2009_DEF;
% at the top of the function.
% 
% Input : none
% Output: none, global variable PghBC2009_DEF.FiberLabelVol is set with the
%         track data structure

%
% $Id: setGlobalFiberLabelVol.m,v 1.1 2009/09/18 21:29:20 fissell Exp $
%



global PghBC2009_DEF;
if (~isfield(PghBC2009_DEF, 'track'))
	fprintf(1, '\nPardon, it appears that the PghBC2009_DEF.track field has not been set; please call setGlobalTrack.\n');
	return;
end;

PghBC2009_DEF.FiberLabelVol = GetFiberLabeledVolume();
