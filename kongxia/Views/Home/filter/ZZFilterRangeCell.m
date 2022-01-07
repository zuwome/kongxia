//
//  ZZFilterRangeCell.m
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterRangeCell.h"

#import "ZZFilterModel.h"

@implementation ZZFilterRangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        _sliderView = [[NMRangeSlider alloc] init];
        _sliderView.tintColor = kYellowColor;
        _sliderView.clipsToBounds = YES;
        [self.contentView addSubview:_sliderView];
        
        [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@35);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
        }];
        
        [_sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        _leftBubbleView = [[ZZFilterRangeBubbleView alloc] init];
        [self.contentView addSubview:_leftBubbleView];
        
        [_leftBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_sliderView.mas_top);
            make.size.mas_equalTo(CGSizeMake(53, 30));
            make.left.mas_equalTo(self.contentView.mas_left).offset(7);
        }];

        _rightBubbleView = [[ZZFilterRangeBubbleView alloc] init];
        [self.contentView addSubview:_rightBubbleView];
        
        [_rightBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_sliderView.mas_top);
            make.size.mas_equalTo(CGSizeMake(53, 30));
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    
    return self;
}

- (void)setData:(ZZFilterModel *)model indexPath:(NSIndexPath *)indexPath
{
    _sliderView.tag = indexPath.row + 100;
    switch (indexPath.row) {
        case 1:
        {
            _sliderView.minimumValue = 0;
            _sliderView.maximumValue = 34;
            _sliderView.lowerValue = 0;
            _sliderView.upperValue = 34;
            _sliderView.minimumRange = 5;
            _sliderView.stepValue = 1;
            
            if (![model.ageStr isEqualToString:@"全部"]) {
                NSArray *array = [[model.ageStr stringByReplacingOccurrencesOfString:@"岁" withString:@""] componentsSeparatedByString:@"-"];
                NSInteger lowValue = [array[0] integerValue] - 16;
                NSInteger upValue = [array[1] integerValue] - 16;
                [_sliderView setLowerValue:lowValue upperValue:upValue animated:NO];
                
                _leftBubbleView.titleLabel.text = array[0];
                _rightBubbleView.titleLabel.text = array[1];
                
                [_leftBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset(lowValue/34.0 * (SCREEN_WIDTH - 46) - 8);
                }];
                [_rightBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.contentView.mas_right).offset((upValue/34.0) * (SCREEN_WIDTH - 46) - SCREEN_WIDTH + 30);
                }];
            } else {
                _leftBubbleView.titleLabel.text = @"16";
                _rightBubbleView.titleLabel.text = @"50";
            }
        }
            break;
        case 3:
        {
            _sliderView.minimumValue = 0;
            _sliderView.maximumValue = 60;
            _sliderView.lowerValue = 0;
            _sliderView.upperValue = 60;
            _sliderView.minimumRange = 10;
            _sliderView.stepValue = 1;
            
            if (![model.heightStr isEqualToString:@"全部"]) {
                NSArray *array = [[model.heightStr stringByReplacingOccurrencesOfString:@"cm" withString:@""] componentsSeparatedByString:@"-"];
                NSInteger lowValue = [array[0] integerValue] - 140;
                NSInteger upValue = [array[1] integerValue] - 140;
                [_sliderView setLowerValue:lowValue upperValue:upValue animated:NO];
                
                _leftBubbleView.titleLabel.text = array[0];
                _rightBubbleView.titleLabel.text = array[1];
                
                
                [_leftBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset((lowValue/60.0) * (SCREEN_WIDTH - 46) - 8);
                }];
                [_rightBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.contentView.mas_right).offset((upValue/60.0) * (SCREEN_WIDTH - 46) - SCREEN_WIDTH + 30);
                }];
                
            } else {
                _leftBubbleView.titleLabel.text = @"140";
                _rightBubbleView.titleLabel.text = @"200";
            }
        }
            break;
        case 5:
        {
            _sliderView.minimumValue = 0;
            _sliderView.maximumValue = 300;
            _sliderView.lowerValue = 0;
            _sliderView.upperValue = 300;
            _sliderView.minimumRange = 40;
            _sliderView.stepValue = 1;
            
            if (![model.moneyStr isEqualToString:@"全部"]) {
                NSArray *array = [[model.moneyStr stringByReplacingOccurrencesOfString:@"元" withString:@""] componentsSeparatedByString:@"-"];
                NSInteger lowValue = [array[0] integerValue];
                NSInteger upValue = [array[1] integerValue];
                [_sliderView setLowerValue:lowValue upperValue:upValue animated:NO];
                
                _leftBubbleView.titleLabel.text = array[0];
                _rightBubbleView.titleLabel.text = array[1];
                
                [_leftBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset(lowValue/300.0 * (SCREEN_WIDTH - 46) - 8);
                }];
                [_rightBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.contentView.mas_right).offset((upValue/300.0) * (SCREEN_WIDTH - 46) - SCREEN_WIDTH + 30);
                }];
            } else {
                _leftBubbleView.titleLabel.text = @"0";
                _rightBubbleView.titleLabel.text = @"300";
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 

- (void)sliderValueChange:(NMRangeSlider *)sender
{
    [_leftBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(sender.lowerCenter.x - 15);
    }];
    [_rightBubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-(SCREEN_WIDTH - 30 - sender.upperCenter.x) + 7);
    }];
    
    NSString *valueStr = @"";
    switch (sender.tag - 100) {
        case 1:
        {
            _leftBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.lowerValue+ 16];
            _rightBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.upperValue + 16];
            
            if (sender.lowerValue == 0 && sender.upperValue == 34) {
                valueStr = @"全部";
            } else {
                valueStr = [NSString stringWithFormat:@"%d-%d岁", (int)sender.lowerValue+16, (int)sender.upperValue +16];
            }
        }
            break;
        case 3:
        {
            _leftBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.lowerValue+ 140];
            _rightBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.upperValue + 140];
            
            if (sender.lowerValue == 0 && sender.upperValue == 60) {
                valueStr = @"全部";
            } else {
                valueStr = [NSString stringWithFormat:@"%d-%dcm", (int)sender.lowerValue+140, (int)sender.upperValue+140];
            }
        }
            break;
        case 5:
        {
            _leftBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.lowerValue+ 0];
            _rightBubbleView.titleLabel.text = [NSString stringWithFormat:@"%d", (int)sender.upperValue + 0];
            
            if (sender.lowerValue == 0 && sender.upperValue == 300) {
                valueStr = @"全部";
            } else {
                valueStr = [NSString stringWithFormat:@"%d-%d元", (int)sender.lowerValue+0, (int)sender.upperValue+0];
            }
        }
            break;
        default:
            break;
    }
    
    if (_sliderChange) {
        _sliderChange(valueStr);
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
