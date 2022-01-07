//
//  ZZChatShotViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger, CurrentAction) {
    ActionTakePicture,
    ActionTakeVideo,
};

@class ZZChatShotViewController;

@protocol ZZChatShotViewControllerDelegate <NSObject>

- (void)controller:(ZZChatShotViewController *)controller didTakePicture:(UIImage *)picture;

- (void)controller:(ZZChatShotViewController *)controller didTakeVideo:(NSURL *)videoURL thumbnail:(UIImage *)thumbnail;

@end

@interface ZZChatShotViewController : ZZViewController

@property (nonatomic, assign) CurrentAction action;

@property (nonatomic, weak) id<ZZChatShotViewControllerDelegate> delegate;

@end


@interface ZZChatShotCircleBgView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)clearLayer;

@end
