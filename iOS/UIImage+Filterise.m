/*
UIImage+Filterise.m

DESCRIPTION
Use these UIImage additions to render the filters you want to use. Use the python tool to extract
the polynomial values that are used in the sampleFilter method.


See http://www.weemoapps.com/creating-retro-and-analog-image-filters-in-mobile-apps 
for the theory behind this method.

AUTHOR
email: vassilis@weemoapps.com
twitter: @weemoapps

LICENSE
Do whatever you want, but please mention this code in your code if you modify it.

VERSION
0.1
*/

#import "UIImage+Filterise.h"

@implementation UIImage(Filter)

// This is a sample filter with some pre-coded values in the polynomial.
// You can add your own filters using the same code just by using different polynomials values.
// For more info on how to get these values, see  http://www.weemoapps.com/creating-retro-and-analog-image-filters-in-mobile-apps

//Ps. the code is slow, and ugly and is intented only as a proof of concept. There are many suggestions on how to improve 
// this framework if you are willing to help see here: https://github.com/WeemoApps/filteriser/wiki
+ (UIImage *) sampleFilter:(UIImage *)original {
    
    CFDataRef dataref=CGDataProviderCopyData(CGImageGetDataProvider(original.CGImage));
    int length=CFDataGetLength(dataref);
    UInt8 *data=(UInt8 *)CFDataGetBytePtr(dataref);    
    
    double newBValue;
    double newGValue;
    double newRValue;

    //this is the main loop that alters the image pixels in order to get the filtered values.
    //You can see that each new value (for example newRValue) is in fact a polynomial value  
    //when we use as the point of polynomial computation the old pixel value.
	for(int index=0;index<length;index+=4){
        //NSLog(@"%d 0",data[index]);
        //NSLog(@"%d 1",data[index+1]);
        //NSLog(@"%d 2",data[index+2]);
        //NSLog(@"%d 3",data[index+3]);
        newRValue = -0.000093*data[index]*data[index]*data[index]+0.031603*data[index]*data[index]-0.992382*data[index];
        newGValue = -0.000058*data[index+1]*data[index]*data[index+1]+0.021061*data[index+1]*data[index+1]-0.620401*data[index+1];
        newBValue = 0.000013*data[index+2]*data[index+2]*data[index+2]-0.004366*data[index+2]*data[index+2]+1.275243*data[index+2];

        newRValue = [self normalisePixelValue:newRValue];
        newGValue = [self normalisePixelValue:newGValue];
        newBValue = [self normalisePixelValue:newBValue];
        
        data[index] = newRValue;
        data[index+1] = newGValue;
        data[index+2] = newBValue;
	}
    
	size_t width=CGImageGetWidth(original.CGImage);
	size_t height=CGImageGetHeight(original.CGImage);
	size_t bitsPerComponent=CGImageGetBitsPerComponent(original.CGImage);
	size_t bitsPerPixel=CGImageGetBitsPerPixel(original.CGImage);
	size_t bytesPerRow=CGImageGetBytesPerRow(original.CGImage);
	CGColorSpaceRef colorspace=CGImageGetColorSpace(original.CGImage);
	CGBitmapInfo bitmapInfo=CGImageGetBitmapInfo(original.CGImage);
	CFDataRef newData=CFDataCreate(NULL,data,length);
	CGDataProviderRef provider=CGDataProviderCreateWithCFData(newData);
	CGImageRef newImg=CGImageCreate(width,height,bitsPerComponent,bitsPerPixel,bytesPerRow,colorspace,bitmapInfo,provider,NULL,true,kCGRenderingIntentDefault);
    UIImage *resultUIImage = [UIImage imageWithCGImage:newImg];

    CFRelease(newData);
    CGImageRelease(newImg);
    CGDataProviderRelease(provider);
    CFRelease(dataref);
    
    return resultUIImage; 
}


+ (double) normalisePixelValue:(double)value {
    if (value > 255) {
        return 255.0;
    }
    else if (value < 0 )
        return 0.0;
    else 
        return ceil(value);
}

@end
