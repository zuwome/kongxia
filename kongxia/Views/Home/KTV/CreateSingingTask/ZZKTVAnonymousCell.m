//
//  ZZKTVAnonymousCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVAnonymousCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVAnonymousCell ()

@property (nonatomic, strong) UIButton *anonymousBtn;

@end

@implementation ZZKTVAnonymousCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - public Method
- (void)configureKTVModel:(ZZKTVModel *)model {
    _anonymousBtn.selected = model.is_anonymous == 2 ? YES : NO;
}


#pragma mark - response method
- (void)anonymous:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:anonymous:)]) {
        [self.delegate cell:self anonymous:sender.selected];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.anonymousBtn];
    [_anonymousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@22.0);
    }];
    
    [_anonymousBtn setImagePosition:LXMImagePositionRight spacing:8];
}


#pragma mark - getters and setters
- (UIButton *)anonymousBtn {
    if (!_anonymousBtn) {
        _anonymousBtn = [[UIButton alloc] init];
        [_anonymousBtn addTarget:self action:@selector(anonymous:) forControlEvents:UIControlEventTouchUpInside];
        [_anonymousBtn setTitle:@"匿名发起" forState:UIControlStateNormal];
        _anonymousBtn.titleLabel.font = ADaptedFontMediumSize(15);
        [_anonymousBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        
        [_anonymousBtn setImage:[UIImage imageNamed:@"icXzJbwx11"]
                       forState:UIControlStateSelected];
        
        [_anonymousBtn setImage:[UIImage imageNamed:@"oval75Copy_black"]
                       forState:UIControlStateNormal];
    }
    return _anonymousBtn;
}

@end
