/*
UIImage+Filterise.h

DESCRIPTION
Use the UIImage additions to render the filters you want to use. Use the python tool to extract
the polynomial values that are used in the sampleFilter method.

AUTHOR
email: vassilis@vbalnt.io
twitter: @vbalnt
*/


#import <Foundation/Foundation.h>

@interface UIImage(Filter)
//Filters
+ (UIImage *) sampleFilter:(UIImage *)original;

//Utilities
+ (double) normalisePixelValue:(double)value;
@end

