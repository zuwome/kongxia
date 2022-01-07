//
//  ZZMyWalletViewController.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//
#import "ZZLinkWebViewController.h"

#import "ZZMyWalletViewController.h"
#import "ZZCornerRadiuImageView.h"
#import "ZZCustomButtom.h"
#import "ZZChatServerViewController.h"
#import "TYAttributedLabel.h"
#import "ZZRechargeViewController.h"
#import "ZZMeBiViewController.h"//么币
#import "ZZBillingRecordsViewController.h"
#import "ZZGeneralOpenSanChatGuide.h"//开通女性闪聊引导
#import "ZZActivityUrlModel.h"
#import <UIButton+WebCache.h>
#import "WXApi.h"
#import "ZZActivityUrlNetManager.h"
@interface ZZMyWalletViewController ()<TYAttributedLabelDelegate>
@property (nonatomic,strong) UILabel *userNameLab;
@property (nonatomic,strong) UILabel *userNumberLab;//么么号
@property (nonatomic,strong) ZZCornerRadiuImageView *userHeaderImg;//用户的头像

@property (nonatomic,strong) ZZCustomButtom *userAccountBalanceBtn;//账户余额
@property (nonatomic,strong) ZZCustomButtom *userMeMeMoneyBtn;//么么币
@property (nonatomic,strong) UIButton *h5ActiveButton;//H5搞活动的
@property (nonatomic, strong) ZZGeneralOpenSanChatGuide *openSanChatViewGuide;
@property (nonatomic, assign) BOOL isStartAnimation;//是否开始闪聊引导的动画
@end

@implementation ZZMyWalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self startAnimotion];
      [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    
    [self createUI];
    
    [self loadData];
    [self loadOpenSanChat];
    [self loadH5Active];

    
}

- (void)loadH5Active {
    
    NSString *currentVCName = NSStringFromClass([self class]);
    ZZActivityUrlModel *model = [ZZActivityUrlNetManager shareInstance].h5_activity.h5_activityDic[currentVCName];
    if (model&&model.isopen) {
        if (model.once) {
            NSString *urlKey = [NSString stringWithFormat:@"%@%@",model.h5_url,self.user.uid];
            NSString *urlValue =  [ZZKeyValueStore  getValueWithKey:urlKey];
            if (urlValue) {
                return;
            }else{
                [self loadH5ActiveDataUIWithModel:model];
                [ZZKeyValueStore saveValue:urlKey key:urlKey];
            }
            return;
        }else{
            [self loadH5ActiveDataUIWithModel:model];
        }
    }
}
- (void)loadH5ActiveDataUIWithModel:(ZZActivityUrlModel *)model {
    [self.view addSubview:self.h5ActiveButton];
    [self.h5ActiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(3.5);
        make.right.offset(-3.5);
        make.top.equalTo(self.userAccountBalanceBtn.mas_bottom).offset(0);
        make.height.equalTo(self.h5ActiveButton.mas_width).multipliedBy(0.329);
    }];
    NSURL *url = [NSURL URLWithString:model.h5_url];
    [self.h5ActiveButton sd_setImageWithURL:url forState:UIControlStateNormal];
}

- (void)loadData {
    [self.userHeaderImg setUser:_user width:62 vWidth:14];
    self.userNumberLab.text = [NSString stringWithFormat:@"么么号: %@",_user.ZWMId];
    self.userNameLab.text = _user.nickname;
    
    self.userAccountBalanceBtn.numMoneyLab.text =[NSString stringWithFormat:@"¥ %.2f",[_user.balance floatValue]];//剩余金额
    self.userMeMeMoneyBtn.numMoneyLab.text = [NSString stringWithFormat:@"%.0f",[_user.mcoin floatValue]];//么么币

}
#pragma mark - 账单记录  余额  么币 点击事件
//账单记录
- (void)billingRecordClick:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
     NSLog(@"PY_User_账单记录");
    ZZBillingRecordsViewController *recordVC = [[ZZBillingRecordsViewController alloc]init];
    recordVC.recordStyle = BillingRecordsStyle_Balance;
    [self.navigationController pushViewController:recordVC animated:YES];
}

//么币
- (void)userMeMeMoneyClick:(UIButton *)sender {
     NSLog(@"PY_么币");
    sender.backgroundColor = [UIColor whiteColor];

    WS(weakSelf);
    ZZMeBiViewController *controller = [[ZZMeBiViewController alloc] init];
    controller.user = self.user;
    controller.paySuccess = ^(ZZUser *paySuccesUser) {
        weakSelf.user = [ZZUserHelper shareInstance].loginer;
        weakSelf.userMeMeMoneyBtn.numMoneyLab.text = [NSString stringWithFormat:@"%@",weakSelf.user.mcoin];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

//余额
- (void)userAccountBalanceClick:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
     NSLog(@"PY_账户余额");
    WeakSelf;
    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
    controller.rechargeCallBack = ^{
        [ZZUserHelper getUserBalanceRecordWithParam:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                //更新余额
                ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
                loginer.balance = data[@"balance"];
                [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
                
                weakSelf.userAccountBalanceBtn.numMoneyLab.text =[NSString stringWithFormat:@"¥ %.2f",[loginer.balance floatValue]];//剩余金额
                weakSelf.userMeMeMoneyBtn.numMoneyLab.text = [NSString stringWithFormat:@"%.2f",[loginer.mcoin floatValue]];//么么币
            }
        }];

    };
    [self.navigationController pushViewController:controller animated:YES];
}

//在线客服
- (void)jumpKeFu {
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
}

#pragma mark - 懒加载
- (ZZCornerRadiuImageView *)userHeaderImg {
    if (!_userHeaderImg) {
        _userHeaderImg = [[ZZCornerRadiuImageView alloc]initWithFrame:CGRectZero headerImageWidth:62];
    }
    return _userHeaderImg;
}

- (UILabel *)userNameLab {
    
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc]init];
        _userNameLab.font = [UIFont systemFontOfSize:17];
        _userNameLab.textColor  = [UIColor blackColor];
        _userNameLab.textAlignment = NSTextAlignmentLeft;
        _userNameLab.text = @"起了个很长很长的名字真的难";
    }
    return _userNameLab;
}


- (UILabel *)userNumberLab {
    
    if (!_userNumberLab) {
        _userNumberLab = [[UILabel alloc]init];
        _userNumberLab.font = [UIFont systemFontOfSize:12];
        _userNumberLab.textColor  = [UIColor blackColor];
        _userNumberLab.textAlignment = NSTextAlignmentLeft;
        _userNumberLab.text = @"么么号: ********************";
    }
    return _userNumberLab;
}

- (ZZCustomButtom *)userMeMeMoneyBtn {
    if (!_userMeMeMoneyBtn) {
        _userMeMeMoneyBtn = [[ZZCustomButtom alloc]initWithFrame:CGRectZero withImageName:@"icMebi" titleName:@"么币" subtitleName:nil];
        [_userMeMeMoneyBtn addTarget:self action:@selector(userMeMeMoneyClick:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragOutside];
        [_userMeMeMoneyBtn addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchDown];
        _userMeMeMoneyBtn.backgroundColor = [UIColor whiteColor];
    }
    return _userMeMeMoneyBtn;
}

- (ZZGeneralOpenSanChatGuide *)openSanChatViewGuide {
    if (!_openSanChatViewGuide) {
        _openSanChatViewGuide = [ZZGeneralOpenSanChatGuide generalOpenSanChatGuideWithNav:self.navigationController];
    }
    return _openSanChatViewGuide;
}
/**
 女性开通闪聊
 */
- (void)loadOpenSanChat {
    if ([ZZUserHelper shareInstance].loginer.gender ==2&&![ZZUserHelper shareInstance].loginer.open_qchat&&[ZZUserHelper shareInstance].configModel.isShowQchat) {

//        [self.view addSubview:self.openSanChatViewGuide];
//        self.isStartAnimation = YES;
//        [self.openSanChatViewGuide mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.left.offset(0);
//            make.height.equalTo(@90);
//            make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.2);
//        }];
        

//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        if (!(version && [version isEqualToString:@"3.7.5"])) {
//            [self.view addSubview:self.openSanChatViewGuide];
//            self.isStartAnimation = YES;
//            [self.openSanChatViewGuide mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.left.offset(0);
//                make.height.equalTo(@90);
//                make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.2);
//            }];
//        }

        
    }
}

///**
// 开启闪聊引导的动画
// */
//- (void)startAnimotion {
//    if (self.isStartAnimation) {
//        [self.openSanChatViewGuide  addAnimotion];
//    }
//}

- (void)buttonClickDown:(UIButton *)sender {
    sender.backgroundColor = HEXCOLOR(0xD9D9D9);
}

- (ZZCustomButtom *)userAccountBalanceBtn {
    if (!_userAccountBalanceBtn) {
        _userAccountBalanceBtn = [[ZZCustomButtom alloc]initWithFrame:CGRectZero withImageName:@"icAccountBalance" titleName:@"账户余额" subtitleName:nil];
        [_userAccountBalanceBtn addTarget:self action:@selector(userAccountBalanceClick:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragOutside];
        _userAccountBalanceBtn.backgroundColor = [UIColor whiteColor];
        [_userAccountBalanceBtn addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _userAccountBalanceBtn;
}


/**
 h5做活动的
 */
- (UIButton *)h5ActiveButton {
    if (!_h5ActiveButton) {
        _h5ActiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_h5ActiveButton addTarget:self action:@selector(h5ActiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _h5ActiveButton;
}

/**
 活动的点击事件
 */
- (void)h5ActiveButtonClick {
    
//    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
//    req.profileType =WXBizProfileType_Device;
//    req.username = @"gh_b67b9b4e7aec";
//    [WXApi sendReq:req];
//dl/business/?ticket=

    NSString *currentVCName = NSStringFromClass([self class]);
    ZZActivityUrlModel *model = [ZZActivityUrlNetManager shareInstance].h5_activity.h5_activityDic[currentVCName];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = model.detailUrl;
    controller.isPushNOHideNav = YES;
    controller.title = model.h5_name;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UI布局
- (void)createUI {
    UIButton *userInfoView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userInfoView];
    [userInfoView addTarget:self action:@selector(billingRecordClick:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragOutside];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [userInfoView addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchDown];
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.equalTo(@100);
    }];
    //头像
    [userInfoView addSubview:self.userHeaderImg];
    [self.userHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(userInfoView.mas_centerY);
        make.height.width.equalTo(@62);
    }];
    
    //用户名
    [userInfoView addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImg.mas_right).with.offset(8);
        make.right.greaterThanOrEqualTo(userInfoView.mas_right).with.offset(-100);
        make.centerY.equalTo(self.userHeaderImg.mas_centerY).multipliedBy(0.75);
    }];
    
    //么么号
    [userInfoView addSubview:self.userNumberLab];
    [self.userNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImg.mas_right).with.offset(7.5);
        make.right.greaterThanOrEqualTo(userInfoView.mas_right).with.offset(-100);
        make.centerY.equalTo(self.userHeaderImg.mas_centerY).multipliedBy(1.25);
    }];
    
    //账单记录
    UILabel *billingRecordsBtn = [[UILabel alloc]init];
    billingRecordsBtn.text = @"账单记录";
    billingRecordsBtn.font = [UIFont systemFontOfSize:15];
    [userInfoView addSubview:billingRecordsBtn];
    
    [billingRecordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-31);
        make.centerY.mas_equalTo(userInfoView);
    }];
    
 

    
    UIImageView *arrowImgView = [[UIImageView alloc]init];
    [userInfoView addSubview:arrowImgView];
    arrowImgView.image = [UIImage imageNamed:@"icMore"];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.mas_equalTo(userInfoView);
    }];
    
    //么么币
    [self.view addSubview:self.userMeMeMoneyBtn];
    //余额
    [self.view addSubview:self.userAccountBalanceBtn];
    [self.userMeMeMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-3.5);
        make.left.mas_equalTo(self.userAccountBalanceBtn.mas_right).with.offset(3.5);
        make.top.mas_equalTo(userInfoView.mas_bottom).with.offset(3.5);
        make.height.equalTo(@132);
    }];
    
    [self.userAccountBalanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@132);
        make.left.offset(3.5);
        make.width.mas_equalTo(self.userMeMeMoneyBtn.mas_width);
        make.top.equalTo(userInfoView.mas_bottom).with.offset(3.5);
    }];
    
    
    //底部
    UIView *leftLineView = [[UIView alloc]init];
    UIView *rightLineView = [[UIView alloc]init];
    [self.view addSubview:leftLineView];
    rightLineView.backgroundColor = RGBCOLOR(140, 140, 140);
    leftLineView.backgroundColor = RGBCOLOR(140, 140, 140);
    [self.view addSubview:rightLineView];
    UILabel *instructionsLab = [[UILabel alloc]init];
    [self.view addSubview:instructionsLab];
    instructionsLab.text = @"资金保障";
    instructionsLab.textColor = RGBCOLOR(140, 140, 140);
    
    TYAttributedLabel *moreInstructionLab=[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    moreInstructionLab.textColor= RGBCOLOR(140, 140, 140);
    moreInstructionLab.font= [UIFont systemFontOfSize:15];
    moreInstructionLab.numberOfLines=0;
    moreInstructionLab.lineBreakMode = kCTLineBreakByCharWrapping;
    moreInstructionLab.text=@"资金由空虾平台提供资金担保保障\n如果有疑问可联系";
    moreInstructionLab.backgroundColor = HEXCOLOR(0xf5f5f5);
    moreInstructionLab.delegate = self;
    moreInstructionLab.numberOfLines = 0;
    moreInstructionLab.textAlignment = kCTTextAlignmentCenter;
    [self.view addSubview:moreInstructionLab];
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(instructionsLab.mas_left).offset(-10);
        make.centerY.equalTo(instructionsLab.mas_centerY);
        make.height.equalTo(rightLineView.mas_height);
    }];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.left.equalTo(instructionsLab.mas_right).offset(10);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(instructionsLab.mas_centerY);
    }];
    [instructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    make.bottom.equalTo(moreInstructionLab.mas_top).with.offset(-20);
    }];
    
    [moreInstructionLab appendLinkWithText:@"在线客服" linkFont:[UIFont systemFontOfSize:15 ]linkData:@"在线客服"];
    
    [moreInstructionLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.view.mas_bottom).with.offset(-19 - SafeAreaBottomHeight);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(@60);
    }];


  
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"在线客服"]) {
            [self jumpGoToKeFuChat];
        }
    }
}


//跳转到在线客服
- (void)jumpGoToKeFuChat {
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
