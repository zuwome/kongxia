//
//  LSPaoMaView.m
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSPaoMaView.h"

@implementation LSPaoMaView
{
    
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//标记第二个位置
    
    NSMutableArray* labelArr;
    
    NSTimeInterval timeInterval;//时间
    
    BOOL isStop;//停止
    BOOL _isCanPaoMa;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title font:(CGFloat )fontsize {
    self = [super initWithFrame:frame];
    if (self) {
    CGRect currentSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontsize ]} context:nil];
        //判断是否需要reserveTextLb
        
       _isCanPaoMa = currentSize.size.width > frame.size.width ? YES : NO;
        if (_isCanPaoMa) {
            title = [NSString stringWithFormat:@"          %@            ",title];//间隔
        }
        timeInterval = [self displayDurationForString:title];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        //
        UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
        textLb.textColor = TEXTCOLOR;
        //        textLb.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
        textLb.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
        textLb.text = title;
        
        //计算textLb大小
        CGSize sizeOfText = [textLb sizeThatFits:CGSizeZero];
        
        rectMark1 = CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height);
        
        textLb.frame = rectMark1;
        [self addSubview:textLb];
        
        labelArr = [NSMutableArray arrayWithObject:textLb];
        
        
        if (_isCanPaoMa) {
            //alloc reserveTextLb ...
            UILabel* reserveTextLb = [[UILabel alloc] initWithFrame:rectMark2];
            reserveTextLb.textColor = TEXTCOLOR;
            //            reserveTextLb.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
            reserveTextLb.font = [UIFont systemFontOfSize:TEXTFONTSIZE];
            reserveTextLb.text = title;
            [self addSubview:reserveTextLb];
            
            [labelArr addObject:reserveTextLb];
            
            [self paomaAnimate];
        }
        
    }
    
    return self;
}





- (void)paomaAnimate{
  
    if (!isStop) {
        //
        UILabel* lbindex0 = labelArr[0];
        UILabel* lbindex1 = labelArr[1];
        
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            //
            
            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
            
        } completion:^(BOOL finished) {
            //
            
            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            
            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
            
            [self paomaAnimate];
        }];
    }
}


- (void)start{
    if (!_isCanPaoMa) {
        return;
    }
    isStop = NO;
    UILabel* lbindex0 = labelArr[0];
    UILabel* lbindex1 = labelArr[1];
    lbindex0.frame = rectMark2;
    lbindex1.frame = rectMark1;
    
    [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
    [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
    
    [self paomaAnimate];
    
}
- (void)stop{
    if (!_isCanPaoMa) {
        return;
    }
    isStop = YES;
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    
    return string.length/5;
}

- (void)dealloc {
    
 NSLog(@"PY_跑马的气泡的_%s",__func__);
}
@end
