//
//  ZZOtherSettingCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZOtherSettingCell.h"
#import "ZZPostTaskViewModel.h"

@interface ZZOtherSettingCell () <UITextViewDelegate>

@property (nonatomic, assign) BOOL didAgree;

@property (nonatomic, assign) BOOL isAnonymous;

@end

@implementation ZZOtherSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _didAgree = YES;
        _isAnonymous = NO;
        [self layout];
    }
    return self;
}

- (void)configureData {
        
        if (_cellModel.taskType == TaskFree) {
            self.backgroundColor = UIColor.clearColor;
            
            _anonymousBtn.hidden = YES;
            
            _rulesBtn.normalTitle = nil;
            [_rulesBtn setImage:[UIImage imageNamed:@"icXuanrenWeixuanze"] forState:UIControlStateNormal];
            [_rulesBtn setImage:[UIImage imageNamed:@"icXuanren"] forState:UIControlStateSelected];
            [_rulesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10.0);
                make.centerY.equalTo(_anonymousBtn);
                make.height.equalTo(@20.0);
                make.width.equalTo(@20.0);
            }];
            [_rulesBtn setImagePosition:LXMImagePositionRight spacing:0.0];
            
            if (((NSNumber *)_cellModel.data)) {
                _didAgree = [((NSNumber *)_cellModel.data) boolValue];
            }
            [_rulesBtn setSelected:_didAgree];
            
            NSString *hightlightedStr = @"《发布规则》";
            NSRange highlightedStrRange = [_cellModel.title rangeOfString:hightlightedStr];
            if (highlightedStrRange.location == NSNotFound) {
                _rulesLabel.text = _cellModel.title;
                return;
            }
            
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:_cellModel.title];
            [mutableStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:13.0] range:NSMakeRange(0, _cellModel.title.length)];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(153, 153, 153) range:NSMakeRange(0, _cellModel.title.length)];
            [mutableStr addAttribute:NSLinkAttributeName
                                value:@"protocol://"
                                range:highlightedStrRange];
            _rulesLabel.attributedText = mutableStr.copy;
            
            [_rulesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_rulesBtn.mas_right).offset(2);
            }];
            _rulesLabel.hidden = NO;
            _rulesLabel.backgroundColor = UIColor.clearColor;
        }
        else {
            self.backgroundColor = UIColor.clearColor;
            _anonymousBtn.hidden = NO;
            
            _isAnonymous = YES;
            if (((NSNumber *)_cellModel.data)) {
                _isAnonymous = [((NSNumber *)_cellModel.data) boolValue];
            }

            if (_isAnonymous) {
                [_anonymousBtn setImage:[UIImage imageNamed:@"icXzJbwx11"] forState:UIControlStateNormal];
            }
            else {
                [_anonymousBtn setImage:[UIImage imageNamed:@"oval75Copy"] forState:UIControlStateNormal];
            }
            [_anonymousBtn setImagePosition:LXMImagePositionRight spacing:8.0];
            
            [_rulesBtn setTitle:_cellModel.title forState:UIControlStateNormal];
            [_rulesBtn setImage:[UIImage imageNamed:@"icHelpYyCopy"] forState:UIControlStateNormal];
            _rulesBtn.titleLabel.font = CustomFont(15.0);
            [_rulesBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
            [_rulesBtn setImagePosition:LXMImagePositionRight spacing:3.0];
            
            _rulesLabel.hidden = YES;
            _rulesLabel.font = CustomFont(15.0);
            _rulesLabel.textColor = RGBCOLOR(153, 153, 153);
            [_rulesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_rulesBtn.mas_right).offset(15.0);
            }];
        }
}

- (void)anonymous:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:anonymous:)]) {
        [self.delegate cell:self anonymous:!_isAnonymous];
    }
}

- (void)rules {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRules:)]) {
        [self.delegate showRules:self];
    }
}

- (void)didAgreed {
    [_rulesBtn setSelected:!_rulesBtn.selected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didAgreed:)]) {
        [self.delegate cell:self didAgreed:_rulesBtn.isSelected];
    }
}

#pragma mark - response method
- (void)rulesBtnAction {
    if (_cellModel.taskType == TaskNormal) {
        [self rules];
    }
    else {
        [self didAgreed];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"protocol"]) {
        [self rules];
    }
    return NO;
}

#pragma mark - UI
- (void)layout {
    [self.contentView addSubview:self.rulesBtn];
    [self.contentView addSubview:self.anonymousBtn];
    [self.contentView addSubview:self.rulesLabel];
    
    [_anonymousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self).offset(15.0);
//        make.bottom.equalTo(self).offset(-15.0);
        make.height.equalTo(@15.0);
    }];

    [_rulesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.centerY.equalTo(_anonymousBtn);
        make.height.equalTo(@15.0);
    }];
    
    [_rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rulesBtn);
        make.left.equalTo(_rulesBtn.mas_right).offset(15.0);
    }];
    
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_anonymousBtn setImagePosition:LXMImagePositionRight spacing:8.0];
        
    });
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UITextView *)rulesLabel {
    if (!_rulesLabel) {
        _rulesLabel = [[UITextView alloc] init];
        _rulesLabel.font = CustomFont(15.0);
        _rulesLabel.textColor = RGBCOLOR(153, 153, 153);
        _rulesLabel.editable = NO;
        _rulesLabel.scrollEnabled = NO;
        _rulesLabel.delegate = self;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rules)];
//        [_rulesLabel addGestureRecognizer:tap];
    }
    return _rulesLabel;
}

- (UIButton *)anonymousBtn {
    if (!_anonymousBtn) {
        _anonymousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_anonymousBtn addTarget:self action:@selector(anonymous:) forControlEvents:UIControlEventTouchUpInside];
        [_anonymousBtn setTitle:@"匿名发布" forState:UIControlStateNormal];
        _anonymousBtn.titleLabel.font = CustomFont(15.0);
        [_anonymousBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    }
    return _anonymousBtn;
}

- (UIButton *)rulesBtn {
    if (!_rulesBtn) {
        _rulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rulesBtn addTarget:self action:@selector(rulesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rulesBtn;
}

@end
