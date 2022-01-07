//
//  ZZPlayerBottomContentView.m
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPlayerBottomContentView.h"

@implementation ZZPlayerBottomContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.backgroundColor = [UIColor clearColor];
        self.bgView.hidden = NO;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.alpha = 0.2;
        lineView.userInteractionEnabled = NO;
        [_bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-55-SafeAreaBottomHeight);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}


- (void)setSkModel:(ZZSKModel *)skModel
{
    self.headImgView.hidden = YES;
    self.contentLabel.text = skModel.content;
    [self setGroups:skModel.groups];
  
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_left).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-65-SafeAreaBottomHeight);
    }];
}

- (void)setMmdModel:(ZZMMDModel *)mmdModel
{
    self.headImgView.hidden = NO;
    [self.headImgView setUser:mmdModel.from width:37 vWidth:10];
    self.headImgView.isAnonymous = mmdModel.is_anonymous;
    self.contentLabel.text = mmdModel.content;
    [self setGroups:mmdModel.groups];
    CGFloat height = [ZZUtils heightForCellWithText:_contentLabel.text fontSize:14 labelWidth:(SCREEN_WIDTH - 30 - 37 - 5)];
    if (height<37) {
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15 + 37 + 5);
            make.width.mas_equalTo(SCREEN_WIDTH - 30 - 37 - 5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-55-(37-height+10)-SafeAreaBottomHeight);
        }];
    } else {
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15 + 37 + 5);
            make.width.mas_equalTo(SCREEN_WIDTH - 30 - 37 - 5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-65- SafeAreaBottomHeight );
        }];
    }
}

- (void)setGroups:(NSMutableArray<ZZMemedaTopicModel> *)groups
{
    __block NSString *str = self.contentLabel.text;
    if (isNullString(str)) {
        str = @"";
    }
    [groups enumerateObjectsUsingBlock:^(ZZMemedaTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [NSString stringWithFormat:@"%@ %@",str,model.content];
    }];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _contentLabel.text = str;
    [groups enumerateObjectsUsingBlock:^(ZZMemedaTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [str rangeOfString:model.content];
        [_contentLabel addLinkToTransitInformation:@{[NSNumber numberWithInteger:idx]:model.content} withRange:range];
    }];
}

#pragma mark -

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _bgView;
}

- (ZZHeadImageView *)headImgView
{
    WeakSelf;
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [_bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(37, 37));
        }];
        
        _headImgView.touchHead = ^{
            if (weakSelf.touchHead) {
                weakSelf.touchHead();
            }
        };
    }
    return _headImgView;
}

- (TTTAttributedLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = HEXACOLOR(0xffffff, 0.9);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.highlightedTextColor = kYellowColor;
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-65 );
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
        }];
    }
    return _contentLabel;
}

@end
