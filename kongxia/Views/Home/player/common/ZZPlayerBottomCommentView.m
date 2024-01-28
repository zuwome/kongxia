//
//  ZZPlayerBottomCommentView.m
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPlayerBottomCommentView.h"

@interface ZZPlayerBottomCommentView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *commentBgView;
@property (nonatomic, strong) UIButton *packetBtn;
@property (nonatomic, assign) BOOL canSend;

@end

@implementation ZZPlayerBottomCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgImageView];
        [self setUIconstraint];
        [self addSubview:self.bgView];
        [self addSubview:self.commentBgView];
        [self addSubview:self.packetBtn];
        [self addSubview:self.sendBtn];
        [self normalClearStatus];
        //暂时隐藏
        self.sendBtn.hidden = YES;
        self.packetBtn.hidden = YES;
    }
    
    return self;
}

- (void)setCommentModel:(ZZCommentModel *)model
{
    self.commentNameString = [NSString stringWithFormat:@"回复 @%@：",model.reply.user.nickname];
    self.replyId = model.reply.replyId;
    _textField.text = self.commentNameString;
    if (![self.textField isFirstResponder]) {
        [self.textField becomeFirstResponder];
    }
}

- (void)commentWithName:(NSString *)name
{
    
}

#pragma mark - ViewStatus

- (void)keyboardShowStatus
{
    self.bgView.alpha = 1;
    self.commentBgView.backgroundColor = [UIColor whiteColor];
    self.commentBgView.layer.borderWidth = 0.5;
    self.packetBtn.hidden = YES;
    //    self.sendBtn.hidden = NO; //不显示
    self.textField.textColor = kBlackTextColor;
    [self.textField setValue:HEXCOLOR(0xC4C4C4) forKeyPath:@"placeholderLabel.textColor"];
}

- (void)normalClearStatus
{
    self.bgView.alpha = 0;
    self.bgImageView.hidden = YES;
    self.commentBgView.backgroundColor = HEXACOLOR(0xffffff, 0.4);
    self.commentBgView.layer.borderWidth = 0;
    //    self.packetBtn.hidden = NO;   //不显示
    self.sendBtn.hidden = YES;
    self.packetImgView.image = [UIImage imageNamed:@"icon_player_packet_n"];
    self.textField.textColor = [UIColor whiteColor];
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    self.bgImageView.hidden = YES;

}

- (void)normalWhiteStatus:(CGFloat)scale
{
    self.bgView.alpha = scale;
    self.commentBgView.backgroundColor = [UIColor clearColor];
    self.commentBgView.layer.borderWidth = 0.5;
    //    self.packetBtn.hidden = NO;   //不显示
    self.sendBtn.hidden = YES;
    self.packetImgView.image = [UIImage imageNamed:@"icon_player_packet_p"];
    self.textField.textColor = kBlackTextColor;
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    if (scale>=1) {
        self.bgImageView.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendBtnClick];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 140) {
        textField.text = [textField.text substringToIndex:140];
    }
    
    _canSend = YES;
    if (isNullString(textField.text)) {
        _canSend = NO;
    } else if (!isNullString(_commentNameString)) {
        NSRange range = [textField.text rangeOfString:_commentNameString];
        if (range.location == 0) {
            NSString *string = [textField.text stringByReplacingOccurrencesOfString:_commentNameString withString:@""];
            if (isNullString(string)) {
                _canSend = NO;
            }
        }
    }
}

#pragma mark - uibutton

- (void)packetBtnClick
{
    if (_touchPacket) {
        _touchPacket();
    }
}

- (void)sendBtnClick
{
    if (isNullString(_textField.text) || !_canSend) {
        return;
    }
    NSString *comment = @"";
    NSString *replayId = nil;
    if (isNullString(_commentNameString)) {
        comment = _textField.text;
    } else {
        NSRange range = [_textField.text rangeOfString:_commentNameString];
        if (range.location == 0) {
            comment = [_textField.text stringByReplacingOccurrencesOfString:_commentNameString withString:@""];
            replayId = _replyId;
        } else {
            comment = _textField.text;
        }
    }
    if (_sendComment) {
        _sendComment(comment,replayId);
    }
}

#pragma mark -

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    
    
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_bgView addSubview:effectview];
    }
    return _bgView;
}

- (UIView *)commentBgView
{
    if (!_commentBgView) {
        //        _commentBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 15 - 80, 35)];
        _commentBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 35)];// 隐藏了发送按钮，需要拉伸textField
        _commentBgView.layer.cornerRadius = 17.5;
        _commentBgView.layer.borderColor = HEXCOLOR(0xdbdbe0).CGColor;
        
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = @"评论一发";
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_commentBgView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_commentBgView.mas_left).offset(10);
            make.top.bottom.mas_equalTo(_commentBgView);
            make.right.mas_equalTo(_commentBgView.mas_right).offset(-10);
        }];
    }
    return _commentBgView;
}

- (UIButton *)packetBtn
{
    if (!_packetBtn) {
        _packetBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 55, 0, 55, 55)];
        [_packetBtn addTarget:self action:@selector(packetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _packetImgView = [[UIImageView alloc] init];
        //        _packetImgView.image = [UIImage imageNamed:@""];
        _packetImgView.userInteractionEnabled = NO;
        [_packetBtn addSubview:_packetImgView];
        
        [_packetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_packetBtn.mas_centerX);
            make.centerY.mas_equalTo(_packetBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 27));
        }];
    }
    return _packetBtn;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 55, 10, 55, 35)];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendBtn.layer.cornerRadius = 17.5;
        _sendBtn.backgroundColor = kYellowColor;
    }
    return _sendBtn;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        _bgImageView.hidden = YES;
    }
    return _bgImageView;
}

/**
 设置约束
 */
- (void)setUIconstraint {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
@end
