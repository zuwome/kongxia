//
//  ZZUploadWarningTableViewCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/7/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZUploadWarningTableViewCell.h"

@interface ZZUploadWarningTableViewCell ()

@property (nonatomic, strong) UIImageView *warningIcon;

@property (nonatomic, strong) UILabel *warningLabel;

@end

@implementation ZZUploadWarningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.warningIcon];
    [self addSubview:self.warningLabel];
    
    [_warningIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(25, 13));
    }];
    
    [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_warningIcon.mas_right).offset(5);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)warningIcon {
    if (!_warningIcon) {
        _warningIcon = [[UIImageView alloc] init];
        _warningIcon.image = [UIImage imageNamed:@"icTip"];
    }
    return _warningIcon;
}

- (UILabel *)warningLabel {
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _warningLabel.textColor = RGBCOLOR(102, 102, 102);
        _warningLabel.numberOfLines = 0;
        _warningLabel.text = @"亲爱的用户，您上传的头像和文字信息须遵守相关法律和社区规则，审核通过后才能生效，审核结果将会通过系统消息通知您";
    }
    return _warningLabel;
}

@end
