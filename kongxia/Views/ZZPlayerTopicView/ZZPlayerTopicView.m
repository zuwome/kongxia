//
//  ZZPlayerTopicView.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlayerTopicView.h"
@interface ZZPlayerTopicView ()
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;//提问的详细情况
@end
@implementation ZZPlayerTopicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImgView = [UIImageView new];
        [self addSubview:bgImgView];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [bgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self addSubview:self.headImgView];
        [self addSubview:self.contentLabel];
      
    }
    return self;
}

- (void)setMmdModel:(ZZMMDModel *)mmdModel {
    if (_mmdModel != mmdModel) {
        _mmdModel = mmdModel;
        [self.headImgView setUser:mmdModel.from width:37 vWidth:10];
        self.headImgView.isAnonymous = mmdModel.is_anonymous;
        self.contentLabel.text = mmdModel.content;
        [self setGroups:mmdModel.groups];
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-55-SafeAreaBottomHeight);
            make.right.mas_equalTo(self.mas_right).with.offset(-5);
            make.top.mas_equalTo(self.mas_top);
        }];
        
        [_headImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(37, 37));
            make.centerY.mas_equalTo(_contentLabel.mas_centerY);
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

- (ZZHeadImageView *)headImgView {
   
    WS(weakSelf);
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc]init];
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
        _contentLabel.textColor = [UIColor whiteColor];
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        if (!font) {
            font = [UIFont systemFontOfSize:15];
        }
        _contentLabel.font = font;
        _contentLabel.numberOfLines = 0;
        _contentLabel.highlightedTextColor = kYellowColor;
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kYellowColor CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        
        
    }
    return _contentLabel;
}

@end
