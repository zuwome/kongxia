//
//  ZZTaskPayAlert.m
//  zuwome
//
//  Created by angBiu on 2017/8/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskPayAlert.h"
#import "ZZChatViewController.h"
#import "ZZTabBarViewController.h"

#import "ZZPublishListModel.h"

@interface ZZTaskPayAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZTaskPayAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.55);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    self.sureBtn.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    switch (type) {
        case 1:
        {
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.sureBtn.hidden = NO;
            self.titleLabel.text = @"选取达人";
            _contentLabel.text = @"点击“选”即可选取当前达人进行任务，再次点击即可取消选定。选定达人后，支付余款或点击“马上预约”即可开始任务。最多可选择5名达人同时进行服务";
            NSString *string = @"点击“选”即可选取当前达人进行任务，再次点击即可取消选定。选定达人后，支付余款或点击“马上预约”即可开始任务。最多可选择5名达人同时进行服务";
            NSMutableAttributedString *attributedString = [ZZUtils setLineSpace:string space:5 fontSize:15 color:HEXCOLOR(0x979797)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[string rangeOfString:@"选"]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[string rangeOfString:@"5"]];
            _contentLabel.attributedText = attributedString;
        }
            break;
        case 2:
        {
            self.titleLabel.text = @"确认选择";
            [self.leftBtn setTitle:@"再选选" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"开始任务" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.titleLabel.text = @"确认选择";
            [self.leftBtn setTitle:@"再选选" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"前往支付" forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            self.titleLabel.text = @"获得任务";
            [self.leftBtn setTitle:@"稍后" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"立即沟通" forState:UIControlStateNormal];
            if (_model.id) {
                NSString *detailString = [NSString stringWithFormat:@"（%@，%@）",_model.dated_at_text,_model.address];
                NSString *sumString = [NSString stringWithFormat:@"您成功抢到%@发布的%@%@任务，请及时和对方沟通任务详情哦",_model.from.nickname,_model.skill.name,detailString];
                NSMutableAttributedString *attributedString = [ZZUtils setLineSpace:sumString space:5 fontSize:15 color:HEXCOLOR(0x979797)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:kYellowColor range:[sumString rangeOfString:_model.from.nickname]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:kBlackColor range:[sumString rangeOfString:detailString]];
                _contentLabel.attributedText = attributedString;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    NSString *names = @"";
    for (int i=0; i<dataArray.count; i++) {
        @autoreleasepool {
            ZZPublishListModel *model = dataArray[i];
            if (i==0) {
                names = model.pd_graber.user.nickname;
            } else {
                names = [NSString stringWithFormat:@"%@、%@",names,model.pd_graber.user.nickname];
            }
        }
    }
    NSString *sumString;
    if (self.dataArray.count == 1) {
        self.type = 2;
        sumString = [NSString stringWithFormat:@"您选择了%@来进行本次任务，开始任务后将自动生成你们的邀约，邀约结束前，您的任务金都将由平台监管，请放心赴约。",names];
    } else {
        self.type = 3;
        sumString = [NSString stringWithFormat:@"您选择了%@来进行本次任务，需要支付剩余的任务金，支付完成后将自动生成你们的邀约，邀约结束前，您的任务金都将由平台监管，请放心支付",names];
    }
    NSMutableAttributedString *attributedString = [ZZUtils setLineSpace:sumString space:5 fontSize:15 color:HEXCOLOR(0x979797)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kYellowColor range:[sumString rangeOfString:names]];
    _contentLabel.attributedText = attributedString;
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [self removeFromSuperview];
}

- (void)rightBtnClick
{
    if (_touchRight) {
        _touchRight();
    }
    [self leftBtnClick];
    if (_type == 4 && _model.id) {
        ZZChatViewController *controller = [[ZZChatViewController alloc] init];
        controller.uid = _model.from.uid;;
        controller.user = _model.from;
        controller.nickName = _model.from.nickname;
        controller.portraitUrl = _model.from.avatar;
        UINavigationController *navCtl = [ZZTabBarViewController sharedInstance].selectedViewController;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    }
}

- (void)sureBtnClick
{
    [self removeFromSuperview];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(317*scale);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_task_pay_top"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(_bgView.mas_top);
            make.size.mas_equalTo(CGSizeMake(74, 74));
        }];
        
        self.titleLabel.text = @"111";
        self.contentLabel.text = @"111";
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        self.sureBtn.hidden = YES;
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(55);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x979797);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(17);
            make.right.mas_equalTo(_bgView.mas_right).offset(-17);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(26);
        }];
    }
    return _contentLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftBtn.layer.cornerRadius = 3;
        _leftBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_leftBtn];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-7);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(28);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightBtn.layer.cornerRadius = 3;
        _rightBtn.backgroundColor = kYellowColor;
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_rightBtn];
        
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_centerX).offset(7);
            make.right.mas_equalTo(_contentLabel.mas_right);
            make.top.bottom.mas_equalTo(_leftBtn);
        }];
    }
    return _rightBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.layer.cornerRadius = 3;
        _sureBtn.hidden = YES;
        _sureBtn.backgroundColor = kYellowColor;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_contentLabel);
            make.top.bottom.mas_equalTo(_leftBtn);
        }];
    }
    return _sureBtn;
}

@end
