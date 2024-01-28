//
//  ZZUtils.m
//  zuwome
//
//  Created by angBiu on 16/5/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "ZZUserLabel.h"
#import "ZZAFNHelper.h"
#import <RongIMKit/RongIMKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "sys/utsname.h"

#import "ZZTabBarViewController.h"
#import "ZZLiveStreamHelper.h"
#import "ZZBanModel.h"
@implementation ZZUtils

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    NSString * pattern  = @"[^\\x00-\\xff]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

+ (BOOL)isAllowPhotoLibrary
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
        [[UIViewController currentDisplayViewController] showOKCancelAlertWithTitle:nil message:NSLocalizedString(@"是否开启相册权限",nil) cancelTitle:NSLocalizedString(@"取消", nil) cancelBlock:nil okTitle:NSLocalizedString(@"确定", nil) okBlock:^{
            if (UIApplicationOpenSettingsURLString != NULL) {
                NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
            }
        }];
        return NO;
    }
    return YES;
}

+ (BOOL)isAllowCamera
{
    //判断是否有相机的权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showOkCancelAlertIn:[UIViewController currentDisplayViewController] title:@"开启相机权限" message:@"在“设置-空虾”中开启相机就可以开始使用本功能哦~" confirmTitle:@"设置" confirmHandler:^(UIAlertAction * _Nonnull action) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
                }
            } cancelTitle:@"取消" cancelHandler:nil];
        });
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAllowAudio
{
    //判断是否有相机的权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showOkCancelAlertIn:[UIViewController currentDisplayViewController] 
                                             title:@"开启麦克风权限"
                                           message:@"在“设置-空虾”中开启麦克风就可以开始使用本功能哦~"
                                      confirmTitle:@"设置"
                                    confirmHandler:^(UIAlertAction * _Nonnull action) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
                }
            } cancelTitle:@"取消" cancelHandler:nil];
        });
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAllowLocation
{
    //判断定位
    CLAuthorizationStatus status = [LocationMangers shared].authorizationStatus;
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController showOkCancelAlertIn:[UIViewController currentDisplayViewController]
                                             title:nil
                                           message:@"您尚未开启定位功能，无法准确获取定位消息。"
                                      confirmTitle:@"去开启"
                                    confirmHandler:^(UIAlertAction * _Nonnull action) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
                }
            } cancelTitle:@"忽略" cancelHandler:nil];
        });
        
        return NO;
    }
    
    return YES;
}

+ (void)checkContactAuthorization:(void(^)(bool isAuthorized))block
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined || status == CNAuthorizationStatusAuthorized) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                 {
                     block(NO);
                 }
                 else if (!granted)
                 {
                     block(NO);
                 }
                 else
                 {
                     block(YES);
                 }
             });
         }];
    } else {
        block(NO);
    }
}

+ (CGFloat)heightForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont labelWidth:(CGFloat)labelWidth
{
    CGFloat titleHeight = 0.0;
    if ([contentText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:contentText attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:labelFont]}];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        titleHeight = ceilf(rect.size.height);
    }
    
    return titleHeight;
}

+ (CGFloat)widthForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont
{
    CGFloat titleWidth = 0;
    if ([contentText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:contentText
                                                                             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:labelFont]}];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        titleWidth = ceilf(rect.size.width);
    }
    
    return titleWidth;
}

/**
 json字符串转字典

 @param jsonString 要转换的json字符串
 @return 转之后的字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    if (![dic isKindOfClass: [NSDictionary class]]) {
        return nil;
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
}
+ (BOOL)isThePasswordNotTooSimpleWithPasswordString:(NSString *)passwordString {
    //字母和数字
    NSString * passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    //字母数字特殊字符
    NSString * specialCharactersRegex = @"^(?![0-9]+$)(?![^0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z]+$)(?![a-zA-Z0-9]+$)[a-zA-Z0-9\\S]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    NSPredicate *specialCharactersPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", specialCharactersRegex];
    
    BOOL isMatch = [pred evaluateWithObject:passwordString];
    
    BOOL isSpecialMatch = [specialCharactersPred evaluateWithObject:passwordString];

    return (isMatch||isSpecialMatch)? YES:NO;
}


+ (NSString *)encryptPhone:(NSString *)phoen
{
    if (phoen.length>7) {
        NSInteger length = phoen.length - 7;
        NSRange range = NSMakeRange(3, length);
        NSString *replaceString = @"";
        for (int i=0; i<length; i++) {
            replaceString = [replaceString stringByAppendingString:@"*"];
        }
        NSString *str = [phoen stringByReplacingCharactersInRange:range withString:replaceString];
        return str;
    }
    return phoen;
}


/**
 设置首字母不能为0 或小数点
  且最多只能有1个小数点
 */
+ (BOOL)limitTextFieldWithTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string  {
    
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                if(single == '.'||single =='0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian) {
                    //text中还没有小数点
                    return YES;
                    
                }else {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {
                    //存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        }else {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else {
        return YES;
    }
}
//设置textField只能输入一个小数点 并且小数点后只有两位
+ (BOOL)limitTextFieldWithTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string pure:(BOOL)pure
{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if (pure) {
                    return NO;
                }
                if(!isHaveDian) {
                    return YES;
                    
                }
                else {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else {
                if (isHaveDian) {
                    //存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }
                    else {
                        return NO;
                    }
                }
                else {
                    return YES;
                }
            }
        }
        else {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else {
        return YES;
    }
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//图片压缩
+ (NSData *)imageRepresentationDataWithImage:(UIImage *)image
{
    NSData *imageDate = UIImagePNGRepresentation(image);
    NSInteger perMBBytes = 1024;
    NSLog(@"originimagesize === %ld",imageDate.length/perMBBytes);
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    NSData *appendImageData = [[NSData alloc]init];
    if (imageSize > 0 && imageSize <  500)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else if (imageSize >= 500 && imageSize < 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.5);
    }
    else if (imageSize >= 2000 )
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.2);
    }
    
    NSLog(@"imagesize === %ld",appendImageData.length/perMBBytes);
    return appendImageData;
}

+ (NSData *)userImageRepresentationDataWithImage:(UIImage *)image
{
    NSData *imageDate = UIImagePNGRepresentation(image);
    NSInteger perMBBytes = 1024;
    NSLog(@"originimagesize === %ld",imageDate.length/perMBBytes);
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    NSData *appendImageData = [[NSData alloc]init];
    if (imageSize > 0 && imageSize <  500)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else if (imageSize >= 500 && imageSize < 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.6);
    }
    else if (imageSize >= 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.4);
    }
    
    NSLog(@"imagesize === %ld",appendImageData.length/perMBBytes);
    return appendImageData;
}

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageDate = UIImagePNGRepresentation(newImage);
    NSInteger perMBBytes = 1024;
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    
    NSData *appendImageData;
    if (imageSize > 26)
    {
        appendImageData = UIImageJPEGRepresentation([UIImage imageWithData:imageDate], 0.1);
    }else
    {
        appendImageData = imageDate;
    }
    return appendImageData;
}

+ (BOOL)canPlayAudioWithVersion:(NSString *)version
{
    NSString *minVersionStr = @"1.3.1";
    
    BOOL canPlay = YES;
    
    if ([version compare:minVersionStr options:NSNumericSearch] == NSOrderedAscending) {
        canPlay = NO;
    } else {
        canPlay = YES;
    }
    
    return canPlay;
}

+ (NSString *)getVersionString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (CGFloat)getMyLocationLabelHeight:(NSArray *)labelArray {
    CGFloat labelHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:12 labelWidth:SCREEN_WIDTH] + 16;
    CGFloat titleHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH];
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger yCount = 0;
    
    for (ZZMyLocationModel *label in labelArray) {
        CGFloat labelWidth = [ZZUtils widthForCellWithText:[NSString stringWithFormat:@"%@ • %.2fKM", label.simple_address, [label currentDistance:[ZZUserHelper shareInstance].location]] fontSize:12] + 16;
        if (count == 0) {
            width = labelWidth;
        } else {
            width = width + labelWidth + 18;
        }
        if (width >= SCREEN_WIDTH - 60) {
            width = labelWidth;
            yCount++;
        }
        count++;
    }
    return titleHeight + 45 + yCount*(labelHeight+10) + labelHeight;
}

+ (CGFloat)getLabelHeight:(NSArray *)labelArray
{
    CGFloat labelHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:12 labelWidth:SCREEN_WIDTH] + 16;
    CGFloat titleHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH];
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger yCount = 0;
    
    for (ZZUserLabel *label in labelArray) {
        CGFloat labelWidth = [ZZUtils widthForCellWithText:label.content fontSize:12] + 16;
        if (count == 0) {
            width = labelWidth;
        } else {
            width = width + labelWidth + 18;
        }
        if (width >= SCREEN_WIDTH - 60) {
            width = labelWidth;
            yCount++;
        }
        count++;
    }
    return titleHeight + 45 + yCount*(labelHeight+10) + labelHeight;
}

+ (CGFloat)getTagViewHeight:(NSArray *)tagArray fontSize:(CGFloat)fontSize padding:(UIEdgeInsets)padding lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing maxWidth:(CGFloat)maxWidth
{
    CGFloat titleHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:fontSize labelWidth:SCREEN_WIDTH] + padding.top + padding.bottom;
    
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger yCount = 0;
    
    for (NSString *label in tagArray) {
        CGFloat labelWidth = [ZZUtils widthForCellWithText:label fontSize:fontSize] + padding.left + padding.right;
        if (count == 0) {
            width = labelWidth;
        } else {
            width = width + labelWidth + interitemSpacing;
        }
        if (width >= maxWidth) {
            width = labelWidth;
            yCount++;
        }
        count++;
    }
    
    return yCount*(titleHeight + lineSpacing) + titleHeight;
}

+ (void)networkReachability:(void (^)(void))block
{
    switch ([[ZZAFNHelper shareInstance] reachabilityManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusUnknown:
        {
            [ZZHUD showErrorWithStatus:@"无法访问网络"];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            block();
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [UIAlertController showOkCancelAlertIn:[UIViewController currentDisplayViewController]
                                             title:nil
                                           message:@"没wifi啦，允许使用流量播放当前内容"
                                      confirmTitle:@"允许"
                                    confirmHandler:^(UIAlertAction * _Nonnull action) {
                block();
            } cancelTitle:@"不允许" cancelHandler:nil];
        }
            break;
        default:
            break;
    }
}

+ (BOOL)isBan {
    if ([ZZUserHelper shareInstance].loginer.banStatus && ![[ZZUserHelper shareInstance].loginer.ban.cate isEqualToString:@"1"]) {
        [ZZHUD showErrorWithStatus:@"你当前处于被封禁状态，无法进行此操作"];
        return YES;
    }
    return NO;
}

+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (void)clearMemoryCache
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

+ (void)managerUnread
{
    if ([ZZUserHelper shareInstance].isLogin) {
        [[ZZTabBarViewController sharedInstance] manageUnreadCountWithCount:0];
    }
}

+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

+ (NSString *)deleteEmptyStrWithString:(NSString *)string
{
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return str;
}

//生成二维码图片
+ (UIImage *)createQRCodeImgWithString:(NSString *)string imgHeight:(CGFloat)imgHeight
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    CGFloat scale = MIN(imgHeight/CGRectGetWidth(extent), imgHeight/CGRectGetHeight(extent));;
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *codeImg =[UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    
    return codeImg;
//    return [self imageBlackToTransparent:codeImg withRed:10 andGreen:10 andBlue:10];
}

//给图片上色
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

//两张图片合成一张图片
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2, (image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 size:(CGSize)size
{
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake((image1.size.width - size.width)/2, (image1.size.height - size.height)/2, size.width, size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(rect.origin.x, rect.origin.y, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake((image1.size.width - rect.size.width)/2, (image1.size.height - rect.size.height)/2, rect.size.width, rect.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

//修改图片尺寸
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

+ (UIImage *)getScrollViewimage:(UIScrollView *)scrollView;
{
    UIImage* viewImage = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+ (UIImage *)getViewImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
//获取手机型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    // 增加新设备型号
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3" ])  return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] ||
        [deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

+ (NSMutableAttributedString *)setLineSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    [paragraphStyle setLineSpacing:space];
    
    return attributedString;
}

+ (NSMutableAttributedString *)setWordSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSKernAttributeName:@(space)}];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    
    return attributedString;
}

+ (NSString *)getCountStringWithCount:(NSInteger)count
{
    if (count < 1000) {
        return [NSString stringWithFormat:@"%ld",count];
    } else if (count < 10000) {
        return [NSString stringWithFormat:@"%.1fk",(count/1000.0)];
    } else {
        return [NSString stringWithFormat:@"%.1fw",(count/10000.0)];
    }
}

+ (NSString *)dealAccuracyNumber:(NSNumber *)number
{
    double f = [number doubleValue];
    
    if (fmod(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmod(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

+ (NSString *)dealAccuracyDouble:(double)value
{
    if (fmod(value, 1) == 0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",value];
    }
    else if (fmod(value*10, 1) == 0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",value];
    }
    else {
        return [NSString stringWithFormat:@"%.2f",value];
    }
}

+ (BOOL)isIdentifierAuthority:(ZZUser *)user {
    if (user.realname.status == 2) {
        return YES;
    }
    if (user.realname_abroad.status == 2) {
        return YES;
    }
    return NO;
}

+ (void)imageLoadAnimation:(UIImageView *)imageView imageUrl:(NSURL *)imageUrl {
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (![[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl.absoluteString]) {
            imageView.alpha = 0.0;
            [UIView transitionWithView:imageView
                              duration:1.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [imageView setImage:image];
                                imageView.alpha = 1.0;
                            } completion:NULL];
        }
    }];
}

/**
 获取视频的第一帧
 @param videoUrl 视频的url
 */
+ (UIImage *)getThumbImageWithVideoUrl:(NSURL *)videoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CMTime timer = CMTimeMake(1, 30);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [assetImageGenerator copyCGImageAtTime:timer actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

+ (NSString *)getUserShowName:(ZZUser *)user
{
    return user.nickname;
}

+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    objc_property_t * superProperties = class_copyPropertyList([instance
                                                                superclass], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property =superProperties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(superProperties);
            return YES;
        }
    }
    free(superProperties);
    return NO;
}

+ (BOOL)isUserLogin
{
    if (![ZZUserHelper shareInstance].isLogin) {
        UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navCtl = [tabs selectedViewController];
          NSLog(@"PY_登录界面%s",__func__);
        [[LoginHelper sharedInstance] showLoginViewIn:navCtl];
        return NO;
    }
    return YES;
}

+ (NSUInteger)getVideoTimeDuring:(NSURL *)videoPth
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoPth options:opts];
    NSUInteger second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    
    return second;
}

+ (NSString *)dealUserNameWithStar:(NSString *)name
{
    if (name.length > 1) {
        return [name stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
    } else {
        return name;
    }
}

+ (NSComparisonResult)compareWithValue1:(id)value1 value2:(id)value2
{
    NSDecimalNumber *number1 = [self getNumberWithValue:value1];
    NSDecimalNumber *number2 = [self getNumberWithValue:value2];
    return [number1 compare:number2];
}

+ (NSDecimalNumber *)getNumberWithValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return [[NSDecimalNumber alloc] initWithString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@",value]];
    }
    return [[NSDecimalNumber alloc] initWithFloat:[value floatValue]];
}

+ (BOOL)liveStreamIsLowBalance:(CGFloat)money
{
    if ([ZZUtils compareWithValue1:[NSNumber numberWithFloat:money] value2:[ZZUserHelper shareInstance].loginer.balance] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (void)sendCommand:(NSString *)name uid:(NSString *)uid param:(NSDictionary *)param
{
    RCCommandMessage *message = [RCCommandMessage messageWithName:name data:[self dictionaryToJson:param]];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:uid content:message pushContent:nil pushData:nil success:^(long messageId) {
        NSLog(@"%@",name);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
}

+ (BOOL)isConnecting
{
    if ([ZZLiveStreamHelper sharedInstance].connecting) {
        [ZZHUD showErrorWithStatus:@"正在视频通话，请稍后再试"];
        return YES;
    }
    return NO;
}

+ (BOOL)isAllowRecord
{
    if (![self isAllowCamera]) {
        return NO;
    }
    if (![self isAllowAudio]) {
        return NO;
    }
    if ([self isConnecting]) {
        return NO;
    }
    return YES;
}

+ (void)checkRecodeAuth:(Authorized)auth
{
    if ([self isConnecting]) {
        if (auth) {
            auth(NO);
        }
    }else {
        [ZZVideoHelper checkAuthority:^(BOOL authorized) {
            if (auth) {
                auth(authorized);
            }
        }];
    }
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColor toColor:(UIColor *)toHexColor endPoint:(CGPoint )endPoint locations:(NSArray *)locationsArray type:(NSString *)type{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组
    gradientLayer.colors = @[(__bridge id)fromHexColor.CGColor,(__bridge id)toHexColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint =  endPoint;
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = locationsArray;
    
    return gradientLayer;
}

+ (CAGradientLayer *)setGradientColor:(NSArray<UIColor *> *)colorsArr locations:(NSArray<NSNumber *> *)locationsArr start:(CGPoint)startPoint end:(CGPoint)endPoint inView:(UIView *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    
    NSMutableArray *colors = @[].mutableCopy;
    [colorsArr enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colors addObject: (id)obj.CGColor];
    }];
    
    gradient.colors = colors;
    gradient.locations = locationsArr;
    
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    return gradient;
}


+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return text;
}
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

/**
 比较两个版本号
 */
+ (NSComparisonResult)compareVersionFrom:(NSString *)from to:(NSString *)to {
    NSComparisonResult result = [from compare:to options:NSNumericSearch];
    return result;
}

/**
 *  计算两个人的距离
 */
+ (CGFloat)calculateLocation:(CLLocation *)location toMy:(CLLocation *)myLocation {
    return [myLocation distanceFromLocation:location] / 1000;
}

@end
