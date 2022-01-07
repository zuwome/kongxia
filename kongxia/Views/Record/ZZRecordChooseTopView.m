//
//  ZZRecordChooseTopView.m
//  zuwome
//
//  Created by angBiu on 2017/2/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordChooseTopView.h"

@interface ZZRecordChooseTopView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *yellowPointView;
@property (nonatomic, strong) UILabel *tempLabel;

@end

@implementation ZZRecordChooseTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgView.image = [UIImage imageNamed:@"icon_record_face_black"];
        self.lineView.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x >= 15+20+10 && point.x < SCREEN_WIDTH - 20) {
        [_yellowPointView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_lineView.mas_left).offset(point.x-15-20-10);
        }];
    }
    
    CGFloat lineWidth = SCREEN_WIDTH - 15 - 20 - 10 - 20;
    CGFloat offset = point.x - 15 - 20 - 10 + (lineWidth/8.0);
    NSInteger index = offset/(lineWidth/3.0);
    [self updateLabel:index];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat lineWidth = SCREEN_WIDTH - 15 - 20 - 10 - 20;
    CGFloat offset = point.x - 15 - 20 - 10 + (lineWidth/8.0);
    NSInteger index = offset/(lineWidth/3.0);
    [UIView animateWithDuration:0.3 animations:^{
        [_yellowPointView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_lineView.mas_left).offset(index*(lineWidth/3.0));
        }];
    } completion:^(BOOL finished) {
        if (_touchIndex) {
            _touchIndex(index);
        }
        [self updateLabel:index];
    }];
}

- (void)updateLabel:(NSInteger)index
{
    _tempLabel.hidden = YES;
    UILabel *label = (UILabel *)[self viewWithTag:100+index];
    label.hidden = NO;
    _tempLabel = label;
}

#pragma mark - lazyload

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 25));
        }];
    }
    return _imgView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXACOLOR(0xffffff, 0.8);
        [self addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.height.mas_equalTo(@2);
        }];
        
        CGFloat width = 8;
        CGFloat space = (SCREEN_WIDTH - 15 - 20 - 10 - 20 + 8 - 8*4)/3.0;
        for (int i=0; i<4; i++) {
            UIView *pointView = [[UIView alloc] init];
            pointView.backgroundColor = HEXACOLOR(0xffffff, 0.8);
            pointView.layer.cornerRadius = 4;
            [self addSubview:pointView];
            
            [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_lineView.mas_left).offset(-3+(space+width)*i);
                make.centerY.mas_equalTo(_lineView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = kYellowColor;
            label.font = [UIFont systemFontOfSize:14];
            label.tag = 100 + i;
            label.hidden = YES;
            [self addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(pointView.mas_centerX);
                make.bottom.mas_equalTo(pointView.mas_top).offset(-3);
            }];
            
            label.text = [NSString stringWithFormat:@"%d",i];
            if (i == 0) {
                _tempLabel = label;
                label.hidden = NO;
            }
        }
        
        self.yellowPointView.hidden = NO;
    }
    return _lineView;
}

- (UIView *)yellowPointView
{
    if (!_yellowPointView) {
        _yellowPointView = [[UIView alloc] init];
        _yellowPointView.backgroundColor = kYellowColor;
        _yellowPointView.layer.cornerRadius = 6;
        [self addSubview:_yellowPointView];
        
        [_yellowPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_lineView.mas_centerY);
            make.centerX.mas_equalTo(_lineView.mas_left);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return _yellowPointView;
}

@end
