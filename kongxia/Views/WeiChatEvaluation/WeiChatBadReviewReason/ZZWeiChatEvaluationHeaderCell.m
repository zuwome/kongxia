//
//  ZZWeiChatEvaluationHeaderCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatEvaluationHeaderCell.h"
#import "TYAttributedLabel.h"

@interface ZZWeiChatEvaluationHeaderCell()<TYAttributedLabelDelegate>
@property (nonatomic,strong) TYAttributedLabel *moreInstructionLab;

@end
@implementation ZZWeiChatEvaluationHeaderCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.moreInstructionLab];
        [self addSubview:self.immediateEvaluation];
    }
    return self;
}
- (void)layoutSubviews {
    [self.moreInstructionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.mas_equalTo(self.immediateEvaluation.mas_top).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
    [self.immediateEvaluation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-23-SafeAreaBottomHeight);
        make.height.equalTo(@50);
    }];
}

- (TYAttributedLabel *)moreInstructionLab {
    
    if (!_moreInstructionLab) {
        _moreInstructionLab=[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _moreInstructionLab.textColor= kBlackColor;
        _moreInstructionLab.font= [UIFont systemFontOfSize:12];
        _moreInstructionLab.numberOfLines=0;
        _moreInstructionLab.lineBreakMode = kCTLineBreakByCharWrapping;
        _moreInstructionLab.text=@"微信号无法添加？";
        _moreInstructionLab.delegate = self;
        _moreInstructionLab.numberOfLines = 0;
        _moreInstructionLab.textAlignment = kCTTextAlignmentCenter;
        _moreInstructionLab.linkColor = RGBCOLOR(74, 144, 226);
        [_moreInstructionLab appendLinkWithText:@"快速求助" linkFont:[UIFont systemFontOfSize:12 ]linkData:@"快速求助"];
    }
    return _moreInstructionLab;
}
- (UIButton *)immediateEvaluation {
    if (!_immediateEvaluation) {
        _immediateEvaluation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_immediateEvaluation addTarget:self action:@selector(immediateEvaluationPingJiaClick:) forControlEvents:UIControlEventTouchUpInside];
        [_immediateEvaluation setTitle:@"立即评价" forState:UIControlStateNormal];
        [_immediateEvaluation setTitleColor:kBlackColor forState:UIControlStateNormal];
        _immediateEvaluation.backgroundColor = RGBACOLOR(208, 208, 208, 0.5);
        _immediateEvaluation.layer.cornerRadius = 3;
        _immediateEvaluation.clipsToBounds = YES;
        _immediateEvaluation.enabled = NO;
    }
    return _immediateEvaluation;
}
/**
 立即评价
 */
- (void)immediateEvaluationPingJiaClick:(UIButton *)sender {
//    sender.enabled = NO;
//    
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
//    
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//          sender.enabled = NO;
//    });
    
  
    NSLog(@"PY_立即评价微信号");
    if (_immediateEvaluationWXNumber) {
        _immediateEvaluationWXNumber();
    }
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"快速求助"]) {
            if (_reportWXNumber) {
                _reportWXNumber();
            }
        }
    }
}
@end
