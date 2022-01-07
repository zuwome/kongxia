//
//  ZZDownloadHelper.m
//  zuwome
//
//  Created by angBiu on 2016/12/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZDownloadHelper.h"

@implementation ZZDownloadHelper

+ (void)downloadWithUrl:(NSString *)urlString
             cachesPath:(NSString *)cachesPath
               progress:(void (^)(NSProgress *))downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler
{
    AFURLSessionManager *manager = [ZZAFNHelper sharedURLSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
    {
        downloadProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSLog(@"下载的贴纸的后缀名%@",response.suggestedFilename);
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        completionHandler(response,filePath,error);
    }];
    [downloadTask resume];
}

@end
