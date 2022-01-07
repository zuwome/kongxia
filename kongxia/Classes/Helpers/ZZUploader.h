//
//  ZZUploader.h
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

@class ZZPhoto;
@interface ZZUploader : NSObject

+ (ZZUploader *)shareInstance;

+ (void)putData:(NSData *)data next:(QNUpCompletionHandler)next;

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)(void))failure;

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat progress))progress success:(void (^)(NSArray *urlArray))success failure:(void (^)(void))failure;

+ (void)uploadPhotos:(NSArray<ZZPhoto *> *)photos progress:(void (^)(CGFloat progress))progress success:(void (^)(NSArray *urlArray))success failure:(void (^)(void))failure;

+ (void)uploadAacData:(NSData *)data fileName:(NSString *)fileName success:(void (^)(NSString *url))success failure:(void (^)(void))failure;

@end
