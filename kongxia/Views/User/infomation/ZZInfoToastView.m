//
//  ZZInfoToastView.m
//  zuwome
//
//  Created by qiming xiao on 2019/2/14.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZInfoToastView.h"
#import "ZZDateHelper.h"
#import "ZZTasks.h"

@interface ZZInfoToastView ()

@property (nonatomic, copy) void(^actionBlock)(NSInteger actionIndex, ToastType type);

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZZToast1View *toastView;

@property (nonatomic, copy) NSString *keyStr;

@property (nonatomic, strong) ZZTask *task;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@end

@implementation ZZInfoToastView

+ (instancetype)showOnceWithType:(ToastType)type action:(nonnull void (^)(NSInteger, ToastType))action {
    ZZInfoToastView *infoToastView = [self showWithType:type action:action];
    return infoToastView;
}

+ (instancetype)showWithType:(ToastType)type {
    ZZInfoToastView *infoToastView = [[ZZInfoToastView alloc] init];
    infoToastView.toastType = type;
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

+ (instancetype)showWithType:(ToastType)type action:(nonnull void (^)(NSInteger, ToastType))action {
    ZZInfoToastView *infoToastView = [ZZInfoToastView showWithType:type];
    infoToastView.actionBlock = action;
    return infoToastView;
}

+ (instancetype)showWithType:(ToastType)type keyStr:(NSString *)keyStr action:(void (^)(NSInteger, ToastType))action {
    ZZInfoToastView *infoToastView = [[ZZInfoToastView alloc] initWithkeyStr:keyStr];
    infoToastView.toastType = type;
    infoToastView.actionBlock = action;
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

+ (instancetype)showWithType:(ToastType)type title:(NSString *)title subTitle:(NSString *)subtitle action:(void (^)(NSInteger, ToastType))action {
    ZZInfoToastView *infoToastView = [[ZZInfoToastView alloc] initWithTitle:title subTitle:subtitle];
    infoToastView.toastType = type;
    infoToastView.actionBlock = action;
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

+ (instancetype)showWithType:(ToastType)type task:(ZZTask *)task action:(void(^)(NSInteger actionIndex, ToastType type))action {
    ZZInfoToastView *infoToastView = [[ZZInfoToastView alloc] initWithTask:task];
    infoToastView.toastType = type;
    infoToastView.actionBlock = action;
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithkeyStr:(NSString *)keyStr {
    self = [super init];
    if (self) {
        _keyStr = keyStr;
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithTask:(ZZTask *)task {
    self = [super init];
    if (self) {
        _task = task;
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _title = title;
        _subTitle = subtitle;
        [self layoutUI];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _toastView.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _toastView.alpha = 0;
    } completion:^(BOOL finished) {
        _actionBlock = nil;
        [_bgView removeFromSuperview];
        [_toastView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)closeAction {
    if (_delegate && [_delegate respondsToSelector:@selector(toastView:leftActionWithType:)]) {
        [_delegate toastView:self leftActionWithType:_toastType];
    }
//    if (_actionBlock) {
//        _actionBlock(-1, _toastType);
//    }
    [self hide];
}

- (void)leftAction {
    
    if (_delegate && [_delegate respondsToSelector:@selector(toastView:leftActionWithType:)]) {
        [_delegate toastView:self leftActionWithType:_toastType];
    }
    if (_actionBlock) {
        _actionBlock(0, _toastType);
    }
    [self hide];
}

- (void)rightAction {
    if (_toastType == ToastRealAvatarNotMatch || _toastType == ToastRealAvatarFail || _toastType == ToastRealAvatarFailInPerfect) {
        [SVProgressHUD showInfoWithStatus:@"提交成功，我们将在1个工作日内审核"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(toastView:rightActionWithType:)]) {
        [_delegate toastView:self rightActionWithType:_toastType];
    }
    if (_actionBlock) {
        _actionBlock(1, _toastType);
    }
    [self hide];
}

#pragma mark - UI
- (void)layoutUI {
    [self addSubview:self.bgView];
    [self addSubview:self.toastView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@312);
    }];
}

#pragma mark - Setter&Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
    }
    return _bgView;
}

- (ZZToast1View *)toastView {
    if (!_toastView) {
        _toastView = [[ZZToast1View alloc] init];
        _toastView.task = _task;
        _toastView.alpha = 0.0;
        _toastView.keyStr = _keyStr;
        _toastView.title = _title;
        _toastView.subTitle = _subTitle;
        [_toastView.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_toastView.leftActionButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [_toastView.rightActionButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toastView;
}

- (void)setToastType:(ToastType)toastType {
    _toastType = toastType;
    [_toastView configToastInfoWithType:_toastType];
}

@end


@interface ZZToast1View ()

@end

@implementation ZZToast1View

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configToastInfoWithType:(ToastType)type {
    _toastType = type;
    
    NSString *title = nil, *subTitle = nil, *icon = nil, *leftActionTitle = nil, *rightActionTitle = nil, *descript = nil;
    if (_toastType == ToastRealAvatarNotMatch) {
        title = @"头像匹配失败";
        subTitle = @"您选择的头像系统识别为非本人正脸五官清晰照，会导致部分功能无法使用哦";
        descript = @"如头像符合要求，可申请人工审核";
        icon = @"picTxppsbTc";
        leftActionTitle = @"坚持使用";
        rightActionTitle = @"人工审核";
        _closeButton.hidden = NO;
    }
    else if (_toastType == ToastRealAvatarFail) {
        title = @"头像自动匹配失败";
        subTitle = @"您已成功申请达人\n头像位置必须是本人正脸五官清晰照片";
        descript = @"如头像符合要求，可申请人工审核";
        icon = @"picTxghsbTc";
        leftActionTitle = @"重新上传";
        rightActionTitle = @"人工审核";
    }
    else if (_toastType == ToastRealAvatarFailInPerfect) {
        title = @"头像匹配失败";
        subTitle = @"平台的达人使用的都是真实头像，成为达人需您上传本人正脸五官清晰照。";
        descript = @"如头像符合要求，可以申请人工审核";
        icon = @"picTxghsbTc";
        leftActionTitle = @"重新上传";
        rightActionTitle = @"人工审核";
    }
    else if (_toastType == ToastRealAvatarReviewFail) {
        title = @"提示";
        subTitle = @"抱歉！头像审核失败，您需要使用本人五官清晰照片作为头像的，才能获取达人资格，请您重新上传";
        icon = @"picTsTxshsb";
        leftActionTitle = @"取消";
        rightActionTitle = @"前往";
    }
    else if (_toastType == ToastTaskConfirmChoose) {
        title = @"确认选择";
        _keyStr = (!isNullString(_keyStr) ? _keyStr : @"该用户");
        NSString *sub = [NSString stringWithFormat:@"您选择了%@来进行本次通告，已发布的通告将自动结束，不可再选人。建议先与对方沟通具体详情后再做选择", _keyStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sub attributes:@{
                                                                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14.0f],
                                                                                                                                                                       NSForegroundColorAttributeName: RGBCOLOR(102, 102, 102),
                                                                                                                                                                       NSKernAttributeName: @(0.0)
                                                                                                                                                                       }];
        
        NSRange keyRange = [sub rangeOfString:_keyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:keyRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:keyRange];
        icon = @"picXzTc";
        leftActionTitle = @"私信TA";
        rightActionTitle = @"确定选择";
        _subTitleLabel.attributedText = attributedString;
        
        _closeButton.hidden = NO;
    }
    else if (_toastType == ToastTaskConfirmSignUp) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(83.5);
            make.top.equalTo(self).offset(15.0);
            make.size.mas_equalTo(CGSizeMake(50, 42));
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconImageView);
            make.left.equalTo(_iconImageView.mas_right).offset(10.0);
        }];
        
        [_descriptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20.0);
            make.right.equalTo(self).offset(-20.0);
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(5.0);
        }];
        
        _closeButton.hidden = NO;
        
        title = @"确定报名？";
        NSString *contents = [NSString stringWithFormat:@"主题：%@\n收益：%ld小时 共%@元\n时间：%@\n地点：%@\n", _task.skillModel.name, (long)_task.hours, _task.price, [[ZZDateHelper shareInstance] showDateStringWithDateString:_task.dated_at], _task.address];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contents attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14.0f],NSForegroundColorAttributeName: RGBCOLOR(153, 153, 153),NSKernAttributeName: @(0.0)}];
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:[contents rangeOfString:@"主题："]];
        
        [attributedString addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:[contents rangeOfString:@"收益："]];
        
        [attributedString addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:[contents rangeOfString:@"时间："]];
        
        [attributedString addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:[contents rangeOfString:@"地点："]];
        
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.attributedText = attributedString;
        
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"*请确保该场所为公众场合\n*报名后爽约或要求加价等严重违规者将会被处罚或封禁 ，建议先与对方私信具体内容后再确定报名" attributes:@{
                                                                                                                                                                                    NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 13.0f],
                                                                                                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithWhite:153.0f / 255.0f alpha:1.0f],
                                                                                                                                                                                    NSKernAttributeName: @(0.0)
                                                                                                                                                                                    }];
        [attributedString1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:NSMakeRange(0, 1)];
        [attributedString1 addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:NSMakeRange(8, 4)];
        [attributedString1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:NSMakeRange(13, 1)];
        [attributedString1 addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:NSMakeRange(25, 5)];
        [attributedString1 addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:NSMakeRange(33, 5)];
        [attributedString1 addAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13.0f],
                                          NSForegroundColorAttributeName: [UIColor colorWithRed:63.0f / 255.0f green:58.0f / 255.0f blue:58.0f / 255.0f alpha:1.0f]
                                          } range:NSMakeRange(46, 2)];
        _descriptLabel.textAlignment = NSTextAlignmentLeft;
        _descriptLabel.attributedText = attributedString1;

        icon = @"picWxtsTc";
        leftActionTitle = @"私信TA";
        rightActionTitle = @"确定报名";
        _leftActionButton.backgroundColor = RGBCOLOR(244, 143, 7);
    }
    else if (_toastType == ToastTaskCancelPost) {
        title = @"确认放弃发布吗？";
        subTitle = @"1.一键发布后，将有多位达人报名供您挑选\n\n2. 发布成功30分钟后无人报名时取消发布或自动过期后，发布服务费可全额退回";
        icon = @"picWxtsTc";
        leftActionTitle = @"放弃";
        rightActionTitle = @"我再想想";
    }
    else if (_toastType == ToastTaskCancel) {
        title = @"确认取消吗？";
        subTitle = @"取消后，该通告报名将结束，租金将按规则部分退回。不可报名，不可选人。";
        icon = @"picWxtsTc";
        leftActionTitle = @"取消";
        rightActionTitle = @"结束";
    }
    else if (_toastType == ToastTaskActivityCancel) {
        title = @"确认取消吗？";
        subTitle = @"取消后，Ta人将无法再看到您发布的活动，您只能在我的发布中查看";
        icon = @"picWxtsTc";
        leftActionTitle = @"暂不取消";
        rightActionTitle = @"确定取消";
    }
    else if (_toastType == ToastActivityPublishFailDueToNotShow) {
        // 发布活动失败,原因: 隐身中
        title = @"温馨提示";
        subTitle = @"达人才能发布活动哦，您已隐身，上架后就可以发布活动了";
        icon = @"picTsTxshsb";
        leftActionTitle = @"取消";
        rightActionTitle = @"去关闭隐身";
        
        _leftActionButton.hidden = YES;
        [_rightActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15.0);
            make.size.mas_equalTo(CGSizeMake(133.5, 44.5));
            make.left.equalTo(self).offset(15.0);
            make.top.equalTo(_descriptLabel.mas_bottom).offset(25.0);
        }];
        _closeButton.hidden = NO;
    }
    else if (_toastType == ToastActivityPublishFailDueToNotRent) {
        // 发布活动失败,原因: 未出租
        title = @"温馨提示";
        subTitle = @"达人才能发布活动哦，您还没有出租。去申请成为达人，就可以发布活动啦";
        icon = @"picTsTxshsb";
        leftActionTitle = @"取消";
        rightActionTitle = @"去申请";
    }
    else if (_toastType == ToastActivityPublishFailDueToInReview) {
        // 发布活动失败,原因: 审核中
        title = @"温馨提示";
        subTitle = @"头像正在人工审核中，暂不可发布活动，请等待审核结果";
        icon = @"picTsTxshsb";
        leftActionTitle = @"取消";
        rightActionTitle = @"知道了";
        
        _leftActionButton.hidden = YES;
        [_rightActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15.0);
            make.size.mas_equalTo(CGSizeMake(133.5, 44.5));
            make.left.equalTo(self).offset(15.0);
            make.top.equalTo(_descriptLabel.mas_bottom).offset(25.0);
        }];
        _closeButton.hidden = NO;
    }
    else if (_toastType == ToastRealNameAuthenticationFailed) {
        // 实名认证失败
        title = @"认证失败";
        subTitle = @"身份证和姓名不匹配!若身份信息为真实有效,可申请人工审核.";
        leftActionTitle = @"重新认证";
        rightActionTitle = @"人工审核";
        _closeButton.hidden = NO;
        
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 1));
        }];
    }
    else if (_toastType == ToastPayTonggao) {
        // 实名认证失败
        _keyStr = (!isNullString(_keyStr) ? _keyStr : @"这些用户");
        NSString *sub = [NSString stringWithFormat:@"您选择了%@来进行本次通告，需要您支付邀约金，支付完成后将自动生成你们的邀约，邀约成功结束前，资金都将由平台监管，请放心支付", _keyStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sub attributes:@{
                                                                                                                         NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14.0f],
                                                                                                                         NSForegroundColorAttributeName: RGBCOLOR(102, 102, 102),
                                                                                                                         NSKernAttributeName: @(0.0)
                                                                                                                         }];
        
        NSRange keyRange = [sub rangeOfString:_keyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:keyRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:keyRange];
        icon = @"picXzTc";
        leftActionTitle = @"在选选";
        rightActionTitle = @"确定选择";
        _subTitleLabel.attributedText = attributedString;
        
        _closeButton.hidden = NO;
    }
    else if (_toastType == ToastTonggaoCancelStyle1) {
        // 新-通告取消
        title = @"确认取消吗?";
        subTitle = @"取消后，该通告报名将结束，发布服务费不再退还，无法报名，不可选人。";
        leftActionTitle = @"取消";
        rightActionTitle = @"结束";
        icon = @"picTsTxshsb";
    }
    else if (_toastType == ToastTonggaoCancelStyle2) {
        // 新-通告取消(超过30分钟并且无人报名)
        title = @"确认取消吗?";
        subTitle = @"取消后，该通告报名将结束，发布服务费将原路退还。不可报名，不可选人。";
        leftActionTitle = @"取消";
        rightActionTitle = @"结束";
        icon = @"picTsTxshsb";
    }
    else if (_toastType == ToastPayTonggaoCancel) {
        // 新-通告选人付钱取消
        title = @"确认放弃选人吗？";
        subTitle = @"距离邀约成功就差一步啦，主动报名您通告的达人都在等待您选择哦";
        leftActionTitle = @"放弃";
        rightActionTitle = @"我再想想";
        icon = @"picTsTxshsb";
    }
    else if (_toastType == ToastRemindRent) {
        title = @"成为达人 赚取收益";
        subTitle = _subTitle;
        rightActionTitle = @"去申请达人";
        icon = @"picTanchuangSqdr";
        _closeButton.hidden = NO;
        
        _leftActionButton.hidden = YES;
        [_rightActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(202, 44.5));
            make.top.equalTo(_descriptLabel.mas_bottom).offset(25.0);
        }];
        
        _rightActionButton.layer.cornerRadius = 22.0;
    }
    else if (_toastType == ToastRemindWechat) {
        title = @"填微信 赚收益";
        subTitle = _subTitle;
        rightActionTitle = @"去填写微信号";
        icon = @"picTianxieweixin";
        _closeButton.hidden = NO;
        
        _leftActionButton.hidden = YES;
        [_rightActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(202, 44.5));
            make.top.equalTo(_descriptLabel.mas_bottom).offset(25.0);
        }];
        
        _rightActionButton.layer.cornerRadius = 22.0;
    }
    
    _titleLabel.text = title;
    if (subTitle) {
        _subTitleLabel.text = subTitle;
    }
    
    if (descript) {
        _descriptLabel.text = descript;
    }
    
    _iconImageView.image = [UIImage imageNamed:icon];
    [_leftActionButton setTitle:leftActionTitle forState:UIControlStateNormal];
    [_rightActionButton setTitle:rightActionTitle forState:UIControlStateNormal];

}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 6;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.descriptLabel];
    [self addSubview:self.leftActionButton];
    [self addSubview:self.rightActionButton];
    [self addSubview:self.closeButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self).offset(20.0);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(18.0);
        make.size.mas_equalTo(CGSizeMake(116.0, 79.0));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20.0);
        make.right.equalTo(self).offset(-20.0);
        make.top.equalTo(_iconImageView.mas_bottom).offset(20.0);
    }];

    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(5.0);
    }];
    
    [_leftActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(_descriptLabel.mas_bottom).offset(25.0);
        make.size.mas_equalTo(CGSizeMake(133.5, 44.5));
        make.bottom.equalTo(self).offset(-15.0);
    }];
    
    [_rightActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(133.5, 44.5));
        make.centerY.equalTo(_leftActionButton);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc] init];
        _descriptLabel.font = [UIFont systemFontOfSize:13.0];
        _descriptLabel.textAlignment = NSTextAlignmentCenter;
        _descriptLabel.textColor = RGBCOLOR(63, 58, 58);
        _descriptLabel.numberOfLines = 0;
    }
    return _descriptLabel;
}

- (UIButton *)leftActionButton {
    if (!_leftActionButton) {
        _leftActionButton = [[UIButton alloc] init];
        _leftActionButton.backgroundColor = RGBCOLOR(244, 203, 7);
        _leftActionButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_leftActionButton setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _leftActionButton.layer.cornerRadius = 3.0;
    }
    return _leftActionButton;
}

- (UIButton *)rightActionButton {
    if (!_rightActionButton) {
        _rightActionButton = [[UIButton alloc] init];
        _rightActionButton.backgroundColor = RGBCOLOR(244, 203, 7);
        _rightActionButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_rightActionButton setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _rightActionButton.layer.cornerRadius = 3.0;
    }
    return _rightActionButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icGbTc"] forState:UIControlStateNormal];
        _closeButton.hidden = YES;
    }
    return _closeButton;
}

@end
