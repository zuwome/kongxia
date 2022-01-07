//
//  ZZMemedaAnswerEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMemedaAnswerEmptyView.h"

@interface ZZMemedaAnswerEmptyView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ZZMemedaAnswerEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_video_answer_empty"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(126, 79.5));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"你一定是太低调了 才会错过那么多提问";
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(40);
        }];
    }
    
    return self;
}

- (void)setTopOffset:(CGFloat)topOffset
{
    CGFloat scale = SCREEN_WIDTH /375.0;
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffset+100*scale);
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
