//
//  ZZChatBoxGreetingCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatBoxGreetingCell.h"

@interface ZZChatBoxGreetingCell ()

@end

@implementation ZZChatBoxGreetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = kBGColor;
    
    [self.contentView addSubview:self.greeting];
    [self.greeting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.leading.equalTo(@15);
    }];
    
    [self.contentView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 44));
        make.leading.equalTo(self.greeting.mas_trailing);
        make.centerY.equalTo(self.greeting);
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 44));
        make.leading.equalTo(self.editBtn.mas_trailing);
        make.trailing.equalTo(self.contentView);
        make.centerY.equalTo(self.greeting);
    }];
}

- (void)setType:(GreetingType)type {
    _type = type;
    if (type == GreetingTypeNormal) {
        self.editBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    } else if (type == GreetingTypeEdit)  {
        self.editBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@44);
        }];
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@44);
        }];
    }
}

- (void)editClick {
    !self.clickEdit ? : self.clickEdit();
}

- (void)deleteClick {
    !self.clickDelete ? : self.clickDelete();
}

- (UILabel *)greeting {
    if (nil == _greeting) {
        _greeting = [[UILabel alloc] init];
        [_greeting setTextColor:kBrownishGreyColor];
        [_greeting setFont:[UIFont systemFontOfSize:14]];
    }
    return _greeting;
}

- (UIButton *)editBtn {
    if (nil == _editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setImage:[UIImage imageNamed:@"icGreetingEdit"] forState:(UIControlStateNormal)];
        [_editBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn {
    if (nil == _deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"icGreetingDelete"] forState:(UIControlStateNormal)];
        [_deleteBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
