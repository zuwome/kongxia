

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonCrypto.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RegexKitLite.h"

#define REGEX_PHONE			(@"\\+?\\d{1,4}?[-.\\s]?\\(?\\d{1,3}?\\)?[-.\\s]?\\d{1,4}[-.\\s]?\\d{1,4}[-.\\s]?\\d{3,9}")
#define REGEX_MAIL			(@"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+")
#define REGEX_URL			(@"(http|ftp|https):\\/\\/[\\w]+(.[\\w]+)([\\w\\-\\.,@?^=%&:\\/~\\+#]*[\\w\\-\\@?^=%&\\/~\\+#])")
#define REGEX_NUMBER        (@"^[+-]?\\d*\\.\\d+$|^[+-]?\\d+(\\.\\d*)?$")

@implementation NSString (Extensions)

- (BOOL)isContain:(NSString *)asubstr {
    NSRange rg = [self rangeOfString:asubstr];
    return rg.length > 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Deprecated - https://github.com/facebook/three20/issues/367
 */
- (BOOL)isEmptyOrWhitespace {
    // A nil or NULL string is not the same as an empty string
    return 0 == self.length ||
           ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

+ (BOOL)isBlank:(NSString *)str {
    return str == nil || [str isEmptyOrWhitespace];
}

+ (BOOL)isNotBlank:(NSString *)str {
    return ![NSString isBlank:str];
}

+ (BOOL)isNumeric:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSInteger hold;
    if ([scanner scanInteger:&hold] && [scanner isAtEnd]) return YES;
    return NO;
}

+ (BOOL)isEqualToStringOrblank:(NSString *)str1 compareString:(NSString *)str2 {
    
    if ([NSString isBlank:str1] && [NSString isBlank:str2]) {
        return YES;
    } else {
        if ([NSString isNotBlank:str1] && [NSString isNotBlank:str2]) {
            return [str1 isEqualToString:str2];
        }
    }
    return NO;
}

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length {
    char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'};
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;

    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity:lentext];
    raw = [data bytes];
    ixtext = 0;

    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }

        for (i = 0; i < ctcopy; i++)
            [result appendString:[NSString stringWithFormat:@"%c", base64EncodingTable[output[i]]]];

        for (i = ctcopy; i < 4; i++)
            [result appendString:@"="];

        ixtext += 3;
        charsonline += 4;

        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (BOOL)isPhoneNumber {
	return [self isMatchedByRegex:REGEX_PHONE];
}

- (BOOL)isNumber {
    return [self isMatchedByRegex:REGEX_NUMBER];
}

- (BOOL)isEmail {
	return [self isMatchedByRegex:REGEX_MAIL];
}

- (BOOL)isPhoneNumberOrEmail {
    return [self isEmail] || [self isPhoneNumber];
}

- (void)detectAllPhoneNumberWithBlock:(void (^)(NSString *, NSRange))phoneBlock {
	[self detectAllForRegex:REGEX_PHONE withBlock:phoneBlock];
}

- (void)detectAllEmailWithBlock:(void (^)(NSString *, NSRange))emailBlock {
	[self detectAllForRegex:REGEX_MAIL withBlock:emailBlock];
}

- (void)detectAllURLWithBlock:(void (^)(NSString *, NSRange))URLBlock {
	[self detectAllForRegex:REGEX_URL withBlock:URLBlock];
}

- (void)detectAllForRegex:(NSString *)regex withBlock:(void (^)(NSString *, NSRange))block {
    [self enumerateStringsMatchedByRegex:regex
                              usingBlock:^(NSInteger captureCount,
                                           NSString *const __unsafe_unretained *capturedStrings,
                                           const NSRange *capturedRanges,
                                           volatile BOOL *const stop) {
                                  block(*capturedStrings, *capturedRanges);
                              }];
}

- (NSString*)md5Hash {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimBegin:(NSString *)strBegin {
    if ([strBegin length] == 0) {
        return self;
    }
    if ([self hasPrefix:strBegin]) {
        return [self substringFromIndex:[strBegin length]];
    } else
        return self;
}

- (NSString *)trimEnd:(NSString *)strEnd {
    if ([strEnd length] == 0) {
        return self;
    }
    if ([self hasSuffix:strEnd]) {
        return [self substringToIndex:[self length] - [strEnd length]];
    }
    return self;
}

- (NSString *)trim:(NSString *)strTrim {
    return [self trimEnd:[self trimBegin:strTrim]];
}

- (NSString *)replaceOldString:(NSString *)strOld WithNewString:(NSString *)strNew {
    NSMutableString *strMutale = [NSMutableString stringWithString:self];
    NSRange r;
    r.location = 0;
    r.length = [self length];
    [strMutale replaceOccurrencesOfString:strOld withString:strNew options:NSCaseInsensitiveSearch range:r];
    return [NSString stringWithString:strMutale];
}

- (NSString *)replaceCRWithNewLine {
    return [self replaceOldString:@"{CR}" WithNewString:@"\n"];
}

- (NSString *)UTIForPathExtension {
	CFStringRef fileExtension = (__bridge CFStringRef) [self pathExtension];
	CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
	NSString *UTIString = (__bridge NSString *)(fileUTI);
	CFRelease(fileUTI);
	
	return UTIString;
}

- (NSString *)MIMETypeForPathExtension {
	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[self pathExtension], NULL);
	NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
	CFRelease(UTI);
	
	if (CFStringCompare(UTI, CFSTR("com.apple.iwork.numbers.numbers"), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		mimeType = @"application/x-iwork-numbers-sffnumbers";
	} else if (CFStringCompare(UTI, CFSTR("com.apple.iwork.keynote.key"), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		mimeType = @"application/x-iwork-keynote-sffkey";
	} else if (CFStringCompare(UTI, CFSTR("dyn.age80n8ddqz0a"), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		mimeType = @"application/vnd.ms-excel";
	}

	if (!mimeType) {
		return @"application/octet-stream";
	} else {
		return mimeType;
	}
}

- (NSString *)numberUppercaseString {
    NSMutableString *moneyStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self doubleValue]]];
    NSArray *moneyScales = @[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *numberUppercaseStrings = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    NSMutableString *resultString = [[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for(NSInteger i = moneyStr.length;i>0;i--) {
        NSInteger MyData=[[moneyStr substringWithRange:NSMakeRange(moneyStr.length-i, 1)] integerValue];
        [resultString appendString:numberUppercaseStrings[MyData]];
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue]==0&&i!=1&&i!=2) {
            [resultString appendString:@"元"];
            break;
        }
        [resultString appendString:moneyScales[i-1]];
    }
    return resultString;
}

//+ (NSString *)multiMD5:(NSString *)str offset:(NSUInteger )offSet
//{
//    //return [str stringByAppendingString:@"xxxx"];
//    //not competed yet
//    //NSLog(@"str:%@, offset:%d",str,offSet);
//    NSString * str_md5 = [self md5:str];
//    NSString * sub_md5 = [str_md5 substringFromIndex:(offSet > 30 ? 30 : offSet)];
//    //NSLog(@"md5:%@,subMd5:%@,append:%@",str_md5,sub_md5,[str_md5 stringByAppendingString:sub_md5]);
//    return [self md5:[str_md5 stringByAppendingString:sub_md5]];
//}
//
//+ (NSString *)md5:(NSString *)str
//{
//    const char * cStr =[str UTF8String];
//    //    unsigned char result[32];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result);
//    /*    32byte
//     return[NSString stringWithFormat:
//     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//     result[0], result[1], result[2], result[3],
//     result[4], result[5], result[6], result[7],
//     result[8], result[9], result[10], result[11],
//     result[12], result[13], result[14], result[15],
//     result[16], result[17], result[18], result[19],
//     result[20], result[21], result[22], result[23],
//     result[24], result[25], result[26], result[27],
//     result[28], result[29], result[30], result[31]
//     ];
//     */
//    return[NSString stringWithFormat:
//           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//           result[0], result[1], result[2], result[3],
//           result[4], result[5], result[6], result[7],
//           result[8], result[9], result[10], result[11],
//           result[12], result[13], result[14], result[15]
//           ];
//}

@end
