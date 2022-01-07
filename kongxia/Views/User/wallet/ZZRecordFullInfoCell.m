//
//  ZZRecordFullInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRecordFullInfoCell.h"
#import "ZZRecord.h"
#import "ZZMeBiRecordModel.h"

@interface ZZRecordFullInfoCell ()

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *timeLabel;//记录时间

@property (nonatomic, strong) UILabel *recordTitleLab;//作用

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZRecordFullInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)showUserInfo {
    if ([_recordMoneyModel.type isEqualToString: @"receive_gift_song"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
            [self.delegate cell:self showUserInfo:_recordMoneyModel.be_user];
        }
    }
    else if ([_recordMoneyModel.type isEqualToString:@"receive_gift"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
                [self.delegate cell:self showUserInfo:_recordMoneyModel.be_user];
            }
        }
    else if ([_mebiModel.mcoin_record[@"type"] isEqualToString:@"give_gift"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
                ZZUser *user = [[ZZUser alloc] initWithDictionary:_mebiModel.mcoin_record[@"to"] error:nil];
                [self.delegate cell:self showUserInfo:user];
            }
        }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.imgView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.recordTitleLab];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(40), AdaptedWidth(40)));
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView);
        make.left.equalTo(_imgView.mas_right).offset(6);
    }];
    
    [_recordTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).offset(1);
        make.left.equalTo(_imgView.mas_right).offset(6);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_recordTitleLab.mas_bottom).offset(2);
        make.left.equalTo(_imgView.mas_right).offset(6);
        make.bottom.equalTo(self).offset(-15.0);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    view.backgroundColor = RGBCOLOR(237, 237, 237);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - getters and setters
/**
 余额记录
 */
- (void)setRecordMoneyModel:(ZZRecord *)recordMoneyModel {
    _recordMoneyModel = recordMoneyModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",recordMoneyModel.amount];
    self.recordTitleLab.text = [NSString stringWithFormat:@"%@",recordMoneyModel.content];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",recordMoneyModel.created_at];
    
    if ([recordMoneyModel.type isEqualToString:@"receive_gift"]) {
        _userNameLabel.text = recordMoneyModel.be_user.nickname;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[recordMoneyModel.be_user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
           UIImage *roundImage = [image imageAddCornerWithRadius:AdaptedWidth(20) andSize:CGSizeMake(AdaptedWidth(40), AdaptedWidth(40))];
           self.imgView.image = roundImage;
       }];
   }
    else if ([recordMoneyModel.type isEqualToString:@"receive_gift_song"]) {
        _userNameLabel.text = recordMoneyModel.be_user.nickname;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[recordMoneyModel.be_user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:AdaptedWidth(20) andSize:CGSizeMake(AdaptedWidth(40), AdaptedWidth(40))];
            self.imgView.image = roundImage;
        }];
        
        self.recordTitleLab.text = [NSString stringWithFormat:@"点唱任务 赠送一个%@",recordMoneyModel.gift_name];
    }
}

- (void)setMebiModel:(ZZMeBiRecordModel *)mebiModel {
    _mebiModel = mebiModel;
    
    ZZUser *user = [[ZZUser alloc] initWithDictionary:mebiModel.mcoin_record[@"to"] error:nil];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@么币",mebiModel.mcoin_record[@"amount"]];
    self.recordTitleLab.text = [NSString stringWithFormat:@"%@",mebiModel.mcoin_record[@"type_text"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",mebiModel.mcoin_record[@"created_at_text"]];
 
    if ([mebiModel.mcoin_record[@"type"] isEqualToString:@"give_gift"]) {
        _userNameLabel.text = user.nickname;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:AdaptedWidth(20) andSize:CGSizeMake(AdaptedWidth(40), AdaptedWidth(40))];
            self.imgView.image = roundImage;
        }];
    }
    else if ([mebiModel.mcoin_record[@"type"] isEqualToString:@"song_gift"]) {
        // 点唱
        self.imgView.image = [UIImage imageNamed:@"icDianchangrenwu"];
        _userNameLabel.text = mebiModel.mcoin_record[@"type_text"];
        _recordTitleLab.text = [NSString stringWithFormat:@"送出%@ x%ld",mebiModel.mcoin_record[@"gift_name"], [mebiModel.mcoin_record[@"gift_count"] integerValue]];
//        self.timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTVForRecord:mebiModel.mcoin_record[@"created_at_text"]];
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = RGBCOLOR(63, 58, 58);
        _userNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _userNameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)recordTitleLab {
    if (!_recordTitleLab) {
        _recordTitleLab = [[UILabel alloc] init];
        _recordTitleLab.textColor = RGBCOLOR(102, 102, 102);
        _recordTitleLab.textAlignment = NSTextAlignmentLeft;
        _recordTitleLab.font = [UIFont boldSystemFontOfSize:13];
    }
    return _recordTitleLab;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
    }
    return _moneyLabel;
}

@end
