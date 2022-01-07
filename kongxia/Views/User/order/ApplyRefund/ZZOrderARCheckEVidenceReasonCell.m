//
//  ZZOrderARCheckEVidenceReasonCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARCheckEVidenceReasonCell.h"
@interface ZZOrderARCheckEVidenceReasonCell()
@property (nonatomic,strong ) UILabel *reasonTitleLab;
@end
@implementation ZZOrderARCheckEVidenceReasonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.lab];
        [self.contentView addSubview:self.reasonTitleLab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(14.5);
            make.width.equalTo(@80);
            make.height.equalTo(@21);
        }];
        
        [self.reasonTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lab.mas_right);
            make.top.offset(15);
            make.right.offset(-14.5);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(14.5);
            make.right.offset(-14.5);
            make.bottom.offset(0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setShowTitle:(NSString *)title detailTitle:(NSString *)detailTitle dataArray:(NSArray*)array viewController:(UIViewController *)viewController {
    [super setShowTitle:title detailTitle:detailTitle dataArray:array viewController:viewController];
    self.reasonTitleLab.text = detailTitle;
    self.lab.text = title;
    [self.reasonTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(-10);
    }];
}


-(UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc]init];
        _lab.text = @"退款理由:";
        _lab.textAlignment = NSTextAlignmentLeft;
        _lab.textColor = kBlackColor;
        _lab.font = ADaptedFontBoldSize(15);
    }
    return _lab;
}

- (UILabel *)reasonTitleLab {
    if (!_reasonTitleLab) {
        _reasonTitleLab = [[UILabel alloc]init];
        _reasonTitleLab.textColor = kBlackColor;
        _reasonTitleLab.textAlignment = NSTextAlignmentLeft;
        _reasonTitleLab.font = CustomFont(15);
        _reasonTitleLab.numberOfLines = 0;
    }
    return _reasonTitleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
