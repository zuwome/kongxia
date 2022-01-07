//
//  ZZOrderListCell.m
//  zuwome
//
//  Created by angBiu on 2016/12/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderListCell.h"

@interface ZZOrderListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *statusTitleLabel;

@end

@implementation ZZOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = kBGColor;
        [self.contentView addSubview:self.bgView];
    }
    
    return self;
}

- (void)setData:(ZZOrder *)order
{
    _skillLabel.text = [NSString stringWithFormat:@"主题: %@", order.skill.name];
    
    double totalPrice = order.totalPrice.doubleValue;
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %@", [ZZUtils dealAccuracyNumber:[NSNumber numberWithDouble:totalPrice]]];

    if (order.type == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%d小时", order.hours];
    } else {
        _timeLabel.text = order.hours_text;
    }
    BOOL isFrom = [[ZZUserHelper shareInstance].loginer.uid isEqualToString:order.from.uid]?YES:NO;
    if (isFrom) {
        /// 圆角头像
        [_headImgView setUser:order.to width:50 vWidth:12];
        _nameLabel.text = order.to.nickname;
    } else {
        [_headImgView setUser:order.from width:50 vWidth:12];
        _nameLabel.text = order.from.nickname;
    }
    
    if (order.type == 4) {//闪聊的情况下，才会显示么币
        if (isFrom) {
            _moneyLabel.text = [NSString stringWithFormat:@"%@么币", [ZZUtils dealAccuracyNumber:order.totalPrice]];
        } else {
            _moneyLabel.text = [NSString stringWithFormat:@"¥ %@", [ZZUtils dealAccuracyNumber:order.totalPrice]];
        }
    }
    _statusLabel.text = order.statusText;
}

- (void)deleteBtnClick
{
    NSLog(@"delete");
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 140)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.userInteractionEnabled = NO;
        [_bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.top.mas_equalTo(_bgView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _nameLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:17 text:@""];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.bottom.mas_equalTo(_headImgView.mas_centerY).offset(-3);
        }];
        
        _skillLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayTextColor fontSize:14 text:@""];
        [_bgView addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_headImgView.mas_centerY).offset(3);
        }];
        
        _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:17 text:@""];
        [_bgView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
        }];
        
        _timeLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayTextColor fontSize:14 text:@""];
        [_bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_moneyLabel.mas_right);
            make.centerY.mas_equalTo(_skillLabel.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [_bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_left);
            make.right.mas_equalTo(_moneyLabel.mas_right);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(20);
            make.height.mas_equalTo(@1);
        }];
        
        _statusTitleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:14 text:@"邀约状态："];
        [_bgView addSubview:_statusTitleLabel];
        
        [_statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineView.mas_left);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.bottom.mas_equalTo(_bgView.mas_bottom);
        }];
        
        _statusLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:14 text:@""];
        [_bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_statusTitleLabel.mas_right).offset(2);
            make.centerY.mas_equalTo(_statusTitleLabel.mas_centerY);
        }];
    }
    
    return _bgView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
