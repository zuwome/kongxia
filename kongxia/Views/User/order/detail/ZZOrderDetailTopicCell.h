//
//  ZZOrderDetailTopicCell.h
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
/**
 *  订单详情
 */
@interface ZZOrderDetailTopicCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UIImageView *identifierImgView;//身份认证img
@property (nonatomic, strong) UILabel *moneyLabel;//每小时金额
@property (nonatomic, strong) UILabel *capitalFlowsLabel; // 资金流向Label
@property (nonatomic, strong) UILabel *infoLabel;//感叹号
@property (nonatomic, strong) UILabel *skillLabel;//主题
@property (nonatomic, strong) UILabel *vLabel;//v认证
@property (nonatomic, strong) UIView *lineView;//线
@property (nonatomic, strong) UILabel *hourLabel;//12:00
@property (nonatomic, strong) UILabel *dayLabel;//2014-11
@property (nonatomic, strong) UILabel *locationLabel;//地址
@property (nonatomic, strong) UIButton *locationBtn;//地址图片
@property (nonatomic, strong) UILabel *distanceLabel;//距离
@property (nonatomic, strong) UILabel *reasonLabel;//退款理由
@property (nonatomic, strong) UILabel *refundMoneyLabel;//退款金额
//@property (nonatomic, strong) UILabel *appealResultLabel;//拒绝退款之后，平台判别的处理结果
@property (nonatomic,strong)  UILabel   *responsibilityLabel;//责任说明
@property (nonatomic,strong)  UILabel   *responsibilityDetailLabel;//责任说明详情

@property (nonatomic, copy) NSString *moneyFlowDescript;

@property (nonatomic, copy) dispatch_block_t locationClick;//点击地址
@property (nonatomic, copy) dispatch_block_t tapAvatarClick;//点击头像
@property (nonatomic, copy) dispatch_block_t capitalFlowProtocolClick;//点击头像

- (void)setOrder:(ZZOrder *)order type:(OrderDetailType)type moneyFlowDescript:(NSString *)moneyFlowDescript from:(BOOL)from;

@end
