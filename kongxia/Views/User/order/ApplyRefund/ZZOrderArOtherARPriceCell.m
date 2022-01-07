//
//  ZZOrderArOtherARPriceCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderArOtherARPriceCell.h"
@interface ZZOrderArOtherARPriceCell()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *otherLab;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *lineView;

@end

@implementation ZZOrderArOtherARPriceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.otherLab];
        [self.bgView addSubview:self.button];
        [self.bgView addSubview:self.textView];
        [self.bgView addSubview:self.numberLab];

        [self.button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UILabel *)otherLab {
    if (!_otherLab) {
        _otherLab = [[UILabel alloc]init];
        _otherLab.text = @"其他";
        _otherLab.textColor = kBlackColor;
        _otherLab.textAlignment = NSTextAlignmentLeft;
        _otherLab.font = CustomFont(15);
    }
    return _otherLab;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = kBlackColor;
//        _textView.editable = NO;
        _textView.font = CustomFont(13);
        _textView.backgroundColor = HEXCOLOR(0xF5F5F5);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.placeholder = @"请输入退款原因";
        _textView.delegate = self;
        _textView.layer.cornerRadius = 3;
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 18, 0);

    }
    return _textView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _lineView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.offset(0);
        make.height.equalTo(@0.5);
    }];
    [self.otherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.equalTo(self.button.mas_left);
        make.top.offset(15);
        make.height.equalTo(@25);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.height.equalTo(@50);
        make.width.equalTo(self.button.mas_height);
        make.centerY.equalTo(self.otherLab.mas_centerY);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherLab.mas_bottom).offset(10);
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.bottom.offset(0);
    }];
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView.mas_bottom).offset(-3);
        make.right.offset(-18);
    }];
}
- (void)click {
    if (!self.button.selected) {
        [_textView becomeFirstResponder];
    }
    else{
        [_textView resignFirstResponder];
        self.button.selected = !self.button.selected;
        if (self.selecetBlock) {
            self.selecetBlock(self);
        }
    }
    
}

#pragma mark - UITextViewMethod

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.button.selected = YES;
    if (self.selecetBlock) {
        self.selecetBlock(self);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
static const NSInteger Max_Num_TextView = 200;
- (void)textViewDidChange:(UITextView *)textView
{
    //获取当前键盘类型
    UITextInputMode *mode = (UITextInputMode *)[UITextInputMode activeInputModes][0];
    //获取当前键盘语言
    NSString *lang = mode.primaryLanguage;
    //如果语言是汉语(拼音)
    if ([lang isEqualToString:@"zh-Hans"])
    {
        //取到高亮部分范围
        UITextRange *selectedRange = [textView markedTextRange];
        //取到高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //如果取不到高亮部分,代表没有拼音
        if (!position){
            //当期超过最大限制时
            if (textView.text.length > Max_Num_TextView) {
                _numberLab.text = [NSString stringWithFormat:@"%ld/200",Max_Num_TextView];
                textView.text = [textView.text substringToIndex:Max_Num_TextView];
            }else{
                _numberLab.text = [NSString stringWithFormat:@"%ld/200",(long)textView.text.length];
            }
        }
    }
    else
    {
        //如果语言不是汉语,直接计算
        if (  textView.text.length > Max_Num_TextView) {
            textView.text = [textView.text substringToIndex:Max_Num_TextView];
            _numberLab.text = [NSString stringWithFormat:@"%ld/200",Max_Num_TextView];
        }else{
            _numberLab.text = [NSString stringWithFormat:@"%ld/200",(long)textView.text.length];
        }
    }
}
- (UILabel *)numberLab {
    if (!_numberLab) {
        _numberLab = [[UILabel alloc]init];
        _numberLab.text= @"0/200";
        _numberLab.textColor = HEXCOLOR(0x858585);
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.font = CustomFont(10);
    }
    return _numberLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
