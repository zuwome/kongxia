//
//  ZZLiveStreamConnectBottomView.m
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamConnectBottomView.h"

#import "ZZTraingleView.h"

@interface ZZLiveStreamConnectBottomView ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *enableVideoBtn;

@end

@implementation ZZLiveStreamConnectBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setAcceped:(BOOL)acceped {
    _acceped = acceped;
    if (acceped) {
        _width = 70;
        _offset = (SCREEN_WIDTH - _width * 3) / 2;
    } else {
        _width = 70;
        _offset = (SCREEN_WIDTH - _width * 4) / 3;
    }
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.cameraBtn];
    [self addSubview:self.filterBtn];
    
    if (acceped) {
        // 抢单人

        CGFloat offset = 0.0;
        NSInteger numberOfItems = 3;
        offset = (SCREEN_WIDTH - _width * numberOfItems) / (numberOfItems + 1);
    
        _filterBtn.left = offset;
        _cameraBtn.left = offset * 2 + _width;
        _cancelBtn.left = offset * 3 + _width * 2;
    
    }
    else {
        // 发单人
        [self addSubview:self.rechargeBtn];
        [self addSubview:self.itemView];
        
        self.alertLabel.text = @"余额不足 即将挂断 请立即充值";
        
        CGFloat offset = 0.0;
        NSInteger numberOfItems = 4;
        offset = (SCREEN_WIDTH - _width * numberOfItems) / (numberOfItems + 1);
        
        _filterBtn.left = offset;
        _cameraBtn.left = offset * 2 + _width;
        _rechargeBtn.left = offset * 3 + _width * 2;
        _cancelBtn.left = offset * 4 + _width * 3;
    }
}

- (void)setIsEnableVideo:(BOOL)isEnableVideo {
    _isEnableVideo = isEnableVideo;
}

- (UIButton *)createBtn:(NSString *)imgName title:(NSString *)title imgWidth:(CGFloat)width
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, _width, 70)];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:imgName];
    imgView.userInteractionEnabled = NO;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [btn addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn.mas_centerX);
        make.top.mas_equalTo(btn.mas_top).offset(10+(25-width)/2);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    titleLabel.text = title;
    titleLabel.userInteractionEnabled = NO;
    [btn addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(8);
        make.centerX.mas_equalTo(btn.mas_centerX);
    }];
    
    return btn;
}

- (void)rechargeBtnClick
{
    if (_touchRecharge) {
        _touchRecharge();
    }
}

- (void)cancelBtnClick
{
    if (_touchCancel) {
        _touchCancel();
    }
}

- (void)cameraBtnClick {
    if (!_acceped) {
        self.itemView.hidden = YES;
    }
    BLOCK_SAFE_CALLS(self.touchCameraBlock);
}

- (void)showFilterAction {
    if (_showFilter) {
        _showFilter();
    }
}

// 开启或关闭摄像头
- (void)enableOrDisableVideoClick:(UIButton *)sender {
    if (!_acceped) {
        self.itemView.hidden = YES;
    }
    
    if (self.isEnableVideo) {//关闭操作
        [MobClick event:Event_click_Video_Close_Lens];
        [self.enableVideoBtn setTitle:@"开启镜头" forState:(UIControlStateNormal)];
        [self.enableVideoBtn setImage:[UIImage imageNamed:@"icConnectingOpen"] forState:UIControlStateNormal];

        self.isEnableVideo = NO;
        BLOCK_SAFE_CALLS(self.touchDisableVideo);
    } else {//开启操作
        [self.enableVideoBtn setTitle:@"关闭镜头" forState:(UIControlStateNormal)];
        [self.enableVideoBtn setImage:[UIImage imageNamed:@"icConnectingClose"] forState:UIControlStateNormal];

        self.isEnableVideo = YES;
        BLOCK_SAFE_CALLS(self.touchEnableVideo);
    }
}



- (void)showItemView {
    
    if (self.itemView.isHidden) {
        self.itemView.hidden = NO;
    } else {
        self.itemView.hidden = YES;
    }
}

- (void)hideAllView {
    self.itemView.hidden = YES;
}

#pragma mark - lazyload

////////////////////////////////
- (UIButton *)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [self createBtn:@"group6" title:@"美颜" imgWidth:40];
        _filterBtn.left = 0;
        [_filterBtn addTarget:self action:@selector(showFilterAction) forControlEvents:UIControlEventTouchUpInside];
        _filterBtn.top = 114;
    }
    return _filterBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [self createBtn:@"icon_livestream_close" title:@"挂断" imgWidth:40];
        _cancelBtn.left = 0;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.top = 114;
    }
    return _cancelBtn;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [self createBtn:@"icon_livestream_recharge" title:@"充值" imgWidth:40];
        _rechargeBtn.left = _width+_offset;
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rechargeBtn.top = 114;
    }
    return _rechargeBtn;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        //icon_livestream_camera
        if (_acceped) {
            _cameraBtn = [self createBtn:@"icon_livestream_camera" title:@"翻转" imgWidth:40];
            _cameraBtn.left = (_width+_offset) * 4;
            [_cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
        } else {
            _cameraBtn = [self createBtn:@"icon_livestream_camera2" title:@"镜头" imgWidth:40];
            _cameraBtn.left = (_width+_offset) * 4;
            [_cameraBtn addTarget:self action:@selector(showItemView) forControlEvents:UIControlEventTouchUpInside];
        }
        _cameraBtn.top = 114;
    }
    return _cameraBtn;
}


- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertBgView = [[UIView alloc] init];
        _alertBgView.hidden = YES;
        [self addSubview:_alertBgView];
        
        [_alertBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_rechargeBtn.mas_centerX);
            make.bottom.mas_equalTo(_rechargeBtn.mas_top);
            make.height.mas_equalTo(@39);
        }];
        
        ZZTraingleView *traingle = [[ZZTraingleView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
        traingle.backgroundColor = [UIColor clearColor];
        [_alertBgView addSubview:traingle];
        
        [traingle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.mas_equalTo(_alertBgView);
            make.size.mas_equalTo(CGSizeMake(15, 5));
        }];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = kYellowColor;
        topView.layer.cornerRadius = 4;
        [_alertBgView addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_alertBgView);
            make.bottom.mas_equalTo(traingle.mas_top);
        }];
        
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.textColor = kBlackTextColor;
        _alertLabel.font = [UIFont systemFontOfSize:14];
        [topView addSubview:_alertLabel];
        
        [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.left.mas_equalTo(topView.mas_left).offset(12);
            make.right.mas_equalTo(topView.mas_right).offset(-12);
        }];
    }
    return _alertLabel;
}

- (UIView *)itemView {
    if (!_itemView) {
        
        _itemView = [UIView new];
        _itemView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _itemView.hidden = YES;
        _itemView.layer.masksToBounds = YES;
        _itemView.layer.cornerRadius = 6.0f;
        [self addSubview:_itemView];
        
        [_itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_cameraBtn.mas_centerX);
            make.bottom.mas_equalTo(_cameraBtn.mas_top).offset(-5);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(110);
        }];
        
        // icConnectingClose icConnectingTurn
        self.enableVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enableVideoBtn setTitle:_isEnableVideo ? @"关闭镜头" : @"开启镜头" forState:(UIControlStateNormal)];
        [_enableVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enableVideoBtn setImage:[UIImage imageNamed:_isEnableVideo ? @"icConnectingClose" : @"icConnectingOpen"] forState:UIControlStateNormal];
        [_enableVideoBtn addTarget:self action:@selector(enableOrDisableVideoClick:) forControlEvents:UIControlEventTouchUpInside];
        _enableVideoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _enableVideoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        UIButton *switchVidewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchVidewBtn setTitle:@"翻转镜头" forState:(UIControlStateNormal)];
        [switchVidewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [switchVidewBtn setImage:[UIImage imageNamed:@"icConnectingTurn"] forState:UIControlStateNormal];
        [switchVidewBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
        switchVidewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        switchVidewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        [_itemView addSubview:_enableVideoBtn];
        [_itemView addSubview:switchVidewBtn];
        
        [_enableVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(@0);
            make.height.equalTo(@55);
        }];
        
        [switchVidewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(@0);
            make.height.equalTo(@55);
        }];
    }
    return _itemView;
}

@end
