 #!/usr/bin/python
 #-*- coding: latin-1 -*-

#This script processes the output files from the au
#script "split-relax" and saves as new file numbers
#with phase correction, zero filling, and intensity scaling
#
# Save this script in: C:\Bruker\Topspin#.x.x\exp\stan\nmr\py\user
#
## Instructions ##
# 1. perform the "split-relax" au script on the T1 or T2 dataset
# 2. perform a phase correction on the spectrum with the shortest delay (this will be the most intense)
# 3. in the experiment with the longest delay, open "ProcPars" and click the "S" in the upper left
#		record the value of the parameter "NC_PROC" (should be something around -4)
#		NB: a lower (more negative) nc_proc value scales spectra to higher intensity, whereas a higher number
#		(positive) scales spectra to a lower intensity. The exact value of nc_proc doesn't matter* as long as
#		it is the same for all spectra in the dataset.
#			*I almost always set nc_proc between -3 and -7*
# 4. enter all variables into inputs marker "**" below
# 5. to avoid making Sparky crash when opening several (heavily zero-filled) spectra, convert to ucsf!
#
#@author: emeryusher
# etusher@psu.edu

#import a bunch of junk that Topspin needs; this came from sample scripts online
import os, sys, re
import xml.etree.ElementTree as ET
import de.bruker.nmr.mfw.root.UtilPath as UtilPath
from javax.swing import JOptionPane

#**input whole path for where your Topspin data is stored**
#	the path is likely what is displayed on the Data navigation tab on the left side of Topspin
directory = 'C:\Users\emery\NMR_data\NMR_SPOP'

#**user inputs:**
expName = "name"	#name of parent experiment file within directory (enter between "")
firstExp = 5000		#enter first experiment number (file number) from the split-relax product
lastExp = 5011		#enter last experiment number (file number) from the split-relax product
numOfExp = 12		#enter the number of data points (number of delays in vc/vd list)
firstSave = "99"	#enter a number that will be the begin the names of the files from this script\
ncproc = -4		#enter a number for desired nc_proc setting
zfill = 2048	#number of points for zero filling
phc0f2 = -22    # $see below$
phc0f1 = 0		# $see below$
phc1f2 = 0		# $see below$
phc1f2 = 0      # $see below$

#$ note on phase correction syntax $
# >zero and and first order phase corrections are phc0 and phc1, respectively
# >as written above, the phase correction to be applied is:
#		zero order: -22deg in F2 (phc0f2), 0deg in F1 (phc0f1)
#		first order: 0deg in F2 (phc1f2), 0deg in F1 (phc1f1)

# The actual script is here:
#loops to sequentially process each experiment file
for i in range(firstExp, lastExp + 1):
	RE([expName, str(i), "1", directory], "n") 	#open the 2D file ("1") for the first delay spectrum
	XCMD("PHC0 %s" % phc0f2 phc0f1)	#perform zero order phase correction
	XCMD("PHC1 %s" % phc1f2 phc1f1)	#perform first order phase correction
	XCMD("1 SI %s" % zfill)  #zero fill F1 and F2 points to 2048
	XCMD("xfb nc_proc %s" % ncproc)	#apply nc_proc correction
	WR([str(expName), str(firstSave) + str(i), "1", directory], "n")
	XCMD('close')

MSG('~-~ fin ~-~')
