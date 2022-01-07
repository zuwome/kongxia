//
//  ZZPostFreeDefaultCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostFreeDefaultCell.h"
#import "ZZPostTaskViewModel.h"

@interface ZZPostFreeDefaultCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZPostFreeDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.accessoryType = _cellModel.accessoryType;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (_cellModel.type) {
        case postLocation: {
            _iconImageView.image = [UIImage imageNamed:@"icJutiweizhi"];
            _titleLabel.text = _cellModel.title;
            
            NSString *location = (NSString *)_cellModel.data;
            if (!isNullString(location)) {
                _subTitleLabel.text = location;
            }
            else {
                _subTitleLabel.text = _cellModel.subTitle;
            }
            break;
        }
        case postTime: {
            _iconImageView.image = [UIImage imageNamed:@"icHuodongshijian"];
            _titleLabel.text = _cellModel.title;
            
            NSString *time = (NSString *)_cellModel.data;
            if (!isNullString(time)) {
                _subTitleLabel.text = time;
            }
            else {
                _subTitleLabel.text = _cellModel.subTitle;
            }
            break;
        }
        default: {
            
            break;
        }
    }
}

#pragma mark - UI
- (void)layout {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.line];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(32);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(8);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(_iconImageView.mas_bottom).offset(17.0);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
        make.left.equalTo(self).offset(15.0);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.image = [UIImage imageNamed:@"icYundong"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.0];
        _subTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _subTitleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}


@end
