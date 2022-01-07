//
//  UIImage+Additions.m
//  mouke
//
//  Created by wlsy on 13-12-13.
//  Copyright (c) 2013年 mou. All rights reserved.
//

#import "UIImage+Additions.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIDevice+OS.h"

@implementation UIImage (Additions)

+ (UIImage *)shootView:(UIView *)view
{
    /*
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
     */
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)imageWithBurnTint:(UIColor *)color
{
    UIImage *img = self;
    
    // lets tint the icon - assumes your icons are black
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
    
}

- (UIImage *)blurOnImageWithRadius:(CGFloat)blurRadius {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        CIContext *context   = [CIContext contextWithOptions:nil];
        CIImage *sourceImage = [CIImage imageWithCGImage:self.CGImage];
        
        // Apply clamp filter:
        // this is needed because the CIGaussianBlur when applied makes
        // a trasparent border around the image
        
        NSString *clampFilterName = @"CIAffineClamp";
        CIFilter *clamp = [CIFilter filterWithName:clampFilterName];
        
        if (!clamp) {
            return [[UIImage alloc] init];
        }
        
        [clamp setValue:sourceImage
                 forKey:kCIInputImageKey];
        
        CIImage *clampResult = [clamp valueForKey:kCIOutputImageKey];
        
        // Apply Gaussian Blur filter
        
        NSString *gaussianBlurFilterName = @"CIGaussianBlur";
        CIFilter *gaussianBlur           = [CIFilter filterWithName:gaussianBlurFilterName];
        
        if (!gaussianBlur) {
            return [[UIImage alloc] init];
        }
        
        [gaussianBlur setValue:clampResult
                        forKey:kCIInputImageKey];
        [gaussianBlur setValue:[NSNumber numberWithFloat:blurRadius]
                        forKey:@"inputRadius"];
        
        CIImage *gaussianBlurResult = [gaussianBlur valueForKey:kCIOutputImageKey];
        
        CGImageRef cgImage = [context createCGImage:gaussianBlurResult
                                           fromRect:[sourceImage extent]];
        
        UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return blurredImage;
        
    } else {
        if ((blurRadius < 0.0f) || (blurRadius > 1.0f)) {
            blurRadius = 0.5f;
        }
        
        int boxSize = (int)(blurRadius * 100);
        boxSize -= (boxSize % 2) + 1;
        UIImage *imageToBlur = self;
        CGImageRef rawImage = imageToBlur.CGImage;
        
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        void *pixelBuffer;
        
        CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        inBuffer.width = CGImageGetWidth(rawImage);
        inBuffer.height = CGImageGetHeight(rawImage);
        inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        
        pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(rawImage);
        outBuffer.height = CGImageGetHeight(rawImage);
        outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                           0, 0, boxSize, boxSize, NULL,
                                           kvImageEdgeExtend);
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 CGImageGetBitmapInfo(imageToBlur.CGImage));
        
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
        
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        CFRelease(inBitmapData);
        CGImageRelease(imageRef);
        
        return returnImage;
    }
}


- (UIColor *)averageColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

- (UIImage *)circleImage
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGRect)convertRectFrom:(CGRect)imageRect imageSize:(CGSize)imageSize detectRect:(CGRect)detectRect {
    CGPoint imageTopLeft = imageRect.origin;
    CGPoint imageBottomRight = CGPointMake(CGRectGetMaxX(imageRect),CGRectGetMaxY(imageRect));
    
    CGPoint viewTopLeft = [self convertPointFrom:imageTopLeft imageSize:imageSize detectSize:detectRect.size];
    CGPoint viewBottomRight = [self convertPointFrom:imageBottomRight imageSize:imageSize detectSize:detectRect.size];
    
    return CGRectMake(viewTopLeft.x, viewTopLeft.y, viewBottomRight.x - viewTopLeft.x, viewBottomRight.y - viewTopLeft.y);
}

+ (CGPoint)convertPointFrom:(CGPoint)imagePoint imageSize:(CGSize)imageSize detectSize:(CGSize)detectSize {
    CGPoint viewPoint = imagePoint;
    CGFloat scale = MAX(detectSize.width / imageSize.width, detectSize.height / imageSize.height);
    viewPoint.x *= scale;
    viewPoint.y *= scale;
    viewPoint.x += (detectSize.width - imageSize.width * scale) / 2.0;
    viewPoint.y += (detectSize.height - imageSize.height * scale) / 2.0;
    return viewPoint;
}



+ (UIImage *)getImageResourceForName:(NSString *)name {
    NSString* bundlepath = [[NSBundle mainBundle] pathForResource:@"com.baidu.idl.face.faceSDK.bundle" ofType:nil];
    NSBundle* modelBundle = [NSBundle bundleWithPath:bundlepath];
    NSString* imagePath = [modelBundle pathForResource:name ofType:@"png"];
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
}


@end
