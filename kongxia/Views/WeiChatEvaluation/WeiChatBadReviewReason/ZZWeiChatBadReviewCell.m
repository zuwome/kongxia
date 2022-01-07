//
//  ZZWeiChatBadReviewCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBadReviewCell.h"
@interface ZZWeiChatBadReviewCell()

@property (nonatomic,strong)UILabel *badTitleLab;
@end

@implementation ZZWeiChatBadReviewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.badTitleLab];
    }
    return self;
}
-(UILabel *)badTitleLab {
    if (!_badTitleLab) {
        _badTitleLab = [[UILabel alloc]init];
        _badTitleLab.textColor = kBlackColor;
        _badTitleLab.font = [UIFont systemFontOfSize:13];
        _badTitleLab.textAlignment = NSTextAlignmentCenter;
        _badTitleLab.layer.cornerRadius = 3;
        _badTitleLab.clipsToBounds = YES;
        _badTitleLab.backgroundColor = [UIColor whiteColor];
        _badTitleLab.layer.borderWidth = 0.5;
        _badTitleLab.layer.borderColor = [HEXCOLOR(0xd8d8d8)  CGColor];
    }
    return _badTitleLab;
}
- (void)setModel:(ZZWeiChatBadEvaluationReasonModel *)model {
    _model = model;
   [self setIsSelectEvaluation:model.isSelect] ;
    self.badTitleLab.text = model.reason;
}
- (void)layoutSubviews {
    [self.badTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setIsSelectEvaluation:(BOOL)isSelectEvaluation {
    _isSelectEvaluation = isSelectEvaluation;
    _model.isSelect = isSelectEvaluation;
    if (isSelectEvaluation) {
        self.badTitleLab.backgroundColor = RGBCOLOR(240, 203, 7);
        _badTitleLab.layer.borderWidth = 0;
    }else{
        self.badTitleLab.backgroundColor = [UIColor whiteColor];
        _badTitleLab.layer.borderWidth = 0.5;
        _badTitleLab.layer.borderColor = [HEXCOLOR(0xd8d8d8)  CGColor];
    }
}

@end
