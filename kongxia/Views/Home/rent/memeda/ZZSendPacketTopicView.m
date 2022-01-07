//
//  ZZSendPacketTopicView.m
//  zuwome
//
//  Created by angBiu on 2017/3/30.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSendPacketTopicView.h"

@interface ZZSendPacketTopicView ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *infoBtn;

@end

@implementation ZZSendPacketTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.questionTV.placeholder = @"遇见你很高兴";
    }
    
    return self;
}

- (void)infoBtnClick
{
    if (_touchTopicInfo) {
        _touchTopicInfo();
    }
}

- (void)randomBtnClick
{
    if (_touchRandom) {
        _touchRandom();
    }
}

- (void)setQuestion:(NSString *)question
{
    _questionTV.text = question;
    [self managerTV];
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
}

- (void)managerTV
{
    if (_questionTV.text.length > 50) {
        _questionTV.text = [_questionTV.text substringToIndex:50];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/50",50 - _questionTV.text.length];
}

#pragma mark -

- (UITextView *)questionTV
{
    if (!_questionTV) {
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 2.5;
        bgView.backgroundColor = kBGColor;
        bgView.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        bgView.layer.borderWidth = 1;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(self.mas_top).offset(12);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
        }];
        
        _questionTV = [[UITextView alloc] init];
        _questionTV.placeholderColor = HEXCOLOR(0x898989);
        _questionTV.textAlignment = NSTextAlignmentLeft;
        _questionTV.textColor = kBlackTextColor;
        _questionTV.font = [UIFont systemFontOfSize:14];
        _questionTV.backgroundColor = kBGColor;
        _questionTV.delegate = self;
        [bgView addSubview:_questionTV];
        
        [_questionTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(bgView);
            make.height.mas_equalTo(@90);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = kGrayTextColor;
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.text = @"0/50";
        _countLabel.userInteractionEnabled = NO;
        [bgView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_questionTV.mas_right).offset(-8);
            make.bottom.mas_equalTo(_questionTV.mas_bottom);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
        }];
        
        UIButton *infoBtn = [[UIButton alloc] init];
        [infoBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:infoBtn];
        
        [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_bottom).offset(17);
            make.left.mas_equalTo(bgView.mas_left);
            make.size.mas_equalTo(CGSizeMake(23, 23));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-17);
        }];
        
        UIImageView *infoImgView = [[UIImageView alloc] init];
        infoImgView.contentMode = UIViewContentModeScaleToFill;
        infoImgView.image = [UIImage imageNamed:@"btn_memeda_question"];
        infoImgView.userInteractionEnabled = NO;
        [infoBtn addSubview:infoImgView];
        
        [infoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(infoBtn);
        }];
        
        UIButton *randomBtn = [[UIButton alloc] init];
        [randomBtn setTitle:@"随机留言" forState:UIControlStateNormal];
        [randomBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        randomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        randomBtn.backgroundColor = kYellowColor;
        randomBtn.layer.cornerRadius = 2;
        [randomBtn addTarget:self action:@selector(randomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        randomBtn.hidden = YES;
        [self addSubview:randomBtn];
        
        [randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(infoBtn.mas_centerY);
            make.left.mas_equalTo(infoBtn.mas_right).offset(12);
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];
    }
    
    return _questionTV;
}

@end
