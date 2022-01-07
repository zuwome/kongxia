//
//  ZZFastChatTextCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastChatTextCell.h"

@interface ZZFastChatTextCell ()

@property (nonatomic, strong) UILabel *leftLabel;//主要标题
@property (nonatomic, strong) UIView *py_BackgroundView;//背景
@property (nonatomic,strong) UILabel *promptLable;//提示

@end

@implementation ZZFastChatTextCell

+ (NSString *)reuseIdentifier {
    return @"ZZFastChatTextCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZFastChatTextCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZFastChatTextCell);
    }
    return self;
}

commonInitImplementationSafe(ZZFastChatTextCell) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self.contentView addSubview:self.py_BackgroundView];
    [self.contentView addSubview:self.promptLable];
    
    self.leftLabel = [UILabel new];
    self.leftLabel.textColor = kBlackColor;
    self.leftLabel.font = [UIFont systemFontOfSize:15];

    self.rightLabel = [UILabel new];
    self.rightLabel.textColor = RGBCOLOR(173, 173, 177);
    self.rightLabel.font = [UIFont systemFontOfSize:15];

    UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_fast_right"]];
    
    [self.py_BackgroundView addSubview:self.leftLabel];
    [self.py_BackgroundView addSubview:self.rightLabel];
    [self.py_BackgroundView addSubview:rightImage];

    [self.py_BackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(AdaptedHeight(54));
    }];

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.centerY.equalTo(self.py_BackgroundView.mas_centerY);
        make.width.equalTo(@120);
    }];
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.centerY.equalTo(self.py_BackgroundView.mas_centerY);
        make.width.equalTo(@8);
        make.height.equalTo(@16);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(rightImage.mas_leading).offset(-10);
        make.centerY.equalTo(rightImage.mas_centerY);
    }];
    
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.py_BackgroundView.mas_bottom);
        make.height.mas_equalTo(AdaptedHeight(32));
    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Private methods

- (void)setupWithModel:(ZZUser *)model indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
            }
                break;
            case 1:
            {
                self.leftLabel.text = @"设置开始时间段";
                self.promptLable.text = @"设置出现在闪聊列表中的时间段";
            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
            {
                self.leftLabel.text = @"通话记录";
                self.promptLable.text = nil;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 懒加载
- (UIView *)py_BackgroundView {
    if (!_py_BackgroundView) {
        _py_BackgroundView = [[UIView alloc]init];;
        _py_BackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _py_BackgroundView;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc]init];
        _promptLable.backgroundColor =  HEXCOLOR(0xf5f5f5);
        _promptLable.textAlignment = NSTextAlignmentLeft;
        _promptLable.textColor = RGBCOLOR(171, 171, 171);
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        if (fontFirst ==nil) {
            _promptLable.font = [UIFont systemFontOfSize:13];
        }else{
        _promptLable.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        }
    }
    return _promptLable;
}
@end
