//
//  ZZHomeNavigationView.m
//  zuwome
//
//  Created by angBiu on 16/7/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeNavigationView.h"

@interface ZZHomeNavigationView ()

@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, strong) UIImageView *hotImgView;
@property (nonatomic, strong) UIView *redPoint;

@end

@implementation ZZHomeNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSnatchCount) name:KMsg_UpdateSnatchUnreadCount object:nil];

        _labelWidth = 45;
        
        if (ISiPhone6) {
            _labelWidth = 54;
        } else if (ISiPhone6P) {
            _labelWidth = 54;
        }
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kYellowColor;
        [self addSubview:_bgView];
    
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(_labelWidth/2);
            make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(4*_labelWidth);
        }];
        
        _leftBgView = [[UIView alloc] init];
        _leftBgView.backgroundColor = kYellowColor;
        [self addSubview:_leftBgView];
        
        [_leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(_bgView.mas_left).offset(-10);
        }];
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        leftImgView.image = [UIImage imageNamed:@"icon_triangle_down"];
        leftImgView.backgroundColor = kYellowColor;
        [_leftBgView addSubview:leftImgView];
        
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBgView.mas_left).offset(15);
            make.centerY.mas_equalTo(_leftBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(11, 7));
        }];
        
        [_leftBgView addSubview:self.leftTitleLabel];

        
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_leftBgView.mas_centerY);
            make.left.mas_equalTo(leftImgView.mas_right).offset(5);
            make.right.mas_equalTo(_leftBgView.mas_right);
        }];
        
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftBgView addSubview:_leftBtn];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_leftBgView);
        }];
        
        UIImageView *rightImgView = [[UIImageView alloc] init];
        rightImgView.image = [UIImage imageNamed:@"icon_home_filter"];
        rightImgView.contentMode = UIViewContentModeRight;
        rightImgView.backgroundColor = kYellowColor;
        [self addSubview:rightImgView];
        
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top).offset(20);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(@65);
        }];
        
        [self addLabels];
    }
    
    return self;
}

- (void)addLabels
{
    NSArray *titleArray = @[@"附近",@"推荐",@"闪租",@"新鲜"];
    for (int i = 0; i < titleArray.count; i++) {
        ZZHomeTitleLabel *label = [[ZZHomeTitleLabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleArray[i];
        label.frame = CGRectMake(i*_labelWidth, 0, _labelWidth, 44);
        label.font = [UIFont systemFontOfSize:18];
        [_bgView addSubview:label];
        label.tag = i + 300;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
        
        if (i == 2) {
//            _hotImgView = [[UIImageView alloc] init];
//            _hotImgView.image = [UIImage imageNamed:@"icon_home_livestream_hot"];
//            _hotImgView.userInteractionEnabled = NO;
//            [_bgView addSubview:_hotImgView];
//            
//            [_hotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(label.mas_centerX).offset(10);
//                make.bottom.mas_equalTo(label.mas_centerY).offset(-5);
//                make.size.mas_equalTo(CGSizeMake(16, 19));
//            }];
            
            _redPoint = [[UIView alloc] init];
            _redPoint.backgroundColor = HEXCOLOR(0xe63138);
            _redPoint.layer.cornerRadius = 3.5;
            _redPoint.userInteractionEnabled = NO;
            _redPoint.hidden = YES;
            [_bgView addSubview:_redPoint];
            
            [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_centerX).offset(18);
                make.centerY.mas_equalTo(label.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(7, 7));
            }];
            
            [_bgView sendSubviewToBack:_hotImgView];
        }
    }
}

- (void)setCityName:(NSString *)cityName
{
    self.leftTitleLabel.text = cityName;
    CGFloat maxWidth = (SCREEN_WIDTH - 3*_labelWidth)/2.0 - 10 - 15 - 11 - 5;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:cityName fontSize:15];
    if (nameWidth>maxWidth) {
        [self.leftTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [self.leftTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
}

- (void)setShowRedPoint:(BOOL)showRedPoint
{
    _showRedPoint = showRedPoint;
    if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstHomeTaskHotGuide]) {
        _hotImgView.hidden = YES;
        _redPoint.hidden = !showRedPoint;
    } else {
        _hotImgView.hidden = NO;
        _redPoint.hidden = YES;
    }
    _hotImgView.hidden = [ZZUserHelper shareInstance].configModel.hide_hot_symbol;
}

//更新抢任务数目
- (void)updateSnatchCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        _redPoint.hidden = [ZZUserHelper shareInstance].unreadModel.pd_receive == 0;
    });
}
- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _leftTitleLabel.textColor = kBlackTextColor;
        _leftTitleLabel.font = [UIFont systemFontOfSize:15];
        _leftTitleLabel.backgroundColor = kYellowColor;
    }
    return _leftTitleLabel;
}
#pragma mark - UIButtonMethod

- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    ZZHomeTitleLabel *titlelable = (ZZHomeTitleLabel *)recognizer.view;
    if (_selctedIndex) {
        _selctedIndex(titlelable.tag - 300);
    }
}

- (void)leftBtnClick
{
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)rightBtnClick
{
    if (_touchRight) {
        _touchRight();
    }
}

@end
