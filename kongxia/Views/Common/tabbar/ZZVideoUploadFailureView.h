//
//  ZZVideoUploadFailureView.h
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 上传失败view
 */
@interface ZZVideoUploadFailureView : UIView

@property (nonatomic, assign) BOOL viewShow;

+ (id)sharedInstance;
- (void)showView;
- (void)hideView;

@end
