#!/usr/bin/env python
"""
DESCRIPTION
    Prints the polynomials that describe a photoshop curve.
    There are three curves (one per RGB channel) which you can later 
    use to make a custom filter for your image.
    
USAGE
    python extractCurvesFromACVFile.py theCurveFile.acv    
    You need to have scipy and numpy installed.

AUTHOR
    email: balntas@robots.ox.ac.uk
    twitter: @vbalnt

VERSION
    1
"""

import sys, os, traceback, optparse, time
from struct import unpack
from scipy import interpolate
import numpy as np
        
#Here we read the .acv curve file. It will help to take a look at see the link below to lean about the .acv file format specifications
# http://www.adobe.com/devnet-apps/photoshop/fileformatashtml/PhotoshopFileFormats.htm#50577411_pgfId-1056330        
def read_curve(acv_file):
    curve = []
    number_of_points_in_curve, = unpack("!h", acv_file.read(2))
    for j in range(number_of_points_in_curve):
        y, x = unpack("!hh", acv_file.read(4))
        curve.append((x, y))
    return curve
    
#Here we do the interpolation in order to get a curve out of the curve points we already have.    
def return_polynomial_coefficients(curve_list):
	xdata = [x[0] for x in curve_list]
	ydata = [x[1] for x in curve_list]
	np.set_printoptions(precision=6)
	np.set_printoptions(suppress=True)
	p = interpolate.lagrange(xdata, ydata)
	return p
	#coefficients = p.c
	#print coefficients

def main ():
	if (len(sys.argv) != 1):
			acv_file = open(sys.argv[1], "rb")
	else:
		print "Wrong args. Usage: python extractCurvesFromACVFile.py curveFile.acv"
		os._exit(1)
		
	_, nr_curves = unpack("!hh", acv_file.read(4))
	curves = []
	for i in range(nr_curves):
		curves.append(read_curve(acv_file))
	compositeCurve = curves[0]
	redCurve = curves[1]
	greenCurve = curves[2]
	blueCurve = curves[3]
	
	print "************* Red Curve *************"
	pRed = return_polynomial_coefficients(redCurve)
	print pRed
	print "*************************************\n"

	print "************* Green Curve *************"
	pGreen = return_polynomial_coefficients(greenCurve)
	print pGreen
	print "*************************************\n"

	print "************* Blue Curve *************"
	pBlue = return_polynomial_coefficients(blueCurve)
	print pBlue
	print "*************************************\n"

if __name__ == '__main__':
   try:
        main()
   except Exception, e:
        print 'ERROR, UNEXPECTED EXCEPTION'
        print str(e)
        traceback.print_exc()
        os._exit(1)
