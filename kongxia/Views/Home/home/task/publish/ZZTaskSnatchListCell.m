//
//  ZZTaskSnatchListCell.m
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskSnatchListCell.h"

#import "ZZOrderCountDownView.h"

@interface ZZTaskSnatchListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZSexImgView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) ZZOrderCountDownView *countDownView;
@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIView *longPressView;

@end

@implementation ZZTaskSnatchListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat width = [ZZUtils widthForCellWithText:@"与TA视频" fontSize:14];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.clipsToBounds = YES;
        _imgView.userInteractionEnabled = YES;
        [_bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.left.mas_equalTo(_bgView.mas_left);
            make.bottom.mas_equalTo(_bgView.mas_bottom);
            make.width.mas_equalTo(@112);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headBtnClick)];
        [_imgView addGestureRecognizer:recognizer];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(10);
            make.top.mas_equalTo(_bgView.mas_top).offset(8);
        }];
        
        _sexImgView = [[ZZSexImgView alloc] init];
        [_bgView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(3);
            make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
        }];
        
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        _identifierImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        _levelImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(26);
            make.centerY.mas_equalTo(_identifierImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
//        _cancelBtn = [[UIButton alloc] init];
//        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bgView addSubview:_cancelBtn];
//        
//        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.mas_equalTo(_bgView);
//            make.size.mas_equalTo(CGSizeMake(35, 40));
//        }];
//        
//        UIImageView *cancelImgView = [[UIImageView alloc] init];
//        cancelImgView.image = [UIImage imageNamed:@"icon_home_refresh_cancel"];
//        cancelImgView.userInteractionEnabled = NO;
//        [_bgView addSubview:cancelImgView];
//        
//        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
//            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
//            make.size.mas_equalTo(CGSizeMake(10, 10));
//        }];
        
        self.cycleView.hidden = NO;
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = HEXCOLOR(0x7a7a7b);
        _skillLabel.font = [UIFont systemFontOfSize:12];
        _skillLabel.backgroundColor = [UIColor whiteColor];
        _skillLabel.text = @" ";
        [_bgView addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-10);
            make.right.mas_equalTo(_cycleView.mas_left).offset(-10);
        }];
        
        _vImgView = [[UIImageView alloc] init];
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_vImgView];
        
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_skillLabel.mas_centerY);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = HEXCOLOR(0x7a7a7b);
        _vLabel.font = [UIFont systemFontOfSize:12];
        _vLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_vLabel];
        
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_vImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(_vImgView.mas_centerY);
            make.right.mas_equalTo(_skillLabel.mas_right);
        }];
        
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = [UIImage imageNamed:@"location"];
        _locationImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_locationImgView];
        
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_skillLabel.mas_top).offset(-10);
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(8, 11));
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.textColor = HEXCOLOR(0x7a7a7b);
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(_locationImgView.mas_centerY);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15-width-10);
        }];
        
//        self.countDownView.hidden = NO;
        
        [self addNotification];
        
        //添加长按手势
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        self.longPressGesture.minimumPressDuration = 1.0f;//设置长按 时间
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}

- (void)setData:(ZZPublishListModel *)model during:(NSInteger)during
{
    _model = model.pd_graber;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar]];
    self.nameLabel.text = _model.user.nickname;
    
    CGFloat nameWidth = [ZZUtils widthForCellWithText:self.nameLabel.text fontSize:14];
    CGFloat maxNameWidth = SCREEN_WIDTH - 10 - 112 - 10 - 10 - 30 - 3 - 12.5 - 3 - 30;
    
    self.sexImgView.gender = _model.user.gender;
    if ([ZZUtils isIdentifierAuthority:_model.user]) {
        self.identifierImgView.hidden = NO;
        [self.levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(26);
        }];
        maxNameWidth = maxNameWidth - 3 - 20;
    } else {
        self.identifierImgView.hidden = YES;
        [self.levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(3);
        }];
    }
    
    if (nameWidth>maxNameWidth) {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxNameWidth);
        }];
    } else {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    [self.levelImgView setLevel:_model.user.level];
    self.vLabel.hidden = YES;
    self.vImgView.hidden = YES;
    self.skillLabel.hidden = YES;
    
    BOOL haveDetail = YES;
    if (_model.user.weibo.verified) {
        self.vLabel.hidden = NO;
        self.vImgView.hidden = NO;
        self.vLabel.text = _model.user.weibo.verified_reason;
        self.skillLabel.text = @" ";
    } else if (_model.user.tags_new.count != 0) {
        self.skillLabel.hidden = NO;
        NSMutableArray *s = [NSMutableArray array];
        [_model.user.tags_new enumerateObjectsUsingBlock:^(ZZUserLabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [s addObject:obj.content];
        }];
        self.skillLabel.text = [s componentsJoinedByString:@"、"];
    } else if (_model.user.works_new.count != 0) {
        self.skillLabel.hidden = NO;
        NSMutableArray *s = [NSMutableArray array];
        [_model.user.works_new enumerateObjectsUsingBlock:^(ZZUserLabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [s addObject:obj.content];
        }];
        self.skillLabel.text = [s componentsJoinedByString:@"、"];
    } else {
        haveDetail = NO;
    }
    CGFloat height = [ZZUtils heightForCellWithText:@"哈哈" fontSize:12 labelWidth:SCREEN_WIDTH];
    if (haveDetail) {
        [self.locationImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_skillLabel.mas_top).offset(-10);
        }];
    } else {
        [self.locationImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_skillLabel.mas_top).offset(height);
        }];
    }
    if (!isNullString(model.distance)) {
        self.locationLabel.text = model.distance;
        self.locationLabel.hidden = NO;
        self.locationImgView.hidden = NO;
    } else {
        self.locationLabel.hidden = YES;
        self.locationImgView.hidden = YES;
    }
    
    [self resetStatus:during];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snacherListNotification:) name:SnatcherListNotification object:nil];
}

- (void)snacherListNotification:(NSNotification *)notification
{
    NSInteger during = [[notification.userInfo objectForKey:@"during"] integerValue];
    [self resetStatus:during];
}

- (void)resetStatus:(NSInteger)during
{
//    self.countDownView.time = _model.remain_time_sponsor;
    self.statusImgView.hidden = NO;
    _cycleView.hidden = YES;
    if (_model.remain_time_sponsor > 0) {
        if (_model.selected) {
            self.statusImgView.image = [UIImage imageNamed:@"icon_task_selected"];
            _statusLabel.text = @"选定TA";
            _statusLabel.textColor = kYellowColor;
        } else {
            self.statusImgView.hidden = YES;
            _cycleView.hidden = NO;
            _statusLabel.text = @"选TA";
            _statusLabel.textColor = HEXCOLOR(0xfc2f52);
        }
    } else {
        _statusLabel.text = @"不可选";
        _statusLabel.textColor = HEXCOLOR(0xb5b5b5);
        self.statusImgView.image = [UIImage imageNamed:@"icon_task_ban"];
    }
}

#pragma mark -

- (void)cancelBtnClick
{
    if (_touchCancel) {
        _touchCancel();
    }
}

- (void)headBtnClick
{
    if (_touchHead) {
        _touchHead();
    }
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        BLOCK_SAFE_CALLS(self.longPressGestureRecognizerBlock);
    } else {
        
    }
}

- (void)clickRemove {
    BLOCK_SAFE_CALLS(self.clickRemoveViewBlock);
}

- (void)longPressShowView {
    self.longPressView = [UIView new];
    self.longPressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.longPressView.center = self.contentView.center;
    self.longPressView.width = 1.0f;
    self.longPressView.height = 1.0f;
    [self.contentView addSubview:self.longPressView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRemove)];
    [self.longPressView addGestureRecognizer:gesture];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"屏蔽TA" forState:(UIControlStateNormal)];
    [btn setTitleColor:kBlackColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 74.0 / 2.0;
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.longPressView addSubview:btn];
    
    [UIView animateWithDuration:0.2 animations:^{
        //        self.longPressView.width = self.width - 20;
        //        self.longPressView.height = self.height;
        self.longPressView.frame = CGRectMake(10, 0, self.width - 20, self.height - 5);
    } completion:^(BOOL finished) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.longPressView);
            make.width.height.equalTo(@74);
        }];
    }];
}

- (void)removeView {
    [self.longPressView removeAllSubviews];
    [self.longPressView removeFromSuperview];
    self.longPressView = nil;
}


- (ZZColorCycleView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [[ZZColorCycleView alloc] init];
        _cycleView.isColor = NO;
        _cycleView.animate = YES;
        [self.contentView addSubview:_cycleView];
        
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-25);
            make.centerY.mas_equalTo(_bgView.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0xfc2f52);
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"选";
        label.userInteractionEnabled = NO;
        [_cycleView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_cycleView);
        }];
        
        _statusImgView = [[UIImageView alloc] init];
        _statusImgView.hidden = YES;
        [self.contentView addSubview:_statusImgView];
        
        [_statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_cycleView);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_cycleView.mas_centerX);
            make.top.mas_equalTo(_cycleView.mas_bottom).offset(8);
        }];
    }
    return _cycleView;
}

- (ZZOrderCountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[ZZOrderCountDownView alloc] init];
        [self.contentView addSubview:_countDownView];
        
        [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_cycleView.mas_centerX);
            make.centerY.mas_equalTo(_skillLabel.mas_centerY).offset(2);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SnatcherListNotification object:nil];
}

@end
