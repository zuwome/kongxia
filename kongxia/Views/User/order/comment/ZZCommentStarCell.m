//
//  ZZCommentStarCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZCommentStarCell.h"

@implementation ZZCommentStarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = 23;
        CGFloat offset = 18;
        CGFloat viewWidth = width + 4*(width+offset);
        _starView = [[ZZStarsView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - viewWidth)/2.0, 32, viewWidth, 38)];
        _starView.starWidth = width;
        _starView.starOffset = offset;
        _starView.delegate = self;
        _starView.numberOfStars = 5;
        [self.contentView addSubview:_starView];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = kBlackTextColor;
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.text = @"您的评价会让TA做的更好";
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(_starView.mas_bottom).offset(16);
        }];
    }
    
    return self;
}

- (void)starsView:(ZZStarsView *)starsView currentScore:(CGFloat)currentScore
{
    int score = (int)currentScore;
    switch (score) {
        case 1:
        {
            _infoLabel.text = @"态度很差，体验不好，与真人不符";
        }
            break;
        case 2:
        {
            _infoLabel.text = @"态度较差，影响体验";
        }
            break;
        case 3:
        {
            _infoLabel.text = @"态度一般，体验一般";
        }
            break;
        case 4:
        {
            _infoLabel.text = @"态度很棒，体验很赞";
        }
            break;
        case 5:
        {
            _infoLabel.text = @"态度超级棒，体验超级好";
        }
            break;
        default:
            break;
    }
    if (_currentScore) {
        _currentScore(score);
    }
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
