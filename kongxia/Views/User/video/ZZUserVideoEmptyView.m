//
//  ZZUserVideoEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserVideoEmptyView.h"

@interface ZZUserVideoEmptyView ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZUserVideoEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_video_empty"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(71, 84));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"快去发布个瞬间吧";
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(10);
        }];
        
        _recordBtn = [[UIButton alloc] init];
        [_recordBtn setTitle:@"发布视频" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.backgroundColor = kYellowColor;
        _recordBtn.layer.cornerRadius = 3;
        [self addSubview:_recordBtn];
        
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(25);
            make.size.mas_equalTo(CGSizeMake(104, 44));
        }];
    }
    
    return self;
}

- (void)setTopOffset:(CGFloat)topOffset
{
    CGFloat scale = SCREEN_WIDTH /375.0;
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffset+120*scale);
    }];
}

- (void)recordBtnClick
{
    if (_touchRecord) {
        _touchRecord();
    }
}

- (void)hideViews
{
    self.backgroundColor = [UIColor whiteColor];
    _imgView.hidden = YES;
    _contentLabel.hidden = YES;
    _recordBtn.hidden = YES;
}

- (void)showViews
{
    self.backgroundColor = kBGColor;
    _imgView.hidden = NO;
    _contentLabel.hidden = NO;
    _recordBtn.hidden = NO;
}

@end
