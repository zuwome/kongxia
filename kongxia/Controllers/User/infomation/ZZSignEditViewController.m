//
//  ZZSignEditViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSignEditViewController.h"
#import "ZZSignEditDialogView.h"
#import "ZZSkillThemesHelper.h"
#import "ZZAutoCreateDesModel.h"
#import "kongxia-Swift.h"
#import <YYModel.h>
@interface ZZSignEditViewController () <UITextViewDelegate, ZZAutoCreateViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) ZZSignEditDialogView *dialogView;
@property (nonatomic, strong) UILabel *skillTipLab; //编写技能介绍底部提示
@property (nonatomic, strong) UILabel *titleLab;    //技能标题
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, assign) BOOL haveChange;

@property (nonatomic, assign) BOOL isYidunTimeout;  //如果易盾挂了，标识为YES即嫌疑敏感词，转给人工客服判断

@property (nonatomic, strong) ZZAutoCreateDesModel *autoCreateDesModel;

@property (nonatomic, strong) ZZAutoCreateView *autoCreateView;

@property (nonatomic, strong) UIView *autoCreateDesView;

@property (nonatomic, copy) NSArray<NSString *> *autoCreateContents;

@end

@implementation ZZSignEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.signEditType == SignEditTypeSign ? @"自我介绍" : @"编辑文字介绍";
    self.view.backgroundColor = kBGColor;
    [self createRightBarButton];
    [self createViews];
    
    if (self.signEditType == SignEditTypeSkill) {
        [self loadSkillTip];
        [self fetchAutoCreateInfo];
        [self hideAutoCreateView:!isNullString(_valueString)];
    }
    
    _textView.placeholder = self.signEditType == SignEditTypeSign ? @"说说你的与众不同或特长爱好" : @"可以介绍你擅长或热爱的领域，或取得的小成就，可以为他人提供哪些帮助？";
    _limitNumber = self.signEditType == SignEditTypeSkill ? 200 : 80;
    _textView.text = _valueString;
    _limitLabel.text = [NSString stringWithFormat:@"%ld/%ld",_valueString.length,_limitNumber];
    _titleLab.text = _skillName;
}

- (void)createRightBarButton {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createViews {
    if (self.signEditType == SignEditTypeSkill) {
        _autoCreateDesView = [[UIView alloc] init];
        _autoCreateDesView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAutoView)];
        [_autoCreateDesView addGestureRecognizer:tap];
        [self.view addSubview:_autoCreateDesView];
        [_autoCreateDesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.height.equalTo(@36);
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"yijianshengchengfangxiang"];
        [_autoCreateDesView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_autoCreateDesView);
            make.left.equalTo(_autoCreateDesView).offset(15);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"不会写技能文字介绍？点击一键生成";
        label.textColor = RGBCOLOR(244, 203, 7);
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label.userInteractionEnabled = YES;
        [_autoCreateDesView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_autoCreateDesView);
            make.left.equalTo(iconImageView.mas_right).offset(8);
            make.right.equalTo(_autoCreateDesView).offset(-15);
        }];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = kBlackColor;
        _titleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
        _titleLab.numberOfLines = 0;
        [self.view addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_autoCreateDesView.mas_bottom).offset(12.0);
            make.leading.equalTo(@15);
            make.trailing.equalTo(@-15);
            make.height.equalTo(@20);
        }];
        
        _changeBtn = [[UIButton alloc] init];
        _changeBtn.normalTitle = @"换一换";
        _changeBtn.normalTitleColor = RGBCOLOR(74, 144, 226);
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_changeBtn addTarget:self action:@selector(switchTemplate) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.hidden = YES;
        [self.view addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLab);
            make.right.equalTo(self.view).offset(-15);
            make.height.equalTo(@(60.0));
        }];
    }
    
    _textView = [[UITextView alloc] init];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = kBlackTextColor;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.signEditType == SignEditTypeSkill) {
            make.top.equalTo(_titleLab.mas_bottom).offset(10);
        } else {
            make.top.equalTo(self.view).offset(15);
        }
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.height.equalTo(@150);
    }];
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.textColor = RGBCOLOR(190, 190, 190);
    _limitLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_limitLabel];
    [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(_textView.mas_bottom).offset(8);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = RGBCOLOR(190, 190, 190);
    _tipLabel.font = [UIFont systemFontOfSize:13];
    _tipLabel.numberOfLines = 0;
    _tipLabel.userInteractionEnabled = YES;
    [_tipLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDialog)]];
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(8);
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(_limitLabel.mas_leading).offset(-30);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    if (self.signEditType == SignEditTypeSkill) {
        _skillTipLab = [[UILabel alloc] init];
        _skillTipLab.numberOfLines = 0;
        [self.view addSubview:_skillTipLab];
        [_skillTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.trailing.equalTo(@-15);
            make.bottom.equalTo(@-15);
            make.height.greaterThanOrEqualTo(@0);
        }];
    }
    
    NSString *tipStr = self.signEditType == SignEditTypeSign ? @"优秀的自我介绍可以获得更多粉丝和推荐机会哦！\n看看别人怎么写" : @"优秀的技能文字介绍可以获得更多的推荐机会哦！\n看看别人怎么写";
    NSRange touchRange = [tipStr rangeOfString:@"看看别人怎么写"];
    NSDictionary *touchAttribute = @{NSForegroundColorAttributeName:RGBCOLOR(74, 144, 226),
                                     NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    NSMutableAttributedString *attrTipStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
    [attrTipStr setAttributes:touchAttribute range:touchRange];
    _tipLabel.attributedText = attrTipStr;
    
    [self.view addSubview:self.dialogView];
}

- (void)navigationLeftBtnClick {
    if (_haveChange) {
        self.navigationLeftBtn.enabled = NO;
        [self showOkCancelAlert:@"已修改,是否保存？" message:nil confirmTitle:@"保存" confirmHandler:^(UIAlertAction * _Nonnull action) {
            self.navigationLeftBtn.enabled = YES;
            [self doneBtnClick];
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
            [super navigationLeftBtnClick];
        }];
    } else {
        [super navigationLeftBtnClick];
    }
}

- (void)loadSkillTip {
    [[ZZSkillThemesHelper shareInstance] howToWriteSkillDetail:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSString *htmlStr = data[@"how_to_writedetail"];
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
            NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
            _skillTipLab.attributedText = attrStr;
        }
    }];
}

- (void)showAutoView {
    [self showAutoCreateView:_skills];
}

- (void)showAutoCreateView:(NSArray<ZZSkillTag *> *)skills {
    [self.view endEditing:YES];
    _autoCreateView = [ZZAutoCreateView showIn:self info:_autoCreateDesModel skillsArray:skills];
    _autoCreateView.delegate = self;
    
}

- (void)hideAutoCreateView:(BOOL)isHide {
    _autoCreateDesView.hidden = isHide;
}

#pragma mark - UITextViewMethod
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > _limitNumber) {
        textView.text = [textView.text substringToIndex:_limitNumber];
    }
    
    _limitLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,_limitNumber];
    if (isNullString(textView.text)) {
        _changeBtn.hidden = YES;
        _haveChange = NO;
    }
    else {
        _haveChange = YES;
    }
    [self hideAutoCreateView:!isNullString(textView.text)];
}

#pragma mark - UIButtonMethod
- (void)switchTemplate {
    NSInteger index = arc4random() % 2;
    _textView.text = _autoCreateContents[index];
}

- (void)doneBtnClick {
    if (self.signEditType == SignEditTypeSkill) {   //编辑技能介绍
        if (_textView.text.length == 0) {
            [self checkSuccessWithCode:-1];
            return;
        }
        if (_textView.text.length < 6) {
            [ZZHUD showErrorWithStatus:@"技能介绍最少6个字"];
        } else if (_textView.text.length > _limitNumber) {
            [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"技能介绍最少%ld个字",_limitNumber]];
        } else {
            [ZZUserHelper checkTextWithText:_textView.text type:5 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    if (error.code == 2001 || error.code == 2002) {
                        [self showOkAlert:@"提示" message:error.message confirmTitle:@"修改技能介绍" confirmHandler:^(UIAlertAction * _Nonnull action) {
                            [_textView becomeFirstResponder];
                        }];
                    } else {
                        _isYidunTimeout = YES;
                        _haveChange = NO;
                        [self checkSuccessWithCode:-1];
//                        [ZZHUD showErrorWithStatus:error.message];
                    }
                } else {
                    _haveChange = NO;
                    [self checkSuccessWithCode:1];
                }
            }];
        }
    }
    else {
        // 编辑签名信息
        if (_textView.text.length > _limitNumber) {
            [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"字数请控制在%ld字内",_limitNumber]];
            return;
        }
        
        [ZZUserHelper checkTextWithText:_textView.text type:1 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                if (error.code == 2001 || error.code == 2002) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的介绍内容可能含有不良词汇,无法保存.建议您修改或提交人工审核" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"修改提交" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//                        [self checkSuccessWithCode:error.code];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"人工审核" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        [self checkSuccessWithCode:error.code];
                    }];
                    [alert addAction:continueAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    _isYidunTimeout = YES;
                    _haveChange = NO;
                    [self checkSuccessWithCode:-1];
//                    [ZZHUD showErrorWithStatus:error.message];
                }
            } else {
                _haveChange = NO;
                [self checkSuccessWithCode:-1];
            }
        }];
    }
}

- (void)checkSuccessWithCode:(NSInteger)code {
    if (_callBackBlock) {
        _callBackBlock(_textView.text, _isYidunTimeout, code);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showDialog {
    if (self.dialogView.hidden == NO) {
        [self.dialogView dialogHide];
    } else {
        CGRect frame = self.tipLabel.frame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y + frame.size.height;
        CGPoint location = CGPointMake(x, y);
        [self.dialogView setDialogLocation:location];
        [self.dialogView dialogShow];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //点击self.view,隐藏dialog，收起键盘
    BOOL touchOnRootView = YES;
    CGPoint point = [[touches anyObject] locationInView:self.view];
    for (UIView *view in self.view.subviews) {
        CGPoint convertPoint = [view.layer convertPoint:point fromLayer:self.view.layer];
        if ([view.layer containsPoint:convertPoint]) {
            touchOnRootView = NO;
            break;
        }
    }
    if (touchOnRootView) {
        [self.dialogView dialogHide];
        [self.textView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZZSignEditDialogView *)dialogView {
    if (nil == _dialogView) {
        _dialogView = [[ZZSignEditDialogView alloc] init];
        _dialogView.signEditType = _signEditType;
        _dialogView.sid = _sid;
    }
    return _dialogView;
}

#pragma mark - Request
- (void)fetchAutoCreateInfo {
    [ZZRequest method:@"GET" path:@"/dimensioncatalog/list" params:@{@"catalogId": !isNullString(self.sid) ? self.sid : @""} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error && [data isKindOfClass:[NSDictionary class]])  {
            _autoCreateDesModel = [ZZAutoCreateDesModel yy_modelWithJSON:data];
        }
    }];
}

#pragma mark - ZZAutoCreateViewDelegate
- (void)showSkillsViewWithSkills:(NSArray<ZZSkillTag *> *)skills {
    WeakSelf
    ZZChooseTagViewController *controller = [[ZZChooseTagViewController alloc] init];
    controller.selectedArray = [skills mutableCopy];
    controller.catalogId = _sid;
    [controller setChooseTagCallback:^(NSArray *tags) {
        if (_autoCreateView) {
            weakSelf.autoCreateView.skillsArray = tags;
            [weakSelf.autoCreateView show];
        }
        else {
            [weakSelf showAutoCreateView:tags];
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dismissed {
    _autoCreateView = nil;
//    [_autoCreateDesModel.dimension enumerateObjectsUsingBlock:^(ZZAutoCreateDimensionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.type != 3) {
//            obj.inputContent = nil;
//        }
//    }];
}

- (void)confirmSelectionWithCreateContents:(NSArray<NSString *> *)createContents skills:(NSArray<ZZSkillTag *> *)skills {
    _autoCreateContents = createContents;
    _textView.text = createContents.firstObject;
    _limitLabel.text = [NSString stringWithFormat:@"%ld/%ld",_textView.text.length,_limitNumber];
    _changeBtn.hidden = NO;
    [self hideAutoCreateView:!isNullString(_textView.text)];
    if (skills && skills.count > 0) {
        if (_changeSkillsBlock) {
            _changeSkillsBlock(skills);
        }
    }
    
    [_autoCreateDesModel.dimension enumerateObjectsUsingBlock:^(ZZAutoCreateDimensionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != 3) {
            obj.inputContent = nil;
        }
    }];
}

@end
