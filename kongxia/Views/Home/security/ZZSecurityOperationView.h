//
//  ZZSecurityOperationView.h
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSecurityAudioWaveView.h"

@interface ZZSecurityOperationView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *recordBgView;
@property (nonatomic, strong) UIImageView *recordImgView;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *recordDetailLabel;
@property (nonatomic, strong) ZZSecurityAudioWaveView *waveView;

@property (nonatomic, strong) UIView *contactBgView;
@property (nonatomic, strong) UIImageView *contactImgView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *contactDetailLabel;

@property (nonatomic, strong) UIView *locationBgView;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) CGFloat audioLevel;//音频等级 0~1
@property (nonatomic, assign) BOOL notified;

@property (nonatomic, copy) dispatch_block_t touchContactSetting;
@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)managerContactStatus;

@end
