//
//  ZZChatVideoPlayerController.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger, VideoPlayerViewEntrance) {
    EntranceChat,
    EntranceOthers,
};

@interface ZZChatVideoPlayerController : ZZViewController

@property (nonatomic, assign) VideoPlayerViewEntrance entrance;

@property (nonatomic, strong) NSString *videoUrl;

@end

