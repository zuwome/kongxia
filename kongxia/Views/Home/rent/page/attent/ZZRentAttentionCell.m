//
//  ZZRentAttentionCell.m
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentAttentionCell.h"

#import "ZZUserFollowModel.h"

@implementation ZZRentAttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.userInteractionEnabled = NO;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headImgView.mas_centerY);
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
        }];
        
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        [self.contentView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(30);
            make.centerY.mas_equalTo(_sexImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = kGrayTextColor;
        _vLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_vLabel];
        
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-75);
        }];
        
        _attentView = [[ZZAttentView alloc] init];
        _attentView.fontSize = 12;
        [self.contentView addSubview:_attentView];
        
        [_attentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(58, 21));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setData:(ZZUserFollowModel *)model
{
    [_headImgView setUser:model.user width:50 vWidth:12];
    _nameLabel.text = model.user.nickname;
    
    CGFloat nameWidth = [ZZUtils widthForCellWithText:model.user.nickname fontSize:15];
    CGFloat maxWidth = SCREEN_WIDTH - 15 - 50 - 15 - 5 - 15 - 5 - 20 - 75 - 5- 30;
    
    if (model.user.gender == 2) {
        _sexImgView.image = [UIImage imageNamed:@"girl"];
    } else if (model.user.gender == 1) {
        _sexImgView.image = [UIImage imageNamed:@"boy"];
    } else {
        _sexImgView.image = [UIImage new];
    }
    if ([ZZUtils isIdentifierAuthority:model.user]) {
        _identifierImgView.hidden = NO;
        [_levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(30);
        }];
    } else {
        _identifierImgView.hidden = YES;
        [_levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
        }];
        maxWidth = maxWidth + 25;
    }
    
    [_levelImgView setLevel:model.user.level];
    
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    if (model.user.weibo.verified) {
        _vLabel.hidden = NO;
        _vLabel.text = [NSString stringWithFormat:@"V认证：%@",model.user.weibo.verified_reason];
    } else {
        _vLabel.hidden = YES;
    }
    
    if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:model.user.uid]) {
        _attentView.hidden = YES;
    } else {
        _attentView.hidden = NO;
    }
    _attentView.listFollow_status = model.follow_status;
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
