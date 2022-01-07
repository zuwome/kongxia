//
//  ZZSkillEditInputCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditInputCell.h"

@interface ZZSkillEditInputCell () <UITextFieldDelegate>

@end

@implementation ZZSkillEditInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCellType:(SkillEditCellType)cellType {
    super.cellType = cellType;
    [self createView];
}

- (void)setShowEditIcon:(BOOL)showEditIcon {
    [super setShowEditIcon:showEditIcon];
    self.editIcon.hidden = !showEditIcon;
}

- (void)setInputTextColor:(UIColor *)inputTextColor {
    [super setInputTextColor:inputTextColor];
    [self.input setTextColor:inputTextColor];
}

- (void)setInputTextFont:(UIFont *)inputTextFont {
    [super setInputTextFont:inputTextFont];
    [self.input setFont:inputTextFont];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    super.topicModel = topicModel;
    ZZSkill *skill = topicModel.skills[0];
    if (self.cellType != InputCellTypePrice) {
        [self.input setText:skill.name];
    } else {
        if ([skill.price integerValue] > 0) {
            [self.input setText:[NSString stringWithFormat:@"%@元 / 小时",skill.price]];
        }
        [self.tipLabel setText:[self getPriceTip]];
    }
}

- (NSString *)getPriceTip {
    ZZSkill *skill = self.topicModel.skills[0];
    NSInteger price = [skill.price integerValue];
    if (price >= 0 && price <= 200)
        return @"";
    else if (price > 200 && price <= 300)
        return @"建议价格调低一些，受欢迎的价格成交率更高哦";
    else if (price > 300)
        return @"最多不超过300元/小时";
    return @"";
}

- (void)createView {
    [self.contentView addSubview:self.input];
    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.height.equalTo(@20);
        if (self.cellType != InputCellTypePrice)
            make.bottom.equalTo(@-15);
    }];
    [self.contentView addSubview:self.editIcon];
    [self.editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.cellType == InputCellTypeCustomTheme || self.cellType == InputCellTypeSystemTheme) {
            make.size.mas_equalTo(CGSizeMake(50, 16));
        }
        else {
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }
        
        make.trailing.equalTo(@-15);
        make.centerY.equalTo(self.input);
        make.leading.equalTo(self.input.mas_trailing).offset(5);
    }];
    
    if (self.cellType == InputCellTypePrice) {
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.input.mas_bottom).offset(10);
            make.leading.equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 15));
            make.bottom.equalTo(@-10);
        }];
    }
    
    switch (self.cellType) {
        case InputCellTypeSystemTheme: {
            self.input.userInteractionEnabled = NO;
            [self.editIcon setTitle:@"" forState:UIControlStateNormal];
            self.editIcon.normalImage = [UIImage imageNamed:@"icEditIcon"];
        }
        case InputCellTypeCustomTheme: {
            self.tipLabel.hidden = YES;
            self.tipLabel.text = @"";
            self.input.placeholder = @"输入主题名称";
            self.input.keyboardType = UIKeyboardTypeDefault;
            
            
            
            [self.editIcon setTitle:@"去更改" forState:UIControlStateNormal];
            [self.editIcon setTitleColor:RGBCOLOR(190, 190, 190) forState:UIControlStateNormal];
            self.editIcon.normalImage = [UIImage imageNamed:@"icon_report_right"];
            [self.editIcon setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.editIcon.imageView.size.width - 2, 0, self.editIcon.imageView.size.width + 2)];
            [self.editIcon setImageEdgeInsets:UIEdgeInsetsMake(0, self.editIcon.titleLabel.bounds.size.width + 2, 0, -self.editIcon.titleLabel.bounds.size.width - 2)];
        } break;
        case InputCellTypePrice: {
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"价格提示";
            self.input.placeholder = @"￥最受欢迎的价格区间为100-200元/小时";
            self.input.keyboardType = UIKeyboardTypeNumberPad;
            
            [self.editIcon setTitle:@"" forState:UIControlStateNormal];
            self.editIcon.normalImage = [UIImage imageNamed:@"icEditIcon"];
        } break;
        default: break;
    }
}

#pragma mark -- textfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.cellType == InputCellTypePrice) { //价格输入栏只能输入数字或撤回
        if (![string integerValue] && ![string isEqualToString:@""] && [string integerValue] != 0) {
            return NO;
        } else {
            return YES;
        }
    } else {
        if (textField.text.length >= 4 && ![string isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text hasSuffix:@"元 / 小时"]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"元 / 小时" withString:@""];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text hasSuffix:@"元 / 小时"] && ![textField.text isEqualToString:@""]) {
        textField.text = [textField.text stringByAppendingString:@"元 / 小时"];
    }
}

- (void)textfieldValueChanged {
    self.isUpdated = YES;   //更新修改标记
    if (self.cellType == InputCellTypePrice) {
        NSInteger price = [self.input.text integerValue];
        NSString *priceStr = [NSString stringWithFormat:@"%ld",price];
        if (![priceStr isEqualToString:self.input.text]) {
            self.input.text = [priceStr isEqualToString:@"0"] ? @"" : priceStr;
        }
        ZZSkill *skill = self.topicModel.skills[0];
        skill.price = priceStr;
        self.topicModel.price = priceStr;
        [self.tipLabel setText:[self getPriceTip]];
    }
}

- (void)startEdit {
    [self.input becomeFirstResponder];
}

#pragma mark -- lazy load
- (UITextField *)input {
    if (nil == _input) {
        _input = [[UITextField alloc] init];
        _input.delegate = self;
        _input.font = [UIFont systemFontOfSize:15];
        _input.textColor = [UIColor blackColor];
        [_input addTarget:self action:@selector(textfieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _input;
}

- (UIButton *)editIcon {
    if (nil == _editIcon) {
        _editIcon = [[UIButton alloc] init];
        [_editIcon setImage:[UIImage imageNamed:@"icEditIcon"] forState:(UIControlStateNormal)];
        _editIcon.hidden = YES;
        [_editIcon addTarget:self action:@selector(startEdit) forControlEvents:(UIControlEventTouchUpInside)];
        _editIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _editIcon;
}

- (UILabel *)tipLabel {
    if (nil == _tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _tipLabel;
}

@end
