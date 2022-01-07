//
//  ZZSkillEditCellFooter.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditCellFooter.h"

@interface ZZSkillEditCellFooter ()

@property (nonatomic) UIView *stage1;
@property (nonatomic) UIView *stage2;
@property (nonatomic) UIView *stage3;

@end

@implementation ZZSkillEditCellFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)setStage:(NSInteger)stage {
    _stage = stage;
    UIView *stageView = [self viewWithTag:(100 + stage)];
    if (stageView) {
        stageView.backgroundColor = kGoldenRod;
    }
}

- (void)createUI {
    _stage2 = [[UIView alloc] init];
    _stage2.tag = 102;
    _stage2.backgroundColor = kStoneGray;
    _stage2.layer.cornerRadius = 2;
    _stage2.clipsToBounds = YES;
    [self addSubview:_stage2];
    [_stage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 5));
        make.center.equalTo(self);
    }];
    
    _stage1 = [[UIView alloc] init];
    _stage1.tag = 101;
    _stage1.backgroundColor = kStoneGray;
    _stage1.layer.cornerRadius = 2;
    _stage1.clipsToBounds = YES;
    [self addSubview:_stage1];
    [_stage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 5));
        make.centerY.equalTo(self);
        make.centerX.equalTo(_stage2.mas_centerX).offset(-45);
    }];
    
    _stage3 = [[UIView alloc] init];
    _stage3.tag = 103;
    _stage3.backgroundColor = kStoneGray;
    _stage3.layer.cornerRadius = 2;
    _stage3.clipsToBounds = YES;
    [self addSubview:_stage3];
    [_stage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 5));
        make.centerY.equalTo(self);
        make.centerX.equalTo(_stage2.mas_centerX).offset(45);
    }];
}

@end
