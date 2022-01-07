//
//  ZZSnatchOrderCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchOrderCell.h"

@interface ZZSnatchOrderCell ()

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ZZSnatchOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = kBGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.shadowView = [UIView new];
        self.shadowView.backgroundColor = kBGColor;
        _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
        _shadowView.layer.shadowOpacity = 0.5;//不透明度
        _shadowView.layer.shadowRadius = 2.0f;
        _shadowView.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:self.shadowView];
        
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@(-5));
            make.top.equalTo(@0);
            make.bottom.equalTo(@(-5));
        }];
        
        UIView *bgWhiteView = [UIView new];
        bgWhiteView.backgroundColor = [UIColor whiteColor];
        bgWhiteView.layer.masksToBounds = YES;
        bgWhiteView.layer.cornerRadius = 3.0f;
        
        [self.contentView addSubview:bgWhiteView];
        [bgWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@(-5));
            make.top.equalTo(@0);
            make.bottom.equalTo(@(-5));
        }];

//        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//        grayView.backgroundColor = kBGColor;
//        [self.contentView addSubview:grayView];
        
        self.headImgView.hidden = NO;
        self.nameLabel.text = @"哈哈哈";
        self.sexImgView.gender = 1;
        self.identifierImgView.hidden = NO;
        [self.levelImgView setLevel:80];
        self.typeLabel.text = @"1V1视频";
        self.cycleView.hidden = NO;
        self.endLabel.hidden = YES;
        self.lineView.hidden = NO;
        self.priceLabel.text = @"10元起 ( 124元/时 )";
        self.countDownView.hidden = NO;
        
        [self addNotification];
    }
    
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetStatus) name:OrderTimeCountNotification object:nil];
}

- (void)setData:(ZZSnatchReceiveModel *)model {
    _model = model;
    
    ZZUser *user = model.pd_receive.pd.from;
    if (model.pd_receive.remain_time_receiver == 0) {//如果时间为0，则设置为已被抢
        user.avatar = @"http://img.zuwome.com/anonymous_avatar1.png";
        model.pd_receive.pd.is_anonymous = 2;
    }
    [self.headImgView setUser:user width:49 vWidth:10];
    self.nameLabel.text = user.nickname;
    self.sexImgView.gender = user.gender;
    if ([ZZUtils isIdentifierAuthority:user]) {
        self.identifierImgView.hidden = NO;
        [self.levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5+19+5);
        }];
    } else {
        self.identifierImgView.hidden = YES;
        [self.levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
        }];
    }
    [self.levelImgView setLevel:user.level];
    
    if (_model.pd_receive.status == 0) {
        _cycleView.isColor = NO;
    } else if (_model.pd_receive.status == 1) {
        _cycleView.isColor = YES;
    }
    self.priceLabel.text = model.pd_receive.price_text;
    [self resetStatus];

    // 匿名用户不显示 实名和等级
    if (model.pd_receive.pd.is_anonymous == 2 || model.pd_receive.remain_time_receiver == 0) {
        self.levelImgView.hidden = YES;
        self.identifierImgView.hidden = YES;
    }
    
    self.shadowView.backgroundColor = kBGColor;
    _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
    _shadowView.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
    _shadowView.layer.shadowOpacity = 0.5;//不透明度
    _shadowView.layer.shadowRadius = 2.0f;
    _shadowView.layer.cornerRadius = 3.0f;
}

- (void)resetStatus {
    
    if (_model.pd_receive.status == 2 || _model.pd_receive.remain_time_receiver
         == 0) {
        _cycleView.hidden = YES;
        _countDownView.hidden = YES;
        _endLabel.hidden = NO;
        _snatchBtn.enabled = NO;
        self.userInteractionEnabled = NO;

    } else {
        _cycleView.hidden = NO;
        _countDownView.hidden = NO;
        _endLabel.hidden = YES;
        _snatchBtn.enabled = YES;
        self.userInteractionEnabled = YES;
//        CGFloat scale = _model.pd_receive.remain_time_receiver/(3*60*1000.0);
//        self.cycleView.progress = scale;
        _countDownView.time = _model.pd_receive.remain_time_receiver;
        if (_model.pd_receive.status == 0) {
            _statusLabel.text = @"抢";
        } else if (_model.pd_receive.status == 1) {
            _statusLabel.text = @"待";
            if (!_cycleView.isColor) {
                _cycleView.isColor = YES;
            }
        }
    }
}

- (void)snatchBtnClick
{
    if (_touchSnatch) {
        _touchSnatch();
    }
}

#pragma mark -

- (ZZHeadImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(12+5);
            make.size.mas_equalTo(CGSizeMake(49, 49));
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
    }
    return _nameLabel;
}

- (ZZSexImgView *)sexImgView
{
    if (!_sexImgView) {
        _sexImgView = [[ZZSexImgView alloc] init];
        [self.contentView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _sexImgView;
}

- (UIImageView *)identifierImgView
{
    if (!_identifierImgView) {
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        [self.contentView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_sexImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(19, 14));
        }];
    }
    return _identifierImgView;
}

- (ZZLevelImgView *)levelImgView
{
    if (!_levelImgView) {
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5+19+5);
            make.centerY.mas_equalTo(_sexImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 14));
        }];
    }
    return _levelImgView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = kBlackTextColor;
        _typeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
        }];
    }
    return _typeLabel;
}

- (ZZColorCycleView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [[ZZColorCycleView alloc] init];
        _cycleView.animate = YES;
        _cycleView.isColor = YES;
        [self.contentView addSubview:_cycleView];
        
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.mas_equalTo(_headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(37, 37));
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = HEXCOLOR(0xF76B1C);
        _statusLabel.font = [UIFont systemFontOfSize:15];
        _statusLabel.text = @"待";
        [_cycleView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_cycleView);
        }];
        
        _snatchBtn = [[UIButton alloc] init];
        [_snatchBtn addTarget:self action:@selector(snatchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_snatchBtn];
        
        [_snatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_cycleView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _cycleView;
}

- (UILabel *)endLabel
{
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.textColor = HEXCOLOR(0x9b9b9b);
        _endLabel.font = [UIFont systemFontOfSize:15];
        _endLabel.text = @"已被抢";
        [self.contentView addSubview:_endLabel];
        
        [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.centerX.mas_equalTo(_cycleView.mas_centerX);
        }];
    }
    return _endLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(10);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return _lineView;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0xFC2F52);
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_priceLabel];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lineView.mas_left);
            make.top.mas_equalTo(_lineView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
    }
    return _priceLabel;
}

- (ZZOrderCountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[ZZOrderCountDownView alloc] init];
        [self.contentView addSubview:_countDownView];
        
        [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_priceLabel.mas_centerY);
            make.height.mas_equalTo(@18.5);
        }];
    }
    return _countDownView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderTimeCountNotification object:nil];
}

@end
