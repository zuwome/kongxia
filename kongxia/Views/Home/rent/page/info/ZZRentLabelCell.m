//
//  ZZRentLabelCell.m
//  zuwome
//
//  Created by angBiu on 16/6/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentLabelCell.h"
#import "SKTagView.h"
#import "ZZUserLabel.h"
#import "ZZMyLocationModel.h"

@interface ZZRentLabelCell ()

@property (nonatomic, assign) LabelType  type;

@property (nonatomic, strong) ZZUser *user;

@end

@implementation ZZRentLabelCell {
    NSMutableArray *_tagArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(_imgView.mas_centerY);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        }];
        
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 15;
        _tagView.interitemSpacing = 18;
        _tagView.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
        [self.contentView addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        
        WeakSelf
        _tagView.didTapTagAtIndex = ^(NSUInteger index) {
            if (_type != LabelTypeLocation) {
                return ;
            }
            ZZMyLocationModel *model = weakSelf.user.userGooToAddress[index];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cell:showLocation:)]) {
                [weakSelf.delegate cell:weakSelf showLocation:model];
            }
        };
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
        _redPointView = [[ZZRedPointView alloc] init];
        _redPointView.backgroundColor = [UIColor redColor];
        _redPointView.hidden = YES;
        [self.contentView addSubview:_redPointView];
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-8);
            make.centerY.mas_equalTo(_arrowImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setUser:(ZZUser *)user labelType:(LabelType)tye {
    _type = tye;
    _user = user;
    if (_arrowImgView.hidden == YES) {  //他人页进入不显示箭头，所有用此做判断，设置箭头要在setUser之前才有效
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    } else {
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    }
    switch (tye) {
        case LabelTypeInterest: {
            _titleLabel.text = @"兴趣爱好";
            _imgView.image = [UIImage imageNamed:@"icXingquaihaoWo"];
            [self.tagView removeAllTags];
            //添加Tags
            if (user.interests_new.count == 0) {
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
                }];
            } else {
                [user.interests_new enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL *stop) {
                     SKTag *tag = [SKTag tagWithText:label.content];
                     tag.textColor = UIColor.whiteColor;
                     tag.bgColor = kSunYellow;
                     tag.cornerRadius = 2;
                     tag.fontSize = 12;
                     tag.textColor = kBlackTextColor;
                     tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
                     [self.tagView addTag:tag];
                 }];
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
                }];
            }
        } break;
            
        case LabelTypeLocation: {
            _titleLabel.text = @"常去地点";
            _imgView.image = [UIImage imageNamed:@"icCqdd"];
            [self.tagView removeAllTags];
            [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            }];
            if (user.userGooToAddress.count == 0) {
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
                }];
            } else {
                [user.userGooToAddress enumerateObjectsUsingBlock:^(ZZMyLocationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SKTag *tag = [SKTag tagWithText:[NSString stringWithFormat:@"%@ • %.2fKM", obj.simple_address, [obj currentDistance:[ZZUserHelper shareInstance].location]]];
                    tag.textColor = UIColor.whiteColor;
                    tag.bgColor = kSunYellow;
                    tag.cornerRadius = 2;
                    tag.fontSize = 12;
                    tag.textColor = kBlackTextColor;
                    tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
                    [self.tagView addTag:tag];
                    
                    
                }];
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
                }];
            }
        } break;
        case LabelTypePersonalLabel: {
            _titleLabel.text = @"个人标签";
            _imgView.image = [UIImage imageNamed:@"icGerenbiaoqianWo"];
            [self.tagView removeAllTags];
            [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            }];
            if (user.tags_new.count == 0) {
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
                }];
            } else {
                [user.tags_new enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL *stop) {
                     SKTag *tag = [SKTag tagWithText:label.content];
                     tag.textColor = UIColor.whiteColor;
                     tag.bgColor = kSunYellow;
                     tag.cornerRadius = 2;
                     tag.fontSize = 12;
                     tag.textColor = kBlackTextColor;
                     tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
                     [self.tagView addTag:tag];
                 }];
                [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
                }];
            }
        } break;
        default: break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
