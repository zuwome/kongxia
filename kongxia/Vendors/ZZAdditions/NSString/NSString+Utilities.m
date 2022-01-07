//
//  NSString+Utilities.m
//  Additions
//
//  Created by Erica Sadun, http://ericasadun.com
//  iPhone Developer's Cookbook, 3.0 Edition
//  BSD License, Use at your own risk

#import "NSString+Utilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation  NSString (UtilityExtensions)

- (NSString *)MD5 {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *) trimmedString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


// run srandom() somewhere in your app // http://tinypaste.com/5f1c9
// Requested by BleuLlama
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *) stringByAppendingRandomStringOfRandomLength
{
	int len = random() % 32;
	NSMutableArray *chars = [NSMutableArray array];
	NSMutableString *s = [NSMutableString stringWithString:self];

	NSMutableCharacterSet *cs = [[NSMutableCharacterSet alloc] init];
	[cs formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
	[cs formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	// [cs formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
	// [cs formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];

	// init char array from charset
	for (int c = 0; c < 128; c++) // 7 bit only
		if ([cs characterIsMember:(unichar)c])
			[chars addObject:[NSString stringWithFormat:@"%c", c]];

	for (int i = 0; i < len; i++) [s appendString:[chars objectAtIndex:(random() % chars.count)]];

	return s;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *) date
{
	// Return a date from a string
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MM-dd-yyyy";
	NSDate *date = [formatter dateFromString:self];
	return date;
}

- (NSDate *)RFC3339ToDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    return [formatter dateFromString:self];
    
}

+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGFloat result = font.pointSize + 4;
    if (text)
    {
        CGSize textSize = { widthValue, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        //iOS 7
        CGRect frame = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

+ (CGFloat)findWidthForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGFloat result = font.pointSize + 4;
    if (text)
    {
        CGSize textSize = { widthValue, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        //iOS 7
        CGRect frame = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil];
        size = CGSizeMake(frame.size.width + 1, frame.size.height);
        result = MAX(size.width, result); //At least one row
    }
    return result;
}

@end

