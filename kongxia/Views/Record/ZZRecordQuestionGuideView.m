//
//  ZZRecordQuestionGuideView.m
//  zuwome
//
//  Created by angBiu on 2017/6/28.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordQuestionGuideView.h"

@implementation ZZRecordQuestionGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgView.image = [UIImage imageNamed:@"icon_record_question_guide"];
        [self addSubview:imgView];
    }
    
    return self;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
