          matlab scripts for BCC ICDM competition Fall 2009
          =================================================



This README is a brief overview of the sample matlab scripts provided for
Pittsburgh Brain Competition 2009.  For more information about the 
competition, see  http://pbc.lrdc.pitt.edu/.

The format used to store the fiber tract data is the TrackVis trk format.
TrackVis is free software for visualizing DTI data, available for Linux, MacOSX and Windows. 
General information about TrackVis is available at
http://www.trackvis.org
Details of the TrackVis trk format are available at
http://www.trackvis.org/docs/?subsect=fileformat



VERSION
===============================================================================
   Beta testing version, Sept. 18, 2009
   


SCRIPTS SUMMARY
===============================================================================

The following scripts/functions are released in the beta testing version.


tracks = read_trk( filename )
	Read in a TrackVis .trk file of fiber tracks.

setGlobalTrack (filename)
	Set the global PghBC2009_DEF.track variable by reading in the trk
	file (with read_trk).  The use of setGlobalTrack instead of read_trk
	is preferred because setting the global variable removes the need
	to pass the very large track data structure from function to
	function.  Various of the functions provided here require  
	PghBC2009_DEF.track to be set.

track_hdr = read_trk_hdr( filename )
	Read just the header portion of a TrackVis .trk file.

print_track_info( track_hdr )
	Print to the screen information about the track from the track hdr.


write_trk( track, filename )
	Write a TrackVis .trk file to disk.

FiberLabelVolume = GetFiberLabeledVolume()
	Get the FiberLabelVolume cell array (see data structures section below).

setGlobalFiberLabelVol()
	Set the global PghBC2009_DEF.FiberLabelVol variable by calling
	GetFiberLabeledVolume(). The use of setGlobalFiberLabelVol() instead 
	of GetFiberLabeledVolume() is preferred because setting the global 
	variable removes the need to pass the large FiberLabelVol data structure
	from function to function.  Various of the functions provided here 
	require  PghBC2009_DEF.FiberLabelVol to be set.


FiberList = GetFiberList( track_hdr)
	Return the list of fibers in a track dataset.

FiberList = GetFiberListBySlice( sliceX, sliceY, sliceZ)
	Return the list of fibers in a given slice (or union of slice
	planes) in a track dataset.

PlotFiber( FiberList )
	Produce a matlab plot3 three dimensional plot of the list of fibers.

	
FiberStats = GetFiberStats()
	Returns a struct array with fields Length (length), Center of Mass (CM), 
	Start Point (Start) and End Point (End).  Each field is a vector or
	matrix with the statistics for each fiber in the dataset.
	


[vx vy vz] = mm2voxel(x, y, z, track_hdr)
	Convert from TrackVis mm coordinates to xyz indices into 3D image matrix

[x y z] = voxel2mm(vx, vy, vz, track_hdr)
	Convert from xyz indices into 3D image matrix to TrackVis mm coordinates


your_scores = pbc2009icdm_scoring1(filename)
	**Provisional** release version of scoring program for challenge 1.
	Returns a vector of scores, 1 per fiber bundle.  See program help for
	appropriate location and naming conventions for input files.



LICENSING
===============================================================================
The matlab_scripts scripts for Pittsburgh Brain Competition 2009 are
released under the GPL license.  Copyright University of Pittsburgh.





DATA STRUCTURES
===============================================================================
The matlab scripts use the following data structures:

track
	track is a matlab struct that holds all the data from a TrackVis
	trk file, as read from disk with read_trk.  The main fields are
	track.header that contains about 20 fields with metadata such as
	dim, voxelsize, count of number of fibers, and, track.fiber that
	is a 1D cell array with 1 cell per fiber.  Each cell contains the
	list of points in that fiber.
	Example:
	>> PghBC2009_DEF.track
		header: [1x1 struct]
		fiber: {1x250000 cell}
		
	>> PghBC2009_DEF.track.header
                    id_string: [6x1 char]
                          dim: [3x1 int16]
                   voxel_size: [3x1 double]
	   <SNIP>


track_hdr
	track_hdr is simply the header portion of the track structure
	described above.


	
fiber
	A fiber is the set of points, stored as xyz mm locations in the track
	data structure, through which a fiber tract passes.  
	Example:
	>> PghBC2009_DEF.track.fiber{37}
		num_points: 48
		points: [48x3 double]


FiberList
	A FiberList is simply an array of integers that refer to fibers in a
	track data structure.   We associate each fiber in the track data 
	structure with a number, which is simply its position in the  
	PghBC2009_DEF.track.fiber cell array.  
	ie PghBC2009_DEF.track.fiber{1} is fiber 1, and so on.
	An example FiberList of 3 fibers could be [37 503 102842]


FiberLabelVolume
	FiberLabelVolume is a 3D cell array computed by GetFiberLabeledVolume().
	The 3 dimensions correspond to the 3 dimensions of the diffusion 
	brain image volume from which the fibers were computed.  At each
	cell there is a 1D array of the list of fibers that pass through the
	corresponding brain image voxel.



EXAMPLE USAGE
==============================================================================

% add paths to matlab programs
>> addpath pbc2009icdm/software/matlab

% set global variable
>> global PghBC2009_DEF

% read track header and print some info
>> track_hdr = read_trk_hdr('pbc2009icdm/brain1/brain1_scan1_fiber_track_mni.trk');
>> print_track_info( track_hdr )

        ****************************************************
        ****************************************************
        Information about Fiber Data Output from TRACKVIS
        For details see http://www.trackvis.org
        ****************************************************
        ****************************************************

        Number of Tracks:250000
        Voxel Dimension:[1.000, 1.000, 1.000]
        Number of Voxels in X Y Z dimension:[182, 218, 182]
        Origin:[0.000, 0.000, 0.000]
        ****************************************************


% set up the PghBC2009_DEF global variable by reading in the track data
% and computing the  FiberLabeledVolume.
>> setGlobalTrack('pbc2009icdm/brain1/brain1_scan1_fiber_track_mni.trk');
Reading Fiber Data ...

 10 percent fibers processed...
 20 percent fibers processed...
 30 percent fibers processed...
<SNIP>

>> setGlobalFiberLabelVol();
Counting Fibers...

Pass 1/2:  10 percent fibers processed...
Pass 1/2:  20 percent fibers processed...
Pass 1/2:  30 percent fibers processed...
Pass 1/2:  40 percent fibers processed...
<SNIP>


% get the list of fibers that pass through X plane 30 and plot them
>> fibersX30 = GetFiberListBySlice(30, [], []);
>> PlotFiber(fibersX30);






