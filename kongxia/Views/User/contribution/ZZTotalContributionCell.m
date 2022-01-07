//
//  ZZTotalContributionCell.m
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTotalContributionCell.h"

@implementation ZZTotalContributionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _levelLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0xADADB1) fontSize:21 text:@""];
        [bgView addSubview:_levelLabel];
        
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.userInteractionEnabled = NO;
        [bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_levelLabel.mas_right).offset(12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(49, 49));
        }];
        
        _nameLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:15 text:@""];
        [bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(12);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [bgView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0xADADB1) fontSize:14 text:@""];
        [bgView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
        }];
        
        _attentView = [[ZZAttentView alloc] init];
        _attentView.fontSize = 12;
        [bgView addSubview:_attentView];
        
        [_attentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(58, 21));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [bgView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(13);
            make.right.mas_equalTo(bgView.mas_right).offset(-13);
            make.top.mas_equalTo(bgView.mas_top);
            make.height.mas_equalTo(@1);
        }];
    }
    
    return self;
}

- (void)setData:(ZZTotalTipListModel *)model indexPath:(NSIndexPath *)indexPath
{
    _levelLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 4];
    [_headImgView setUser:model.tip_total.from width:49 vWidth:10];
    _nameLabel.text = model.tip_total.from.nickname;
    _moneyLabel.text = [NSString stringWithFormat:@"贡献 ¥%.2f",model.tip_total.price];
    _attentView.listFollow_status = model.tip_total.from.follow_status;
    _attentView.user = model.tip_total.from;
    
    if (indexPath.row == 0) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = YES;
    }
    
    [_levelImgView setLevel:model.tip_total.from.level];
    
    CGFloat levelWidth = [ZZUtils widthForCellWithText:_levelLabel.text fontSize:21];
    CGFloat maxWidth = SCREEN_WIDTH - 30 - 12 - levelWidth - 12 - 5 - 30 - 5 - 12 - 60;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:15];
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
}

- (void)setMMDData:(ZZMMDTipListModel *)model indexPath:(NSIndexPath *)indexPath
{
    _levelLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 4];
    [_headImgView setUser:model.tip.from width:49 vWidth:10];
    _headImgView.isAnonymous = model.tip.is_anonymous;
    _nameLabel.text = model.tip.from.nickname;
    _moneyLabel.text = [NSString stringWithFormat:@"贡献 ¥%.2f",model.tip.price];
    _attentView.listFollow_status = model.tip.from.follow_status;
    _attentView.user = model.tip.from;
    
    if (indexPath.row == 0) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = YES;
    }
    
    [_levelImgView setLevel:model.tip.from.level];
    if (model.tip.is_anonymous) {
        _attentView.hidden = YES;
        _levelImgView.hidden = YES;
    } else {
        _attentView.hidden = NO;
        _levelImgView.hidden = NO;
    }
    
    CGFloat levelWidth = [ZZUtils widthForCellWithText:_levelLabel.text fontSize:21];
    CGFloat maxWidth = SCREEN_WIDTH - 30 - 12 - levelWidth - 12 - 5 - 30 - 5 - 12 - 60;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:15];
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
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
