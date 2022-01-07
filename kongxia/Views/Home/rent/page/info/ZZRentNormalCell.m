//
//  ZZRentNormalCell.m
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentNormalCell.h"

@implementation ZZRentNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.userInteractionEnabled = NO;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:@"么么号" fontSize:15];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(titleWidth);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _contentLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        _lineView.userInteractionEnabled = NO;
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_contentLabel.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
        
        self.clipsToBounds = YES;
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPress:)];
        [_bgView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setUser:(ZZUser *)user indexPath:(NSIndexPath *)indexPath {
    _lineView.hidden = NO;
    switch (indexPath.row) {
        case 0:
            _lineView.hidden = YES;
            self.imgView.image = [UIImage imageNamed:@"icMemehaoChakanziliao"];
            self.titleLabel.text = @"么么号";
            self.contentLabel.text = user.ZWMId;
            break;
        case 1:
            self.imgView.image = [UIImage imageNamed:@"icDengjiChakanziliao"];
            _imgView.contentMode = UIViewContentModeCenter;
            self.titleLabel.text = @"等级";
            self.contentLabel.text = [NSString stringWithFormat:@"Lv.%ld",user.level];
            break;
        case 2:
            self.imgView.image = [UIImage imageNamed:@"icXingzuoChakanziliao"];
            self.titleLabel.text = @"星座";
            self.contentLabel.text = user.constellation;
            break;
        case 3:
            self.imgView.image = [UIImage imageNamed:@"icZhiyeJibenziliao"];
            self.titleLabel.text = @"职业";
            if (user.works_new.count) {
                [user.works_new enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 0) {
                        self.contentLabel.text = label.content;
                    } else {
                        self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",self.contentLabel.text,label.content];
                    }
                }];
            }
            break;
        case 4:
            self.imgView.image = [UIImage imageNamed:@"icShengaoJibenziliao"];
            self.titleLabel.text = @"身高";
            self.contentLabel.text = user.height?user.heightIn:@"未填写";
            break;
        case 5:
            self.imgView.image = [UIImage imageNamed:@"icTizhongJibenziliao"];
            self.titleLabel.text = @"体重";
            self.contentLabel.text = user.weight?user.weightIn:@"未填写";
            if (user.weight == kSecretWeight) {
                self.detailTextLabel.text = @"保密";
            }
            break;
        case 6:
            self.imgView.image = [UIImage imageNamed:@"icDangqiChakanziliao"];
            self.titleLabel.text = @"档期";
            self.contentLabel.text = user.rent.time?[user.rent.time componentsJoinedByString:@"、"]:@"无";
            break;
        case 7:
            self.imgView.image = [UIImage imageNamed:@"icChangzhudiJibenziliao"];
            self.titleLabel.text = @"常住地";
            self.contentLabel.text = user.address.city?user.address.city:@"无";
            break;
        default:
            break;
    }
}

- (void)viewLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_longPress) {
            _longPress(_bgView);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
