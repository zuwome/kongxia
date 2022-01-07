//
//  ZZFilterHeadView.m
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterHeadView.h"

@implementation ZZFilterHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        UIView *topBgView = [[UIView alloc] init];
        topBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topBgView];
        
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(8);
            make.left.mas_equalTo(self.mas_left).offset(8);
            make.right.mas_equalTo(self.mas_right).offset(-8);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(@44);
        }];
        
        UILabel *inputLabel = [[UILabel alloc] init];
        inputLabel.textAlignment = NSTextAlignmentLeft;
        inputLabel.textColor = kGrayTextColor;
        inputLabel.font = [UIFont systemFontOfSize:14];
        inputLabel.text = @"请输入用户名或么么号";
        inputLabel.userInteractionEnabled = YES;
        [topBgView addSubview:inputLabel];
        
        [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(topBgView.mas_left).offset(7);
            make.right.mas_equalTo(topBgView.mas_right).offset(-7);
            make.top.mas_equalTo(topBgView.mas_top);
            make.bottom.mas_equalTo(topBgView.mas_bottom);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputBtnClick)];
        recognizer.numberOfTapsRequired = 1;
        [inputLabel addGestureRecognizer:recognizer];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_filter_search"];
        imgView.userInteractionEnabled = NO;
        [topBgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topBgView.mas_centerY);
            make.right.mas_equalTo(topBgView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"高级筛选";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(topBgView.mas_bottom).offset(10);
        }];
        
        UIView *typeBgView = [[UIView alloc] init];
        typeBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:typeBgView];
        
        [typeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@60);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        _selectView = [[ZZSelectView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _selectView.backgroundColor = [UIColor whiteColor];
        [typeBgView addSubview:_selectView];
        
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(typeBgView.mas_left);
            make.right.mas_equalTo(typeBgView.mas_right);
            make.centerY.mas_equalTo(typeBgView.mas_centerY);
            make.height.mas_equalTo(@50);
        }];
        
        _selectView.options = @[@"  全部  ", @"   男   ", @"   女   "];
    }
    
    return self;
}

#pragma mark - UIButtonMethod

- (void)inputBtnClick
{
    if (_touchInput) {
        _touchInput();
    }
}

@end
