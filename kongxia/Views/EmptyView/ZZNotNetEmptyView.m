//
//  ZZNotNetEmptyView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//
#import "ZZNetWorkCheckViewController.h"
#import "ZZNotNetEmptyView.h"
@interface ZZNotNetEmptyView()
@property(nonatomic,strong) UIImageView *emptyImageView;

@property(nonatomic,strong) UILabel *emptyLab;
/**
 当前的占位图片名
 */
@property(nonatomic,strong) NSString *emptyImageName;

/**
 当前的占位图的文字
 */
@property(nonatomic,strong) NSString *emptyTitle;
@property (nonatomic,strong) UIViewController *viewController;

/**
 占位按钮
 */
@property(nonatomic,strong) UIButton  *emptyButtion;
@end
@implementation ZZNotNetEmptyView

+ (ZZNotNetEmptyView *)showNotNetWorKEmptyViewWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame viewController:(UIViewController *)viewController{
    ZZNotNetEmptyView *emptyView = [[ZZNotNetEmptyView alloc]initWithFrame:frame];
    if (title) {
        emptyView.emptyTitle = title;
    }
    if (imageName) {
        emptyView.emptyImageName = imageName;
    }
    emptyView.viewController = viewController;
    [viewController.view addSubview:emptyView];
    return emptyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBGColor;
        [self setUpUI];
        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.emptyButtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(104, 44));
        make.top.equalTo(self.emptyLab.mas_bottom).offset(12);
    }];
    [self.emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.emptyLab.mas_top).offset(-12);
    }];
    
}

- (void)setUpUI {
    
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyLab];
    [self addSubview:self.emptyButtion];
}


- (UILabel *)emptyLab {
    if (!_emptyLab) {
        _emptyLab = [[UILabel alloc]init];
        _emptyLab.textColor = RGBCOLOR(165, 165, 165);
        _emptyLab.textAlignment = NSTextAlignmentCenter;
        _emptyLab.text = @"无网络可用\n检查空虾网络连接权限及当前网络状态";
        _emptyLab.numberOfLines = 0;
        _emptyLab.font = CustomFont(15);
        [UILabel changeLineSpaceForLabel:_emptyLab WithSpace:5];
    }
    return _emptyLab;
}
- (UIButton *)emptyButtion {
    if (!_emptyButtion) {
        _emptyButtion = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyButtion addTarget:self action:@selector(checkNetWorkClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emptyButtion setTitle:@"查看详情" forState:UIControlStateNormal];
        [_emptyButtion setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_emptyButtion setBackgroundColor:RGBCOLOR(244, 203, 7)];
        _emptyButtion.layer.cornerRadius = 4;
    }
    return _emptyButtion;
}
- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]init];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyImageView.image = [UIImage imageNamed:@"imNetworkfailure.png"];
    }
    return _emptyImageView;
}


- (void)setEmptyTitle:(NSString *)emptyTitle {
    _emptyTitle = emptyTitle;
    _emptyLab.text = emptyTitle;
}

- (void)setEmptyImageName:(NSString *)emptyImageName {
    _emptyImageName = emptyImageName;
    _emptyImageView.image = [UIImage imageNamed:emptyImageName];
}

- (void)checkNetWorkClick:(UIButton *)sender {
    ZZNetWorkCheckViewController *checkViewController = [[ZZNetWorkCheckViewController alloc]init];
    checkViewController.hidesBottomBarWhenPushed = YES;
    
    [self.viewController.navigationController pushViewController:checkViewController animated:YES];
}
@end
