//
//  ZZUploader.m
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUploader.h"
#import "ZZUserHelper.h"
#import "ZZPhoto.h"
#import "QNUploadHelper.h"

@interface ZZUploader ()

@end

@implementation ZZUploader

+ (ZZUploader *)shareInstance {
    static dispatch_once_t ZZUploaderOnce = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&ZZUploaderOnce, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (void)putData:(NSData *)data next:(QNUpCompletionHandler)next {
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    NSString *token = [userHelper uploadToken];
    NSString *uid = userHelper.loginerId;
    
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *key;
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if (uid) {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",uid,timeInterval+[strRandom integerValue]];
    } else {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",strRandom,timeInterval+[strRandom integerValue]];
    }
    NSLog(@"timeinterval ====== %f\n ===== %ld KEY ====== %@",[[NSDate date] timeIntervalSince1970],(long)timeInterval,key);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      next(info, key, resp);
                  });
                  if (!resp) {
                      [self uploadLogs:info key:key isImage:YES];
                  }
              } option:nil];
}

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *))success failure:(void (^)(void))failure {
    NSData *data = [ZZUtils imageRepresentationDataWithImage:image];
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    NSString *token = [userHelper uploadToken];
    NSString *uid = userHelper.loginerId;
    
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *key;
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if (uid) {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",uid,timeInterval+[strRandom integerValue]];
    } else {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",strRandom,timeInterval+[strRandom integerValue]];
    }
    NSLog(@"KEY ====== %@",key);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (info.statusCode == 200 && resp) {
                          NSString *url = resp[@"key"];
                          if (success) {
                              success(url);
                          }
                      } else {
                          if (failure) {
                              failure();
                          }
                          [self uploadLogs:info key:key isImage:YES];
                      }
                  });
              } option:nil];
    
}

+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QNUploadHelper *helper = [QNUploadHelper shareInstance];
    __weak typeof(helper) weakHelper = helper;
    helper.singleFailureBlock = ^{
        failure();
        return;
    };
    helper.singleSuccessBlock = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            if (currentIndex<imageArray.count) {
                [ZZUploader uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
        }
    };
    
    [ZZUploader uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

+ (void)uploadLogs:(QNResponseInfo *)info  key:(NSString *)key isImage:(BOOL)isImage {
    if ([ZZUserHelper shareInstance].unreadModel.open_log) {
        NSString *string = @"上传图片错误";
        if (!isImage) {
            string = @"上传视频错误";
        }
        NSMutableDictionary *param = [@{@"type":string} mutableCopy];
        if ([ZZUserHelper shareInstance].uploadToken) {
            [param setObject:[ZZUserHelper shareInstance].uploadToken forKey:@"uploadToken"];
        }
        if (info.error) {
            [param setObject:[NSString stringWithFormat:@"%@",info.error] forKey:@"error"];
        }
        if (info.statusCode) {
            [param setObject:[NSNumber numberWithInt:info.statusCode] forKey:@"statusCode"];
        }
        if ([ZZUserHelper shareInstance].isLogin) {
            NSDictionary *dict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                   @"content":[ZZUtils dictionaryToJson:param]};
            [ZZUserHelper uploadLogWithParam:dict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                
            }];
        }
    }
}

+ (void)uploadPhotos:(NSArray<ZZPhoto *> *)photos progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    
    dispatch_group_t uploadGroup = dispatch_group_create();

    [photos enumerateObjectsUsingBlock:^(ZZPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(uploadGroup);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [ZZUtils userImageRepresentationDataWithImage:obj.image];
                        
            // 上传七牛
            [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (resp) {
                    ZZPhoto *photo = [[ZZPhoto alloc] init];
                    photo.url = resp[@"key"];
                    
                    // 上传自己服务器
                    [photo add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        dispatch_group_leave(uploadGroup);
                        
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                        if (error) {
//                            [ZZHUD showErrorWithStatus:error.message];
                        }
                        else {
                            [ZZHUD dismiss];
                            ZZPhoto *newPhoto = [[ZZPhoto alloc] initWithDictionary:data error:nil];
                            obj.url = newPhoto.url;
                        }
                    }];
                }
                else {
                    dispatch_group_leave(uploadGroup);
                }
            }];
        });
    }];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        __block BOOL isSuccess = YES;
        [photos enumerateObjectsUsingBlock:^(ZZPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (isNullString(obj.url)) {
                isSuccess = NO;
                *stop = YES;
            }
        }];
        
        if (isSuccess) {
            if (success) {
                success(nil);
            }
        }
        else {
            if (failure) {
                failure();
            }
        }
    });
}

+ (void)uploadAacData:(NSData *)data fileName:(NSString *)fileName success:(void (^)(NSString *url))success failure:(void (^)(void))failure {
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    NSString *token = [userHelper uploadToken];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:fileName token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (info.statusCode == 200 && resp) {
                          NSString *url = resp[@"key"];
                          if (success) {
                              success(url);
                          }
                      } else {
                          if (failure) {
                              failure();
                          }
                          [self uploadLogs:info key:key isImage:YES];
                      }
                  });
              } option:nil];
}
@end
