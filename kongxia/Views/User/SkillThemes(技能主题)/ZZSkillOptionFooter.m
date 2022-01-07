//
//  ZZSkillOptionFooter.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillOptionFooter.h"

@interface ZZSkillOptionFooter ()

@property (nonatomic) UIButton *saveBtn;
@property (nonatomic) UIButton *deleteBtn;

@end

@implementation ZZSkillOptionFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [_saveBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
    [_saveBtn setBackgroundColor:kGoldenRod];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.leading.trailing.equalTo(@0);
    }];
    
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setTitle:@"删除技能" forState:(UIControlStateNormal)];
    [_deleteBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
    [_deleteBtn setBackgroundColor:HEXCOLOR(0xF06833)];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom).offset(15);
        make.height.equalTo(@50);
        make.bottom.leading.trailing.equalTo(@0);
    }];
}

- (void)saveClick {
    !self.saveBtnClick ? : self.saveBtnClick();
}

- (void)deleteClick {
    !self.deleteBtnClick ? : self.deleteBtnClick();
}

@end
