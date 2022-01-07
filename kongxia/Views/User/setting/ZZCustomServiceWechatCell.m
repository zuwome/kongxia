//
//  ZZCustomServiceWechatCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCustomServiceWechatCell.h"
#import <Masonry.h>
@interface ZZCustomServiceWechatCell ()

@end

@implementation ZZCustomServiceWechatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)paste {
    if (isNullString(_subTitleLable.text)) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_subTitleLable.text];
    [ZZHUD showTaskInfoWithStatus:@"复制成功，前往微信添加"];
}

- (void)layout {
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.subTitleLable];
    [self.contentView addSubview:self.pasteButton];
    [self.contentView addSubview:self.lineView];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(55.0, 28.0));
    }];
    
    [_subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pasteButton.mas_left).offset(-10.0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Getter&Setter
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.text = @"尊享客服微信";
        _titleLable.textColor = kBlackTextColor;
    }
    return _titleLable;
}

- (UILabel *)subTitleLable {
    if (!_subTitleLable) {
        _subTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLable.font = [UIFont systemFontOfSize:15];
        _subTitleLable.textColor = kBlackTextColor;
        _subTitleLable.textAlignment = NSTextAlignmentRight;
    }
    return _subTitleLable;
}

- (UIButton *)pasteButton {
    if (!_pasteButton) {
        _pasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pasteButton setTitle:@"复制" forState:UIControlStateNormal];
        [_pasteButton setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _pasteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pasteButton addTarget:self action:@selector(paste) forControlEvents:UIControlEventTouchUpInside];
        
        _pasteButton.layer.borderColor = RGBCOLOR(204, 204, 204).CGColor;
        _pasteButton.layer.borderWidth = 1.0;
        _pasteButton.layer.cornerRadius = 14.0;
    }
    return _pasteButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
    }
    return _lineView;
}

@end
