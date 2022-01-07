//
//  ZZMemedaAskEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMemedaAskEmptyView.h"

@interface ZZMemedaAskEmptyView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ZZMemedaAskEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_wx_read_empty"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(184.5, 153.5));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"你还没有提问过别人哦 快去提问吧";
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(38);
        }];
    }
    
    return self;
}

- (void)setTopOffset:(CGFloat)topOffset
{
    CGFloat scale = SCREEN_WIDTH /375.0;
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffset+57*scale);
    }];
}

- (void)hideViews
{
    self.backgroundColor = [UIColor whiteColor];
    _imgView.hidden = YES;
    _contentLabel.hidden = YES;
}

- (void)showViews
{
    self.backgroundColor = kBGColor;
    _imgView.hidden = NO;
    _contentLabel.hidden = NO;
}

@end
