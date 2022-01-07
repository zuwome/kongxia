//
//  ZZRightShareView.h
//  zuwome
//
//  Created by angBiu on 16/5/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSInteger,RightShareType) {
    RightShareTypeWXTimeline,
    RightShareTypeWXSession,
    RightShareTypeQQ,
    RightShareTypeSina,
    RightShareTypeReport
};

@interface ZZRightCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
/**
 *  右键分享界面
 */
@interface ZZRightShareView : UIView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) RightShareType type;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) NSString *userImgUrl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *skId;

@property (nonatomic, strong) NSString *banString;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) BOOL showDelete;//是否显示删除
@property (nonatomic, assign) BOOL shouldShowNotIntersted; // 显示不感兴趣
@property (nonatomic, assign) BOOL shouldAddToBlackList; // 显示不感兴趣
@property (nonatomic, assign) BOOL isBanned;
@property (nonatomic, assign) BOOL clickDelete;
@property (nonatomic, assign) BOOL isUser;

@property (nonatomic, copy) void(^successCallBack)(NSDictionary *data);
@property (nonatomic, copy) dispatch_block_t touchBan;
@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) dispatch_block_t touchCancel;
@property (nonatomic, copy) dispatch_block_t touchRemark;
@property (nonatomic, copy) dispatch_block_t touchNotIntersted;
@property (nonatomic, copy) dispatch_block_t touchBlackList;
- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)ctl;

- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)ctl shouldShowNotIntersted:(BOOL)shouldShowNotIntersted blackList:(BOOL)blackList isBanned:(BOOL)isBanned;

- (void)show;

@end
