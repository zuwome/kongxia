//
//  ZZACRRecognitionHelper.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZZACRRecognitionHelper : NSObject

- (instancetype)init;

- (void)recogniteSong:(NSString *)title filePath:(NSString *)filePath completeHandler:(void(^)(BOOL isRecognited))completeHandler;

@end

