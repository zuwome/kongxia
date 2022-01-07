//
//  ZZUserCentInfoCell.h
//  zuwome
//
//  Created by angBiu on 16/10/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我 ---- 用户信息cell
 */
@class ZZUserCenterInfoCell;
@protocol ZZUserCenterInfoCellDelegate <NSObject>

- (void)cellWithRealFaceAction:(ZZUserCenterInfoCell *)cell;

@end

@interface ZZUserCenterInfoCell : UITableViewCell

@property (nonatomic, weak) id<ZZUserCenterInfoCellDelegate> delegate;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UILabel *memehaoLabel;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

- (void)setData:(ZZUser *)user;

@end
