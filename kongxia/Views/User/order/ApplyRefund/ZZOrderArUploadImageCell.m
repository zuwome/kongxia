//
//  ZZOrderArUploadImageCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderArUploadImageCell.h"
@interface ZZOrderArUploadImageCell()
@property(nonatomic,strong) UIImageView *uploadImageView;
@property(nonatomic,strong) UILabel *uploadInstructionsLab;
@property(nonatomic,strong) UILabel *uploadLab;
@end
@implementation ZZOrderArUploadImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.uploadImageView];
        [self.contentView addSubview:self.uploadInstructionsLab];
        [self.contentView addSubview:self.uploadLab];
    }
    return self;
}
-(void)setUploadInstructions:(NSString *)uploadInstructions {
    if (_uploadInstructions != uploadInstructions) {
        _uploadInstructions = uploadInstructions;
        _uploadLab.text = uploadInstructions;
    }
}
- (UIImageView *)uploadImageView {
    if (!_uploadImageView) {
        _uploadImageView = [[UIImageView alloc]init];
       _uploadImageView.image = [UIImage imageNamed:@"icon_report_img"];
    }
    return _uploadImageView;
}
- (UILabel *)uploadInstructionsLab {
    if (!_uploadInstructionsLab) {
        _uploadInstructionsLab = [[UILabel alloc]init];
        _uploadInstructionsLab.text = @"图片证据";
        _uploadInstructionsLab.textAlignment = NSTextAlignmentLeft;
        _uploadInstructionsLab.font = CustomFont(15);
        _uploadInstructionsLab.textColor = kBlackColor;
    
    }
    return _uploadInstructionsLab;
}
- (UILabel *)uploadLab {
    if (!_uploadLab) {
        _uploadLab = [[UILabel alloc]init];
        _uploadLab.textColor = RGBCOLOR(244, 203, 7);
        _uploadLab.font = CustomFont(15);
        _uploadLab.text = @"（*必填）";
        _uploadLab.textAlignment = NSTextAlignmentLeft;
    }
    return _uploadLab;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.top.offset(18);
        make.size.mas_equalTo(CGSizeMake(16, 14.5));
        make.centerY.equalTo(self.uploadInstructionsLab.mas_centerY);
    }];
    
    [self.uploadInstructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadImageView.mas_right).offset(9.5);
        make.right.equalTo(self.uploadLab.mas_left);
    }];
    
    [self.uploadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.uploadInstructionsLab.mas_centerY);
        make.right.lessThanOrEqualTo(@(-14.5));
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
