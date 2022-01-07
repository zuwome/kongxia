//
//  ZZChatBoxGreetingEditView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatBoxGreetingEditView.h"

@interface ZZChatBoxGreetingEditView () <UITextViewDelegate>

@property (nonatomic) UIView *bgView;
@property (nonatomic) UIView *containView;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIView *line;
@property (nonatomic) UIButton *closeBtn;
@property (nonatomic) UIButton *saveBtn;
@property (nonatomic) UIButton *sendBtn;

@end

@implementation ZZChatBoxGreetingEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
    }];
    
    [_containView addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_containView);
        make.top.equalTo(@15);
        make.height.equalTo(@20);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
    }];
    
    [_containView addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_title.mas_bottom).offset(15);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [_containView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [_containView addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
        make.top.equalTo(_line.mas_bottom).offset(20);
        make.height.equalTo(@80);
    }];
    
    [_containView addSubview:self.countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_textView);
        make.top.equalTo(_textView.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    
    [_containView addSubview:self.saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countLab.mas_bottom).offset(15);
        make.leading.equalTo(@15);
        make.height.equalTo(@44);
        make.width.equalTo(@((SCREEN_WIDTH - 90 - 15) / 2));
        make.bottom.equalTo(_containView).offset(-15);
    }];
    
    [_containView addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn);
        make.trailing.equalTo(@-15);
        make.height.equalTo(_saveBtn);
        make.width.equalTo(_saveBtn);
    }];
}

- (void)closeClick {
    [self removeFromSuperview];
}

- (void)resignKeyboard {
    [self.textView resignFirstResponder];
}

- (void)saveClick { //保存并关闭窗口
    if (self.textView.text.length <= 0) {
        [ZZHUD showTastInfoErrorWithString:@"你还没有输入哦"];
        return;
    }
    if (self.textView.text.length > 30) {
        [ZZHUD showTastInfoErrorWithString:@"不能输入超过30个字符"];
        return;
    }
    [self closeClick];
    !self.clickSave ? : self.clickSave(self.textView.text);
}

- (void)sendClick { //保存、发送并关闭窗口
    if (self.textView.text.length <= 0) {
        [ZZHUD showTastInfoErrorWithString:@"你还没有输入哦"];
        return;
    }
    if (self.textView.text.length > 30) {
        [ZZHUD showTastInfoErrorWithString:@"不能输入超过30个字符"];
        return;
    }
    [self closeClick];
    !self.clickSend ? : self.clickSend(self.textView.text);
}

#pragma mark -- textviewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.countLab.text = [NSString stringWithFormat:@"%ld/30",textView.text.length];
    if (textView.text.length > 30) {
        self.countLab.textColor = kRedColor;
    } else {
        self.countLab.textColor = kGrayTextColor;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-100);
        }];
        [self layoutIfNeeded];//强制绘制
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];
        [self layoutIfNeeded];//强制绘制
    }];
}

- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)]];
    }
    return _bgView;
}

- (UIView *)containView {
    if (nil == _containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor whiteColor];
        _containView.layer.cornerRadius = 6;
        _containView.clipsToBounds = YES;
    }
    return _containView;
}

- (UILabel *)title {
    if (nil == _title) {
        _title = [[UILabel alloc] init];
        _title.text = @"常用语";
        _title.textColor = kBlackColor;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
    }
    return _title;
}

- (UIView *)line {
    if (nil == _line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kBGColor;
    }
    return _line;
}

- (UIButton *)closeBtn {
    if (nil == _closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"icGreetingClose"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (UITextView *)textView {
    if (nil == _textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = kBGColor;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.placeholder = @"输入您的常用回复，请不要包含QQ、微信等联系方式广告、低俗、暴力内容，否则系统可能会封禁您的账号";
    }
    return _textView;
}

- (UILabel *)countLab {
    if (nil == _countLab) {
        _countLab = [[UILabel alloc] init];
        _countLab.text = @"0/30";
        _countLab.textColor = kGrayTextColor;
        _countLab.font = [UIFont systemFontOfSize:13];
        _countLab.textAlignment = NSTextAlignmentRight;
    }
    return _countLab;
}

- (UIButton *)saveBtn {
    if (nil == _saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        _saveBtn.backgroundColor = RGBCOLOR(216, 216, 216);
        _saveBtn.layer.cornerRadius = 3;
        _saveBtn.clipsToBounds = YES;
        [_saveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
        [_saveBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}

- (UIButton *)sendBtn {
    if (nil == _sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.backgroundColor = kGoldenRod;
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.clipsToBounds = YES;
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendBtn setTitle:@"保存并发送" forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendBtn;
}

@end
