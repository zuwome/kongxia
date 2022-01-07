//
//  ZZRentMemedaTopicView.m
//  zuwome
//
//  Created by angBiu on 16/8/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaTopicView.h"

#import "ZZLabelView.h"

@interface ZZRentMemedaTopicView ()

@property (nonatomic, strong) UIButton *publicBtn;//视频问答
@property (nonatomic, strong) UIButton *privateBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *addLabelBtn;
@property (nonatomic, strong) UIButton *randomBtn;
@property (nonatomic, strong) UIImageView *infoImgView;//匿名 new
@property (nonatomic, strong) UIImageView *anonymousImgView;//
@property (nonatomic, strong) UIButton *anonymousBtn;

@end

@implementation ZZRentMemedaTopicView
{
    UIView                      *_labelBgView;
    
    NSString                    *_lastPublicStr;
    NSString                    *_lastPrivateStr;
    
    CGFloat                     _labelHeight;
    CGFloat                     _labelBgHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.publicBtn];
        [self addSubview:self.privateBtn];
        
        // 暂时隐藏么么答切换按钮
        self.publicBtn.hidden = YES;
        self.privateBtn.hidden = YES;
        self.publicBtn.enabled = NO;
        self.privateBtn.enabled = NO;
        self.lineView.hidden = YES;
        
//        UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.publicBtn.height, SCREEN_WIDTH, 0.5)];
        UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0.5)];//整体上移
        grayLineView.backgroundColor = kLineViewColor;
        [self addSubview:grayLineView];
        [self addSubview:self.lineView];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 2.5;
        bgView.backgroundColor = kBGColor;
        bgView.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        bgView.layer.borderWidth = 1;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
//            make.top.mas_equalTo(_publicBtn.mas_bottom).offset(12);
            make.top.mas_equalTo(grayLineView.mas_bottom).offset(10);//整体上移
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
        }];
        
        [bgView addSubview:self.questionTV];
        
        [_questionTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            make.right.mas_equalTo(bgView.mas_right);
            make.top.mas_equalTo(bgView.mas_top);
            make.height.mas_equalTo(@90);
        }];
        
        [bgView addSubview:self.countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-8);
            make.top.mas_equalTo(_questionTV.mas_bottom);
        }];

        _labelBgView = [[UIView alloc] init];
        _labelBgView.clipsToBounds = YES;
        [bgView addSubview:_labelBgView];
        
        [_labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(5);
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
            make.top.mas_equalTo(_countLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXCOLOR(0xcccccc);
        [_labelBgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_labelBgView.mas_left).offset(3);
            make.right.mas_equalTo(_labelBgView.mas_right).offset(-3);
            make.top.mas_equalTo(_labelBgView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
        
        _labelHeight = 24;
        
        NSString *str = @"＃添加标签＃";
        CGFloat width = [ZZUtils widthForCellWithText:str fontSize:14];
        
        [_labelBgView addSubview:self.addLabelBtn];
        
        [_addLabelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_labelBgView.mas_left);
            make.top.mas_equalTo(_labelBgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(width + 6, _labelHeight));
        }];
        
        UIButton *infoBtn = [[UIButton alloc] init];
        [infoBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:infoBtn];
        
        [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_bottom).offset(14);
            make.left.mas_equalTo(bgView.mas_left);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        
        UIImageView *infoImgView = [[UIImageView alloc] init];
        infoImgView.contentMode = UIViewContentModeScaleToFill;
        infoImgView.image = [UIImage imageNamed:@"btn_memeda_question"];
        infoImgView.userInteractionEnabled = NO;
        [infoBtn addSubview:infoImgView];
        
        [infoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(infoBtn);
        }];
        
        [self addSubview:self.randomBtn];
        
        [_randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(infoBtn.mas_centerY);
            make.left.mas_equalTo(infoBtn.mas_right).offset(12);
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
        
        _anonymousBtn = [[UIButton alloc] init];
        [_anonymousBtn addTarget:self action:@selector(anonymousBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_anonymousBtn];
        
        [_anonymousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(infoBtn.mas_top).offset(-5);
            make.bottom.mas_equalTo(infoBtn.mas_bottom).offset(5);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(@65);
        }];
        
        _anonymousImgView = [[UIImageView alloc] init];
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_n"];
        _anonymousImgView.userInteractionEnabled = NO;
        [_anonymousBtn addSubview:_anonymousImgView];
        
        [_anonymousImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_anonymousBtn.mas_right);
            make.centerY.mas_equalTo(_anonymousBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *anonymousLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentRight textColor:kBlackTextColor fontSize:15 text:@"匿名"];
        anonymousLabel.userInteractionEnabled = NO;
        [_anonymousBtn addSubview:anonymousLabel];
        
        [anonymousLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_anonymousBtn.mas_left);
            make.centerY.mas_equalTo(_anonymousImgView.mas_centerY);
        }];
        
        _labelBgHeight = _labelHeight + 5;
        _isPublic = YES;
        [_labelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_labelBgHeight);
        }];
        
        _topicArray = [NSMutableArray array];
        
        if (![ZZUserHelper shareInstance].firstAnonymousAskInfo) {
            self.infoImgView.hidden = NO;
        }
    }
    
    return self;
}

- (void)addTopic:(NSString *)topic
{
    [_topicArray addObject:topic];
    [self addLabelView];
}

- (void)addLabelView
{
    [self removeSubviews];
    CGFloat space = 10;
    NSInteger j = 0;
    CGFloat offsetX = [_addLabelBtn systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + space;
    CGFloat maxWidth = SCREEN_WIDTH - 40;
    for (int i=0; i<_topicArray.count; i++) {
        CGFloat width = [ZZUtils widthForCellWithText:_topicArray[i] fontSize:12] + 16;
        
        if (offsetX + width > maxWidth) {
            offsetX = 0;
            j++;
        }
        
        ZZLabelView *labelView = [[ZZLabelView alloc] init];
        labelView.titleLabel.text = _topicArray[i];
        labelView.labelBtn.tag = 100 + i;
        [labelView.labelBtn addTarget:self action:@selector(labelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_labelBgView addSubview:labelView];
        
        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offsetX);
            make.top.mas_equalTo(_labelBgView.mas_top).offset(5+j*(_labelHeight + space));
            make.size.mas_equalTo(CGSizeMake(width, _labelHeight));
        }];
        
        offsetX = offsetX + width + space;
    }
    
    _labelBgHeight = 5 + _labelHeight + (j*(_labelHeight + space));
    [_labelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_labelBgHeight);
    }];
}

- (void)setQuestion:(NSString *)question
{
    _questionTV.text = question;
    [self managerTV];
}

#pragma mark - UIButtonMethod

- (void)anonymousBtnClick
{
    if (_infoImgView) {
        _infoImgView.hidden = YES;
        [ZZUserHelper shareInstance].firstAnonymousAskInfo = @"firstAnonymousAskInfo";
    }
    if (_isAnonymous) {
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_n"];
        _isAnonymous = NO;
    } else {
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_p"];
        _isAnonymous = YES;
    }
}

- (void)statusBtnClick
{
    if (_isPublic) {
        [self privateStatus];
    } else {
        [self publicStatus];
    }
    
    if (_touchEditType) {
        _touchEditType();
    }
}

- (void)privateStatus
{
    [MobClick event:Event_click_ask_private];
    _infoImgView.hidden = YES;
    _anonymousBtn.hidden = YES;
    _publicBtn.selected = NO;
    _privateBtn.selected = YES;
    _isPublic = NO;
    _questionTV.placeholder = @"遇见你很高兴";
    _lastPublicStr = _questionTV.text;
    _randomBtn.hidden = YES;
    if (!_isEdit) {
        _questionTV.text = nil;
        _isEdit = NO;
    }
    [_labelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
    _lineView.center = CGPointMake(_privateBtn.center.x, _publicBtn.height);
}

- (void)publicStatus
{
    [MobClick event:Event_click_ask_public];
    _anonymousBtn.hidden = NO;
    _publicBtn.selected = YES;
    _privateBtn.selected = NO;
    _isPublic = YES;
    _questionTV.placeholder = @"你那么好看，可以赏个脸吗？";
    _lastPrivateStr = _questionTV.text;
    _randomBtn.hidden = NO;
    
    [_labelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_labelBgHeight);
    }];
    
    _lineView.center = CGPointMake(_publicBtn.center.x, _publicBtn.height);
    if (!_isEdit) {
        _questionTV.text = _lastPublicStr;
        _isEdit = NO;
    }
}

- (void)addLabelBtnClick
{
    if (_touchTopic) {
        _touchTopic();
    }
}

- (void)randomBtnClick
{
    if (_touchRandom) {
        _touchRandom();
    }
}

- (void)infoBtnClick
{
    if (_touchTopicInfo) {
        _touchTopicInfo();
    }
}

- (void)labelBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    [self removeSubviews];
    [_topicArray removeObjectAtIndex:index];
    if (_removeIndex) {
        _removeIndex(index);
    }
    [self addLabelView];
}

- (void)removeSubviews
{
    for (UIView *view in _labelBgView.subviews) {
        if ([view isKindOfClass:[ZZLabelView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - UITextViewMethod

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_beginEdit) {
        _beginEdit();
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_endEdit) {
        _endEdit();
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self managerTV];
    _isEdit = YES;
}

- (void)managerTV
{
    if (_questionTV.text.length > 50) {
        _questionTV.text = [_questionTV.text substringToIndex:50];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%lu/50",50 - _questionTV.text.length];
}

#pragma mark - Lazyload

- (UIButton *)publicBtn
{
    if (!_publicBtn) {
        _publicBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100 - 15, 0, 100, 45)];
        [_publicBtn setTitle:@"视频问答" forState:UIControlStateNormal];
        [_publicBtn setTitleColor:HEXCOLOR(0x9B9B9B) forState:UIControlStateNormal];
        [_publicBtn setTitle:@"视频问答" forState:UIControlStateSelected];
        [_publicBtn setTitleColor:kYellowColor forState:UIControlStateSelected];
        _publicBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_publicBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _publicBtn;
}

- (UIButton *)privateBtn
{
    if (!_privateBtn) {
        _privateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 15, 0, 100, 45)];
        [_privateBtn setTitle:@"私信提问" forState:UIControlStateNormal];
        [_privateBtn setTitleColor:HEXCOLOR(0x9B9B9B) forState:UIControlStateNormal];
        [_privateBtn setTitle:@"私信提问" forState:UIControlStateSelected];
        [_privateBtn setTitleColor:kYellowColor forState:UIControlStateSelected];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_privateBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _privateBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 2)];
        _lineView.backgroundColor = kYellowColor;
    }
    
    return _lineView;
}

- (UITextView *)questionTV
{
    if (!_questionTV) {
        _questionTV = [[UITextView alloc] init];
        _questionTV.placeholder = @"遇见你很高兴";
        _questionTV.placeholderColor = HEXCOLOR(0x898989);
        _questionTV.textAlignment = NSTextAlignmentLeft;
        _questionTV.textColor = kBlackTextColor;
        _questionTV.font = [UIFont systemFontOfSize:14];
        _questionTV.backgroundColor = kBGColor;
        _questionTV.delegate = self;
    }
    
    return _questionTV;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = kGrayTextColor;
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.text = @"0/50";
    }
    
    return _countLabel;
}

- (UIButton *)addLabelBtn
{
    if (!_addLabelBtn) {
        _addLabelBtn = [[UIButton alloc] init];
        [_addLabelBtn setTitle:@"＃添加标签＃" forState:UIControlStateNormal];
        [_addLabelBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        _addLabelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addLabelBtn addTarget:self action:@selector(addLabelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addLabelBtn;
}

- (UIButton *)randomBtn
{
    if (!_randomBtn) {
        _randomBtn = [[UIButton alloc] init];
        [_randomBtn setTitle:@"随机选问题" forState:UIControlStateNormal];
        [_randomBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _randomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _randomBtn.backgroundColor = kYellowColor;
        _randomBtn.layer.cornerRadius = 2;
        [_randomBtn addTarget:self action:@selector(randomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _randomBtn;
}

- (UIImageView *)infoImgView
{
    if (!_infoImgView) {
        _infoImgView = [[UIImageView alloc] init];
        _infoImgView.image = [UIImage imageNamed:@"icon_memeda_guide_new"];
        [self addSubview:_infoImgView];
        
        [_infoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_anonymousBtn.mas_left).offset(-12);
            make.centerY.mas_equalTo(_anonymousBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 24));
        }];
    }
    
    return _infoImgView;
}

@end
