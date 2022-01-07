//
//  ZZSelectPhotoManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/24.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"

@protocol WBSelectPhotoManagerObserver <NSObject>

@optional

// 开始裁剪
- (void)videoStarClip;

// 视频剪辑完成通知
- (void)videoClipCompleteWithUrl:(NSURL *)url pixelWidth:(NSString *)pixelWidth pixelHeight:(NSString *)pixelHeight;

@end

//////////////////////////////////////////////////////////////////////

#define GetSelectPhotoManager()       ([ZZSelectPhotoManager sharedInstance])

@interface ZZSelectPhotoManager : WBBaseManager

- (void)videoStarClips;

- (void)videoClipCompleteForUrl:(NSURL *)url pixelWidth:(NSUInteger)pixelWidth pixelHeight:(NSUInteger)pixelHeight;

@end
