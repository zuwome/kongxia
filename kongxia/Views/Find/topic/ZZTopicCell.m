//
//  ZZTopicCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicCell.h"

@implementation ZZTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bgView.layer.cornerRadius = 3;
        self.typeImgView.image = [UIImage imageNamed:@"icon_find_hot_p"];
        self.typeLabel.text = @"热门话题";
        self.contentLabel.text = @"污中生友污中生友昨晚的位来看刀剑乱理丽我点击我就…";
        self.topicLabel.text = @"#小火车污污污 #";
        self.countLabel.text = @"677围观 ";
    }
    
    return self;
}

- (void)setData:(ZZTopicModel *)model
{
    self.contentLabel.text = model.group.desc;
    self.topicLabel.text = model.group.content;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.group.cover_url]];
    self.countLabel.text = [NSString stringWithFormat:@"%ld人围观",(long)model.group.browser_count];
    if (model.group.hot) {
        self.typeLabel.hidden = NO;
        self.typeImgView.hidden = NO;
    } else {
        self.typeLabel.hidden = YES;
        self.typeImgView.hidden = YES;
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = YES;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = kBlackTextColor;
        _coverView.layer.cornerRadius = 3;
        _coverView.alpha = 0.5;
        [_bgView addSubview:_coverView];
        
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
    }
    return _bgView;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(5);
            make.top.mas_equalTo(_bgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(13, 15.3));
        }];
    }
    return _typeImgView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_typeImgView.mas_centerY);
        }];
    }
    return _typeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
        }];
    }
    return _contentLabel;
}

- (UILabel *)topicLabel
{
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] init];
        _topicLabel.textColor = [UIColor whiteColor];
        _topicLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_topicLabel];
        
        [_topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.bottom.mas_equalTo(_contentLabel.mas_top).offset(-8);
        }];
    }
    return _topicLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(8);
        }];
    }
    return _countLabel;
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
