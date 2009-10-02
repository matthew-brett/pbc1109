function FiberList = GetFiberList( track_hdr)

% FiberList = FiberLabels( track_hdr)
% FiberLabels provide a list of unique label to each fibers
% 
% Example:
% 
% FiberList = FiberLabels( track_hdr )


%
% $Id: GetFiberList.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%

FiberList = 1:track_hdr.n_count;
