//
//  ZZPostTaskBasicInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskBasicInfoCell.h"
#import "ZZPostTaskViewModel.h"
#import "ZZPostTaskCellModel.h"

@interface ZZPostTaskBasicInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIImageView *locationAccessoryImageView;

@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIImageView *timeImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *timeAccessoryImageView;

@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIImageView *durationImageView;

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIImageView *durationAccessoryImageView;

@property (nonatomic, strong) UIView *tipsView;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation ZZPostTaskBasicInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    
    if (![_cellModel.data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    BOOL shouldShowTips = YES;
    NSDictionary *info = (NSDictionary *)_cellModel.data;
    if (!isNullString(info[@"location"])) {
        _locationLabel.text = info[@"location"];
        _locationLabel.textColor = UIColor.blackColor;
    }
    else {
        _locationLabel.text = @"您在哪里约见达人？";
        _locationLabel.textColor = RGBCOLOR(153, 153, 153);
        shouldShowTips = NO;
    }
    
    if (!isNullString(info[@"time"])) {
        _timeLabel.text = info[@"time"];
        _timeLabel.textColor = UIColor.blackColor;
    }
    else {
        _timeLabel.text = @"什么时候见面？";
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
        shouldShowTips = NO;
    }
    
    if (!isNullString(info[@"duration"])) {
        _durationLabel.text = info[@"duration"];
        _durationLabel.textColor = UIColor.blackColor;
    }
    else {
        _durationLabel.text = @"邀约进行多久？";
        _durationLabel.textColor = RGBCOLOR(153, 153, 153);
        shouldShowTips = NO;
    }
    
    if (shouldShowTips) {
        NSString *deadLineDes = [[ZZDateHelper shareInstance] deadLineDescriptByDateStr:info[@"startTime"]];
        _tipsLabel.text = [NSString stringWithFormat:@"平台将推荐您的通告至%@", deadLineDes];
        [UIView animateWithDuration:0.3 animations:^{
            [_tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_bgView).offset(41);
            }];
            
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - response method
- (void)action:(UITapGestureRecognizer *)recognizer {
    PostTaskItemType type = (PostTaskItemType)recognizer.view.tag;
    if (type == postLocation) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(basicInfoCellChooseLocation:)]) {
            [self.delegate basicInfoCellChooseLocation:self];
        }
    }
    else if (type == postTime) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(basicInfoCellChooseTime:)]) {
            [self.delegate basicInfoCellChooseTime:self];
        }
    }
    else if (type == postDuration) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(basicInfoCellChooseDuration:)]) {
            [self.delegate basicInfoCellChooseDuration:self];
        }
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self.contentView addSubview:self.tipsView];
    [_tipsView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.bgView];
    
    [_bgView addSubview:self.locationImageView];
    [_bgView addSubview:self.locationLabel];
    [_bgView addSubview:self.locationAccessoryImageView];
    [_bgView addSubview:self.timeImageView];
    [_bgView addSubview:self.timeLabel];
    [_bgView addSubview:self.timeAccessoryImageView];
    [_bgView addSubview:self.durationImageView];
    [_bgView addSubview:self.durationLabel];
    [_bgView addSubview:self.durationAccessoryImageView];
    [_bgView addSubview:self.line1];
    [_bgView addSubview:self.line2];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self);
        make.height.equalTo(@(164));
    }];
    
    [_tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bgView);
        make.height.equalTo(@41);
        make.bottom.equalTo(_bgView);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tipsView).offset(15);
        make.centerY.equalTo(_tipsView);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(37);
        make.right.equalTo(_bgView).offset(-30);
        make.height.equalTo(@54);
    }];
    
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationLabel);
        make.right.equalTo(_locationLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_locationAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationLabel);
        make.left.equalTo(_locationLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_locationLabel);
        make.left.equalTo(_bgView).offset(15);
        make.right.equalTo(_bgView).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_locationLabel.mas_bottom);
        make.left.equalTo(_bgView).offset(37);
        make.right.equalTo(_bgView).offset(-30);
        make.height.equalTo(@54);
    }];
    
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.right.equalTo(_timeLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_timeAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
        make.left.equalTo(_timeLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_timeLabel);
        make.left.equalTo(_bgView).offset(15);
        make.right.equalTo(_bgView).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom);
        make.left.equalTo(_bgView).offset(37);
        make.right.equalTo(_bgView).offset(-30);
        make.height.equalTo(@54);
    }];
    
    [_durationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_durationLabel);
        make.right.equalTo(_durationLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_durationAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_durationLabel);
        make.left.equalTo(_durationLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
}

#pragma mark - getters and setters
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        _tipsView.backgroundColor = UIColor.whiteColor;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBCOLOR(247, 247, 247);
        [_tipsView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipsView);
            make.left.equalTo(_tipsView).offset(15);
            make.right.equalTo(_tipsView).offset(-15);
            make.height.equalTo(@1);
        }];
    }
    return _tipsView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"推荐您的通告至";
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _tipsLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _line2;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageNamed:@"icJutiweizhi"];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.text = @"您在哪里约见达人？";
        _locationLabel.font = [UIFont systemFontOfSize:15];
        _locationLabel.textColor = RGBCOLOR(153, 153, 153);
        _locationLabel.tag = postLocation;
        _locationLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [_locationLabel addGestureRecognizer:tap];
    }
    return _locationLabel;
}

- (UIImageView *)locationAccessoryImageView {
    if (!_locationAccessoryImageView) {
        _locationAccessoryImageView = [[UIImageView alloc] init];
        _locationAccessoryImageView.image = [UIImage imageNamed:@"icon_order_right"];
    }
    return _locationAccessoryImageView;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"icHuodongshijian"];
    }
    return _timeImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"什么时候见面？";
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
        _timeLabel.tag = postTime;
        _timeLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [_timeLabel addGestureRecognizer:tap];
    }
    return _timeLabel;
}

- (UIImageView *)timeAccessoryImageView {
    if (!_timeAccessoryImageView) {
        _timeAccessoryImageView = [[UIImageView alloc] init];
        _timeAccessoryImageView.image = [UIImage imageNamed:@"icon_order_right"];
    }
    return _timeAccessoryImageView;
}

- (UIImageView *)durationImageView {
    if (!_durationImageView) {
        _durationImageView = [[UIImageView alloc] init];
        _durationImageView.image = [UIImage imageNamed:@"icShijianchangdu"];
    }
    return _durationImageView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.text = @"邀约进行多久？";
        _durationLabel.font = [UIFont systemFontOfSize:15];
        _durationLabel.textColor = RGBCOLOR(153, 153, 153);
        _durationLabel.tag = postDuration;
        _durationLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [_durationLabel addGestureRecognizer:tap];
        
    }
    return _durationLabel;
}

- (UIImageView *)durationAccessoryImageView {
    if (!_durationAccessoryImageView) {
        _durationAccessoryImageView = [[UIImageView alloc] init];
        _durationAccessoryImageView.image = [UIImage imageNamed:@"icon_order_right"];
    }
    return _durationAccessoryImageView;
}
@end
