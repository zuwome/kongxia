//
//  ZZSnatchOrderNotificationCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeSnatchPush,
    NotificationTypeSnatchSms,
    NotificationTypeTaskFreeSms,
};

@class ZZSnatchOrderNotificationCell;

@protocol ZZSnatchOrderNotificationCellDelegate <NSObject>

- (void)cell:(ZZSnatchOrderNotificationCell *)cell type:(NotificationType)type on:(BOOL)isOne;

@end

@interface ZZSnatchOrderNotificationCell : UITableViewCell

@property (nonatomic, assign) NotificationType type;

@property (nonatomic, weak) id<ZZSnatchOrderNotificationCellDelegate> delegate;

@property (nonatomic, strong) UISwitch *aSwitch;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end
