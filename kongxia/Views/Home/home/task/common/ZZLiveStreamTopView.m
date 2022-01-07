//
//  ZZLiveStreamTopView.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamTopView.h"
#import "ZZBadgeView.h"

@interface ZZLiveStreamTopView ()

@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UILabel *publishLabel;
@property (nonatomic, strong) UIButton *snatchBtn;
@property (nonatomic, strong) UILabel *snatchLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZZBadgeView *countView;

@end

@implementation ZZLiveStreamTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
        
        [self addSubview:self.publishBtn];
        [self addSubview:self.snatchBtn];
//        self.lineView.center = CGPointMake(self.publishBtn.center.x, self.height - self.lineView.height/2);
//        self.lineView.center = CGPointMake(self.snatchBtn.center.x, self.height - self.lineView.height/2);
        [self snatchBtnClick];
    }
    
    return self;
}

- (void)publishBtnClick
{
    _publishLabel.textColor = kYellowColor;
    _snatchLabel.textColor = kBlackTextColor;
    self.lineView.center = CGPointMake(self.publishBtn.center.x, self.height - self.lineView.height/2);
    if (_selectedIndex) {
        _selectedIndex(0);
    }
}

- (void)snatchBtnClick
{
    _publishLabel.textColor = kBlackTextColor;
    _snatchLabel.textColor = kYellowColor;
    self.lineView.center = CGPointMake(self.snatchBtn.center.x, self.height - self.lineView.height/2);
    if (_selectedIndex) {
        _selectedIndex(1);
    }
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    _countView.count = count;
}

#pragma mark -

- (UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, self.height)];
        [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _publishLabel = [[UILabel alloc] init];
        _publishLabel.textColor = kYellowColor;
        _publishLabel.font = [UIFont systemFontOfSize:16];
        _publishLabel.text = @"发任务";
        _publishLabel.userInteractionEnabled = NO;
        [_publishBtn addSubview:_publishLabel];
        
        [_publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_publishBtn.mas_centerX);
            make.bottom.mas_equalTo(_publishBtn.mas_bottom).offset(-10.5);
        }];
    }
    return _publishBtn;
}

- (UIButton *)snatchBtn
{
    if (!_snatchBtn) {
        _snatchBtn = [[UIButton alloc] initWithFrame:CGRectMake(_publishBtn.width, 0, 80, self.height)];
        [_snatchBtn addTarget:self action:@selector(snatchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _snatchLabel = [[UILabel alloc] init];
        _snatchLabel.textColor = kBlackTextColor;
        _snatchLabel.font = [UIFont systemFontOfSize:16];
        _snatchLabel.text = @"抢任务";
        _snatchLabel.userInteractionEnabled = NO;
        [_snatchBtn addSubview:_snatchLabel];
        
        [_snatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_snatchBtn.mas_centerX);
            make.bottom.mas_equalTo(_snatchBtn.mas_bottom).offset(-10.5);
        }];
        
        _countView = [[ZZBadgeView alloc] init];
        _countView.cornerRadius = 7;
        _countView.offset = 5;
        _countView.fontSize = 12;
        _countView.count = 0;
        [_snatchBtn addSubview:_countView];
        
        [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_snatchLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(_snatchLabel.mas_centerY);
            make.height.mas_equalTo(@14);
        }];
    }
    return _snatchBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 2.5)];
        _lineView.backgroundColor = kYellowColor;
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
