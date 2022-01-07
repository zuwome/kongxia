//
//  UIColor+Hex.h
//  Additions
//
//  Created by Matthias Bauch on 24.11.10.
//  Copyright 2010 Matthias Bauch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;

- (NSString *)hexString;

@end