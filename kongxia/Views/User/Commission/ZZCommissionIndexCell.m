//
//  ZZCommissionIndexCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionIndexCell.h"
#import "ZZCommissionModel.h"

@interface ZZCommissionIndexCell ()

@property (nonatomic, strong) UIView *contextView;

@property (nonatomic, copy) NSArray<UILabel *> *noLabelArr;

@property (nonatomic, copy) NSArray<UILabel *> *ruleLabelArr;

@property (nonatomic, strong) UILabel *bottomTitleLabel;

@end

@implementation ZZCommissionIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configure {

    __block UIView *view = nil;
    [_commissionModel.tip_b.top_arr enumerateObjectsUsingBlock:^(NSString * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UILabel *noLabel = [self createNoLabel:idx + 1];
        [_contextView addSubview:noLabel];
        
        UILabel *ruleLabel = [self createRulesLabel];
        ruleLabel.text = rule;
        if (idx < _commissionModel.tip_b.top_arr_color.count) {
            NSString *coloredTitle = _commissionModel.tip_b.top_arr_color[idx];
            NSRange range = [rule rangeOfString:coloredTitle];
            if (range.location != NSNotFound) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:rule];
                [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(63, 58, 58) range:NSMakeRange(0, rule.length)];
                [attributedString addAttribute:NSFontAttributeName
                                         value:[UIFont fontWithName:@"PingFangSC-Medium" size:15.0]
                range: NSMakeRange(0, rule.length)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(242, 132, 77) range:range];
                ruleLabel.attributedText = attributedString.copy;
            }
        }
        
        [_contextView addSubview:ruleLabel];
        
        [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contextView).offset(44.0);
            make.right.equalTo(_contextView).offset(-15.0);
            if (view) {
                make.top.equalTo(view.mas_bottom).offset(12);
            }
            else {
                make.top.equalTo(_contextView).offset(28);
            }
        }];
        
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ruleLabel.mas_left).offset(-8);
            make.top.equalTo(ruleLabel);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
        
        view = ruleLabel;
    }];
    
    _bottomTitleLabel.text = _commissionModel.tip.botttom_tip.firstObject;
    
    if (view) {
        [_bottomTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(20);
            make.left.equalTo(_contextView).offset(44.0);
            make.right.equalTo(_contextView).offset(-15.0);
            make.bottom.equalTo(_contextView).offset(-28);
        }];
    }
    
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.contextView];
    [_contextView addSubview:self.bottomTitleLabel];
    
    [_contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];

//    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_contextView.mas_bottom).offset(20);
//        make.left.equalTo(_contextView).offset(20.0);
//        make.right.equalTo(_contextView).offset(-20.0);
//        make.bottom.equalTo(_contextView).offset(-24);
//    }];
}

- (UILabel *)createNoLabel:(NSInteger)index {
    UILabel *noLabel = [[UILabel alloc] init];
    noLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
    noLabel.textColor = UIColor.whiteColor;
    noLabel.numberOfLines = 1;
    noLabel.backgroundColor = RGBCOLOR(242, 132, 77);
    noLabel.layer.cornerRadius = 21 / 2;
    noLabel.layer.masksToBounds = YES;
    noLabel.textAlignment = NSTextAlignmentCenter;
    noLabel.text = [NSString stringWithFormat:@"%02ld",(long)index];
    return noLabel;
}

- (UILabel *)createRulesLabel {
    UILabel *ruleLabel = [[UILabel alloc] init];
    ruleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
    ruleLabel.numberOfLines = 0;
    ruleLabel.textColor = RGBCOLOR(63, 58, 58);
    return ruleLabel;
}


#pragma mark - getters and setters
- (void)setCommissionModel:(ZZCommissionModel *)commissionModel {
    _commissionModel = commissionModel;
    [self configure];
}

- (UIView *)contextView {
    if (!_contextView) {
        _contextView = [[UIView alloc] init];
        _contextView.backgroundColor = UIColor.whiteColor;
        _contextView.layer.cornerRadius = 10.0;
    }
    return _contextView;
}

- (UILabel *)bottomTitleLabel {
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [[UILabel alloc] init];
        _bottomTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
        _bottomTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _bottomTitleLabel.numberOfLines = 0;
    }
    return _bottomTitleLabel;
}


@end
