//
//  ZZRentScoreCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentScoreCell.h"

@implementation ZZRentScoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.userInteractionEnabled = NO;
        _imgView.image = [UIImage imageNamed:@"icXinrenzhiChakanziliao"];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:@"么么号" fontSize:15];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.text = @"信任值";
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(titleWidth);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:arrowImgView];
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 12));
        }];
        
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor = kBlackTextColor;
        _levelLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _levelLabel.text = @"高";
        [self.contentView addSubview:_levelLabel];
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _width = SCREEN_WIDTH - 115*2;
        _gradientLineView = [[UIView alloc] initWithFrame:CGRectMake(115, 20, _width, 10)];
        _gradientLineView.backgroundColor = HEXCOLOR(0xD8D8D8);
        _gradientLineView.layer.cornerRadius = 5;
        _gradientLineView.clipsToBounds = YES;
        [self.contentView addSubview:_gradientLineView];
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 10)];
        _gradientView.layer.cornerRadius = 5;
        _gradientView.clipsToBounds = YES;
        [_gradientLineView addSubview:_gradientView];
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, _width, 10);
        layer.colors = @[(id)HEXCOLOR(0xFE4C5A).CGColor,(id)HEXCOLOR(0xFF6F2A).CGColor,(id)HEXCOLOR(0xF4CB07).CGColor];
        layer.locations = @[@(0.25),@(0.5),@(0.75)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        [_gradientView.layer addSublayer:layer];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0xFF7120);
        _scoreLabel.font = [UIFont systemFontOfSize:15];
        _scoreLabel.text = @"80分";
        [self.contentView addSubview:_scoreLabel];
        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_gradientLineView.mas_right).offset(3);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        _lineView.userInteractionEnabled = NO;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
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
