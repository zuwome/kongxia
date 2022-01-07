//
//  NSString+Qiniu.h
//  Pods
//
//  Created by wlsy on 16/1/24.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Qiniu)

- (NSURL *)qiniuURL;

- (NSURL *)widthOfQiniuURL:(NSInteger)width;
- (NSURL *)widthOfQiniuURL:(NSInteger)width webp:(BOOL)isWebp;


@end
