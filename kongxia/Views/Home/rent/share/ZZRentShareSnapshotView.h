//
//  ZZRentShareSnapshotView.h
//  zuwome
//
//  Created by angBiu on 2016/11/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  个人页---分享快照view
 */
@interface ZZRentShareSnapshotView : UIView

@property (nonatomic, strong) ZZUser *user;

- (void)getShareSnapshotImage:(void(^)(UIImage *image))success failure:(void(^)(void))failure;

@end
