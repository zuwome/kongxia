//
//  ZZDisturbTimeCell.m
//  zuwome
//
//  Created by angBiu on 2017/5/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDisturbTimeCell.h"

@interface ZZDisturbTimeCell ()

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ZZDisturbTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = kBGColor;
        
        self.shadowView = [UIView new];
        self.shadowView.backgroundColor = kBGColor;
        _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        _shadowView.layer.shadowOpacity = 0.5;//不透明度
        _shadowView.layer.shadowRadius = 2.0f;
        _shadowView.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.top.equalTo(@0);
            make.trailing.equalTo(@(-5));
            make.bottom.equalTo(@(-5));
        }];

        UIView *bgWhiteView = [UIView new];
        bgWhiteView.backgroundColor = [UIColor whiteColor];
        bgWhiteView.layer.masksToBounds = YES;
        bgWhiteView.layer.cornerRadius = 3.0f;
        
        [self.contentView addSubview:bgWhiteView];
        [bgWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@(-0));
            make.bottom.equalTo(@(-5));
        }];
        [bgWhiteView addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(14.5);
            make.right.offset(-14.5);
            make.height.equalTo(@0.5);
            make.top.equalTo(bgWhiteView.mas_top);
        }];
        self.titleLabel.text = @"设置免打扰时间段";
        self.arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        self.contentLabel.text = @"23:00至06:00";
        
    }
    
    return self;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(218, 218, 218);
    }
    return _lineView ;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-2);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-2);
        }];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-2);
            make.size.mas_equalTo(CGSizeMake(8, 16.5));
        }];
    }
    return _arrowImgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
