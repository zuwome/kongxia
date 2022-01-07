//
//  ZZRealNameNotMainlandInputCell.m
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRealNameNotMainlandInputCell.h"

@interface ZZRealNameNotMainlandInputCell() <UITextFieldDelegate>
@end
@implementation ZZRealNameNotMainlandInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
            make.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath model:(ZZRealname *)model
{
    _lineView.hidden = NO;
    _arrowImgView.hidden = YES;
    _textField.userInteractionEnabled = YES;
    switch (indexPath.row) {
        case 0:
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            _titleLabel.text = @"真实姓名";
            _textField.placeholder = @"NAME";
            _textField.text = model.name;
        }
            break;
        case 1:
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            _titleLabel.text = @"证件号码";
            _textField.placeholder = @"NUMBER";
            _textField.text = model.code;
        }
            break;
        case 2:
        {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            _titleLabel.text = @"出生日期";
            _textField.placeholder = @"BIRTHDAY";
            _lineView.hidden = YES;
            _arrowImgView.hidden = NO;
            _textField.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
    
    CGFloat width = [ZZUtils widthForCellWithText:_titleLabel.text fontSize:15];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
