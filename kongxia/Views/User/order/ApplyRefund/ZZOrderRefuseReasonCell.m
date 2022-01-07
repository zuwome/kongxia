//
//  ZZOrderRefuseReasonCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderRefuseReasonCell.h"
@interface ZZOrderRefuseReasonCell()<UITextViewDelegate>
@property(nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UIView *bgView;

@end
@implementation ZZOrderRefuseReasonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self.contentView addSubview:self.bgView];

    [self.bgView addSubview:self.currentTitleLab];
    [self.bgView addSubview:self.topLineView];
    [self.bgView addSubview:self.button];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.numberLab];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.button.selected = YES;
    if (self.selecetBlock) {
        self.selecetBlock(self);
    }
    return YES;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = kBlackColor;
        _textView.font = CustomFont(13);
        _textView.backgroundColor = HEXCOLOR(0xF5F5F5);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.placeholder = @"请输入拒绝原因";
        _textView.delegate = self;
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 18, 0);
        _textView.layer.cornerRadius = 3;
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

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _topLineView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.offset(0);
        make.height.equalTo(@0.5);
    }];
    [self.currentTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.equalTo(self.button.mas_left);
        make.top.offset(14);
    
    }];
    
  
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTitleLab.mas_centerY);
        make.width.equalTo(@50);
        make.right.offset(0);
        make.width.equalTo(self.button.mas_height);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentTitleLab.mas_bottom).offset(15);
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.bottom.offset(-15);
    }];
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.right.offset(-14.5);
    }];
}
- (void)click:(UIButton *)sender {
    if (sender.selected) {
        [_textView resignFirstResponder];

    }else{
        [self.textView becomeFirstResponder];
    }
    sender.selected = !sender.selected;
    if (self.selecetBlock) {
        self.selecetBlock(self);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
