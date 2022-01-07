//
//  ZZACRRecognitionHelper.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZACRRecognitionHelper.h"
#import "ACRCloudConfig.h"
#import "ACRCloudRecognition.h"

@interface ZZACRRecognitionHelper ()

@property (nonatomic, strong) ACRCloudConfig *config;

@property (nonatomic, strong) ACRCloudRecognition *client;

@end

@implementation ZZACRRecognitionHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    _config = [[ACRCloudConfig alloc] init];
    _config.accessKey = @"d7791dd1b0a658262d5bebe0e3d1ee07";
    _config.accessSecret = @"c3IqVmWAhGhL3Sylv8zWBNAzUsGUD0k1iQMriGzW";
    _config.host = @"identify-cn-north-1.acrcloud.com";
    _config.protocol = @"https";
    _config.recMode = rec_mode_remote;
    _config.recDataType = rec_data_humming;
}


#pragma mark - public Method
- (void)recogniteSong:(NSString *)title
             filePath:(NSString *)filePath
      completeHandler:(void (^)(BOOL))completeHandler {
    _config.params = @{
        @"title": title,
        @"channel": @1,
        @"sampleRate": @8000,
    };
    if (_client) {
        _client = nil;
    }
    _client = [[ACRCloudRecognition alloc] initWithConfig:_config];
    [self startRecognitionWithFilePath:filePath completeHandler:completeHandler];
}


#pragma mark - private method
- (void)startRecognitionWithFilePath:(NSString *)filePath completeHandler:(void(^)(BOOL isRecognited))completeHandler {
    NSData *humingData = [NSData dataWithContentsOfFile:filePath];
    NSData *fingerPrintsData = [ACRCloudRecognition get_hum_fingerprint:humingData];
    NSString *result =  [_client recognize_hum_fp:fingerPrintsData];
    [self handleResult:result completeHandler:completeHandler];
}

- (void)handleResult:(NSString *)result completeHandler:(void(^)(BOOL isRecognited))completeHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"result:%@", result);
    
        NSError *error = nil;
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSString *r = nil;
        if ([[jsonObject valueForKeyPath: @"status.code"] integerValue] == 0) {
            if ([jsonObject valueForKeyPath: @"metadata.music"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.music"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *artist = [meta objectForKey:@"artists"][0][@"name"];
                NSString *album = [meta objectForKey:@"album"][@"name"];
                NSString *play_offset_ms = [meta objectForKey:@"play_offset_ms"];
                NSString *duration = [meta objectForKey:@"duration_ms"];

                NSArray *ra = @[[NSString stringWithFormat:@"title:%@", title],
                            [NSString stringWithFormat:@"artist:%@", artist],
                              [NSString stringWithFormat:@"album:%@", album],
                                [NSString stringWithFormat:@"play_offset_ms:%@", play_offset_ms],
                                [NSString stringWithFormat:@"duration_ms:%@", duration]];
                r = [ra componentsJoinedByString:@"\n"];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_files"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_files"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *audio_id = [meta objectForKey:@"audio_id"];
                
                r = [NSString stringWithFormat:@"title : %@\naudio_id : %@", title, audio_id];
            }
            if ([jsonObject valueForKeyPath: @"metadata.streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                NSString *title_en = [meta objectForKey:@"title_en"];
                
                r = [NSString stringWithFormat:@"title : %@\ntitle_en : %@", title,title_en];
            }
            if ([jsonObject valueForKeyPath: @"metadata.custom_streams"]) {
                NSDictionary *meta = [jsonObject valueForKeyPath: @"metadata.custom_streams"][0];
                NSString *title = [meta objectForKey:@"title"];
                
                r = [NSString stringWithFormat:@"title : %@", title];
            }
            if ([jsonObject valueForKeyPath: @"metadata.humming"]) {
                NSArray *metas = [jsonObject valueForKeyPath: @"metadata.humming"];
                NSMutableArray *ra = [NSMutableArray arrayWithCapacity:6];
                for (id d in metas) {
                    NSString *title = [d objectForKey:@"title"];
                    NSString *score = [d objectForKey:@"score"];
                    NSString *sh = [NSString stringWithFormat:@"title : %@  score : %@", title, score];
                    
                    [ra addObject:sh];
                }
                r = [ra componentsJoinedByString:@"\n"];
            }
            NSLog(@"r: result is %@",r);
            
            if (completeHandler) {
                completeHandler(YES);
            }
        }
        else {
            NSLog(@"result: result is %@",result);
            if (completeHandler) {
                completeHandler(NO);
            }
        }
    });
}

@end
