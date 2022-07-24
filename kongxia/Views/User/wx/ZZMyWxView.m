//
//  ZZMyWxView.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMyWxView.h"
#import "TTTAttributedLabel.h"
#import "ZZWXHideAlertView.h"
#import "ZZFastChatAgreementVC.h"
@interface ZZMyWxView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIButton *backupBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSString *lastString;
@property (nonatomic, strong) ZZWXHideAlertView *hideAlertView;
@property (nonatomic, strong) UIButton *openSanChatButton;
@end

@implementation ZZMyWxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textField.placeholder = @"请输入您的微信号，开始获取收益";
        [_textField setValue:kYellowColor forKeyPath:@"placeholderLabel.textColor"];
        self.guideView.hidden = NO;
        self.incomeLabel.text = @"￥0";
        self.infoLabel.text = @"温馨提示";
        self.backupBtn.backgroundColor = kYellowColor;
        
    }
    return self;
}

- (void)setUser:(ZZUser *)user {
    _user = user;
    if (user.have_wechat_no) {
        self.textField.text = user.wechat.no;
        self.incomeLabel.text = [NSString stringWithFormat:@"￥%@",[ZZUtils dealAccuracyNumber:user.money_get_by_wechat_no]];
        _lastString = self.textField.text;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)backupBtnClick {
    [self endEditing:YES];
   
    if (isNullString(_textField.text)) {
        [self.window addSubview:self.hideAlertView];
    }
    else {
        
//        if (![self isWechat]) {
//            [ZZHUD showTastInfoErrorWithString:@"微信号必须是以字母开头,支持6-20个字母、数字、下划线和减号"];
//            return;
//        }
        
        _textField.text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (isNullString(_textField.text)){
            [ZZHUD showTastInfoErrorWithString:@"微信号不允许输入空格"];
            return;
        }
        NSString *number = @"";
        NSString *infoString = @"微信号已隐藏";
        if (!isNullString(_textField.text)) {
            number = self.textField.text;
            infoString = @"保存微信号成功";
        }
        NSDictionary *param = @{@"wechat_no":number};
        [self requestWithParam:param infoString:infoString];
    }
}

- (void)sureBtnClick {
    NSString *number = @"";
    NSString *infoString = @"微信号已隐藏";
    if (!isNullString(_textField.text)) {
        number = _textField.text;
        infoString = @"保存微信号成功";
    }
    NSDictionary *param = @{@"wechat_no":number};
    [self requestWithParam:param infoString:infoString];
    
}

- (void)editBtnClick {
    [_textField becomeFirstResponder];
}

- (void)requestWithParam:(NSDictionary *)param infoString:(NSString *)infoString {
    _backupBtn.userInteractionEnabled = NO;
    [ZZHUD showWithStatus:@"提交中..."];
    WS(weakSelf);
    [_user updateWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        weakSelf.backupBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:infoString];
            ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            if (weakSelf.wxUpdate) {
                weakSelf.wxUpdate();
            }
        }
    }];
}

- (void)guideBtnClick {
    [self endEditing:YES];
    if (_touchGuide) {
        _touchGuide();
    }
}

- (BOOL)isWechat {
    NSString *wechat = self.textField.text;
    NSString *regex = @"^[a-zA-Z]([-_0-9a-zA-Z]{5,19})+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:wechat]) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - UITextFieldMethod

- (void)textValueChanged:(UITextField *)textField {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
    if ([self includeChinese:textField.text]) {
        textField.text = _lastString;
    }
    _lastString = textField.text;
}

- (BOOL)includeChinese:(NSString *)string {
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        //汉字的编码区域
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

#pragma mark - lazyload

- (UITextField *)textField {
    if (!_textField) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 67.5, SCREEN_WIDTH - 30, 0.5)];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(58, 22, SCREEN_WIDTH - 15 - 58, 46)];
        _textField.textColor = kYellowColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_textField];
        
        UIImageView *wxImgView = [[UIImageView alloc] init];
        wxImgView.image = [UIImage imageNamed:@"icon_wx_wx_p"];
        [self addSubview:wxImgView];
        
        [wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(_textField.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(29, 24));
        }];
    }
    return _textField;
}

- (UIView *)guideView {
    if (!_guideView) {
        _guideView = [[UIView alloc] init];
        _guideView.backgroundColor = [UIColor whiteColor];
        _guideView.layer.cornerRadius = 2;
        _guideView.layer.borderColor = HEXACOLOR(0x000000, 0.4).CGColor;
        _guideView.layer.borderWidth = 0.5;
        [self addSubview:_guideView];
        
        [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(_textField.mas_bottom).offset(18);
            make.height.mas_equalTo(@20);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXACOLOR(0x000000, 0.4);
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"如何找到自己的微信号";
        [_guideView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_guideView.mas_left).offset(3);
            make.centerY.mas_equalTo(_guideView.mas_centerY);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_arrow_right_yellow"];
        [_guideView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(3);
            make.right.mas_equalTo(_guideView.mas_right).offset(-3);
            make.centerY.mas_equalTo(_guideView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 9));
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideBtnClick)];
        [_guideView addGestureRecognizer:recognizer];
    }
    return _guideView;
}

- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.hidden = YES;
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"我的收益：";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(_guideView.mas_bottom).offset(40);
        }];
        
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textColor = HEXCOLOR(0xE74A46);
        _incomeLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_incomeLabel];
        
        [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(@0.5);
        }];
        
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = HEXACOLOR(0x000000, 0.4);
        _introduceLabel.font = [UIFont systemFontOfSize:12];
        _introduceLabel.numberOfLines = 0;
        [self addSubview:_introduceLabel];
        
        NSString *string = @"微信号每次被查看，都能获取一笔15元的收益";
        if ([ZZUserHelper shareInstance].loginer.wechat_price_get) {
            string = [NSString stringWithFormat:@"微信号每次被查看，都能获取一笔%@元的收益",[ZZUtils dealAccuracyDouble:[ZZUserHelper shareInstance].loginer.wechat_price_get]];
        }
        CGFloat height = [ZZUtils heightForCellWithText:string fontSize:12 labelWidth:SCREEN_WIDTH - 30];
        _introduceLabel.text = string;
        
        [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(lineView);
            make.top.mas_equalTo(lineView.mas_bottom).offset(15);
            make.height.mas_equalTo(height);
        }];
        
        titleLabel.hidden = NO;
        _infoLabel.hidden = NO;
        _incomeLabel.hidden = NO;
        lineView.hidden = NO;
        _introduceLabel.hidden = NO;
    }
    return _incomeLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        NSArray *titleArray = @[
            @"微信号仅在对方支付红包后，发送给对方，请安心填写。",
            @"及时通过Ta人的微信好友请求，打赏才会转入您的账户",
            @"为确保对方可以搜索到您的微信号，请确保“微信-我-隐私”中“通过微信号搜到我”选项处于打开状态。",
            @"填写虚假微信号可能面临封禁、信任值下调等处理。",
            @"私下索要红包设置加微信门槛，平台会下调推荐并罚款50元，对于多次违规的达人，平台将予以封禁处理。",
            @"未通过平台查看，透露自己微信号给他人或添加他人微信号，将面临50元/次的罚款，平台将有权冻结账户余额至该笔罚款被扣除",
        ];
        CGFloat offset = 15;
        UIView *lastView;
        for (int i=0 ; i<titleArray.count; i++) {
            UIView *bgView = [[UIView alloc] init];
            [self addSubview:bgView];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-offset);
            }];
            
            UILabel *starLabel = [[UILabel alloc] init];
            starLabel.textColor = kYellowColor;
            starLabel.font = [UIFont systemFontOfSize:13];
            starLabel.text = @"*";
            [bgView addSubview:starLabel];
            
            [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bgView.mas_left).offset(15);
                make.top.mas_equalTo(bgView.mas_top);
            }];
            
            TTTAttributedLabel *infoDetailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            infoDetailLabel.lineSpacing = 5;
            infoDetailLabel.numberOfLines = 0;
            infoDetailLabel.textColor = HEXCOLOR(0x443A3A);
            infoDetailLabel.font = [UIFont systemFontOfSize:13];
//            infoDetailLabel.attributedText = [ZZUtils setLineSpace:titleArray[i] space:5 fontSize:13 color:HEXCOLOR(0x443A3A)];
            infoDetailLabel.text = titleArray[i];
            [bgView addSubview:infoDetailLabel];
            
            [infoDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(bgView.mas_top);
                make.left.mas_equalTo(bgView.mas_left).offset(23);
                make.right.mas_equalTo(bgView.mas_right).offset(-15);
                make.width.mas_equalTo(SCREEN_WIDTH - 23 - 15);
                make.bottom.mas_equalTo(bgView.mas_bottom);
            }];
            
            CGFloat height = [bgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            offset = offset + height + 5;
            
            [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            
            lastView = bgView;
        }
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = kBlackTextColor;
        _infoLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_infoLabel];
        
        CGFloat height1 = [ZZUtils heightForCellWithText:@"哈哈哈哈" fontSize:12 labelWidth:SCREEN_WIDTH - 30];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(23);
            make.bottom.mas_equalTo(lastView.mas_top).offset(-8);
            make.height.mas_equalTo(height1);
        }];
    }
    return _infoLabel;
}

- (UIButton *)backupBtn {
    if (!_backupBtn) {
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_introduceLabel.mas_bottom);
            make.bottom.mas_equalTo(_infoLabel.mas_top);
        }];
        
        _backupBtn = [[UIButton alloc] init];
        [_backupBtn setTitle:@"保存微信号" forState:UIControlStateNormal];
        [_backupBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _backupBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _backupBtn.layer.cornerRadius = 3;
        [_backupBtn addTarget:self action:@selector(backupBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_backupBtn];


        [_backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view.mas_centerX);
            make.centerY.mas_equalTo(view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(240, 44));
        }];

        if (![ZZUserHelper shareInstance].loginer.open_qchat &&
            [ZZUserHelper shareInstance].configModel.isShowQchat &&
            [ZZUserHelper shareInstance].loginer.gender == 2) {
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if (!(version && [version isEqualToString:@"3.7.5"])) {
                [view addSubview:self.openSanChatButton];
                [self.openSanChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(view.mas_centerX);
                    make.bottom.equalTo(_backupBtn.mas_top).offset(-29);
                }];
            }
            
        }
    }
    return _backupBtn;
}

- (ZZWXHideAlertView *)hideAlertView {
    WeakSelf;
    if (!_hideAlertView) {
        _hideAlertView = [[ZZWXHideAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hideAlertView.touchSure = ^{
            [weakSelf sureBtnClick];
        };
        _hideAlertView.touchEidt = ^{
            [weakSelf editBtnClick];
        };
    }
    return _hideAlertView;
}

- (UIButton *)openSanChatButton {
    if (!_openSanChatButton) {
        _openSanChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openSanChatButton setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
        [_openSanChatButton setTitle:kMsg_OpenShanChatMessage forState:UIControlStateNormal];
        _openSanChatButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_openSanChatButton addTarget:self action:@selector(openSanChatButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _openSanChatButton.hidden = YES;
    }
    return _openSanChatButton;
}

- (void)openSanChatButtonClick {
    if (self.open_SanChat) {
        self.open_SanChat();
    }
}

- (void)dealloc {
    [ZZHUD dismiss];
}

@end
