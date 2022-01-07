//
//  ZZSkillEditIntroduceCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditIntroduceCell.h"
#import "ZZSignEditDialogView.h"

#define CharactorCountLimit 200

@interface ZZSkillEditIntroduceCell () <UITextViewDelegate>

@property (nonatomic, strong) ZZSignEditDialogView *dialog;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextView *introduceText;
@property (nonatomic, strong) UIButton *tipButton;
@property (nonatomic, strong) UILabel *charCountLabel;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ZZSkillEditIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *responseView;
    if (self.hidden == true || self.alpha == 0) {
        return responseView;
    }
    for (UIView *subview in self.contentView.subviews) {
        CGPoint subPoint = [subview convertPoint:point fromView:self.contentView];
        responseView = [subview hitTest:subPoint withEvent:event];
        if (responseView) {
            break;
        }
    }
    return responseView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createView {
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.centerY.equalTo(self.title);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.leading.equalTo(self.title.mas_trailing).offset(10);
    }];
    [self.contentView addSubview:self.introduceText];
    [self.introduceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.top.equalTo(self.title.mas_bottom).offset(10);
        make.height.equalTo(@90);
    }];
    [self.contentView addSubview:self.tipButton];
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introduceText.mas_bottom).offset(10);
        make.leading.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(95, 20));
        make.bottom.equalTo(@-10);
    }];
    [self.contentView addSubview:self.charCountLabel];
    [self.charCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introduceText.mas_bottom).offset(10);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    [self.contentView addSubview:self.dialog];
    [self.dialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipButton.mas_bottom);
        make.leading.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(dialogWidth, dialogHeight));
    }];
    
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_rightBtn.imageView.size.width - 2, 0, _rightBtn.imageView.size.width + 2)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _rightBtn.titleLabel.bounds.size.width + 2, 0, -_rightBtn.titleLabel.bounds.size.width - 2)];
}

- (void)showTipClick {
    if (self.dialog.hidden == YES) {
        [self.dialog dialogShow];
    } else {
        [self.dialog dialogHide];
    }
    !self.showIntroduceDialog ? : self.showIntroduceDialog();
}

- (void)hideDialog {
    if (self.dialog.hidden == NO) {
        [self.dialog dialogHide];
    }
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    super.topicModel = topicModel;
    ZZSkill *skill = topicModel.skills[0];
    [self.introduceText setText:skill.detail.content];
    [self.charCountLabel setText:[NSString stringWithFormat:@"%ld/%d",skill.detail.content.length,CharactorCountLimit]];
    self.dialog.sid = skill.pid;    //此处传pid，即主题id
}

#pragma mark -- uitextviewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.isUpdated = YES;   //更新修改标记
    [ZZSkillThemesHelper shareInstance].introduceUpdate = YES;
    if (textView.text.length > CharactorCountLimit) {
        textView.text = [textView.text substringToIndex:CharactorCountLimit];
    }
    ZZSkill *skill = self.topicModel.skills[0];
    skill.detail.content = textView.text;
    [self.charCountLabel setText:[NSString stringWithFormat:@"%ld/%d",skill.detail.content.length,CharactorCountLimit]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    !self.beginEditIntroduce ? : self.beginEditIntroduce();
}

#pragma mark -- lazy load
- (ZZSignEditDialogView *)dialog {
    if (nil == _dialog) {
        _dialog = [[ZZSignEditDialogView alloc] init];
    }
    return _dialog;
}
- (UILabel *)title {
    if (nil == _title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.text = @"文字介绍";
    }
    return _title;
}
- (UITextView *)introduceText {
    if (nil == _introduceText) {
        _introduceText = [[UITextView alloc] init];
        _introduceText.font = [UIFont systemFontOfSize:14];
        _introduceText.placeholder = @"可以介绍你擅长或热爱的领域，或取得的小成就，可以为他人提供哪些帮助？";
        _introduceText.backgroundColor = RGBCOLOR(251, 251, 251);
        _introduceText.delegate = self;
    }
    return _introduceText;
}
- (UIButton *)tipButton {
    if (nil == _tipButton) {
        _tipButton = [[UIButton alloc] init];
        [_tipButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)]];
        [_tipButton addTarget:self action:@selector(showTipClick) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *tipStr = @"看看别人怎么写";
        NSDictionary *touchAttribute = @{NSForegroundColorAttributeName:RGBCOLOR(74, 144, 226),
                                         NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        NSMutableAttributedString *attrTipStr = [[NSMutableAttributedString alloc] initWithString:tipStr];
        [attrTipStr setAttributes:touchAttribute range:NSMakeRange(0, tipStr.length)];
        [_tipButton setAttributedTitle:attrTipStr forState:UIControlStateNormal];
    }
    return _tipButton;
}
- (UILabel *)charCountLabel {
    if (nil == _charCountLabel) {
        _charCountLabel = [[UILabel alloc] init];
        [_charCountLabel setFont:[UIFont systemFontOfSize:13]];
        [_charCountLabel setTextColor:HEXCOLOR(0xbebebe)];
        [_charCountLabel setTextAlignment:(NSTextAlignmentCenter)];
    }
    return _charCountLabel;
}
- (UIButton *)rightBtn {
    if (nil == _rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setTitle:@"去填写" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:RGBCOLOR(190, 190, 190) forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_report_right"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
