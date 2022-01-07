//
//  ZZFilterInputCell.m
//  zuwome
//
//  Created by angBiu on 16/5/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterInputCell.h"
#import "ZZUser.h"

@implementation ZZFilterInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.backgroundColor = kBGColor;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 6;
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.layer.cornerRadius = 27;
        _headImgView.clipsToBounds = YES;
        _headImgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(14);
            make.top.mas_equalTo(bgView.mas_top).offset(14);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-14);
            make.width.mas_equalTo(@54);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"哈哈哈哈哈";
        [self.contentView  addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(8);
            make.bottom.mas_equalTo(_headImgView.mas_centerY).offset(-8);
        }];
        
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.textAlignment = NSTextAlignmentLeft;
        _briefLabel.textColor = kGrayContentColor;
        _briefLabel.font = [UIFont systemFontOfSize:12];
        _briefLabel.text = @"嘿嘿嘿";
        [self.contentView addSubview:_briefLabel];
        
        [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
            make.top.mas_equalTo(_headImgView.mas_centerY).offset(8);
        }];
        
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(8);
            make.centerY.mas_equalTo(_sexImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0, 1);
        bgView.layer.shadowOpacity = 0.9;
        bgView.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)setDataModel:(ZZUser *)model highlight:(NSString *)highlight
{
    NSURL *url = [NSURL URLWithString:model.avatar];
    [_headImgView sd_setImageWithURL:url placeholderImage:nil];
    NSRange range = [model.nickname rangeOfString:highlight];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.nickname];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kYellowColor range:range];
        _nameLabel.attributedText = attributedString;
    } else {
        _nameLabel.text = model.nickname;
    }
    _briefLabel.text = model.bio ? model.bio : @"没个性，不签名";
    _sexImgView.image = model.gender == 1 ? [UIImage imageNamed:@"boy"] : [UIImage imageNamed:@"girl"];
    [_levelImgView setLevel:model.level];
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
