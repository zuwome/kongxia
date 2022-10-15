//
//  ZZBindViewController.m
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZBindViewController.h"
#import "ZZBindCell.h"
#import "ZZChangePhoneViewController.h"

#import <UMSocialCore/UMSocialCore.h>

@interface ZZBindViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isHideNav;//判断上一个界面是否是需要隐藏导航
@end

@implementation ZZBindViewController

#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        _isHideNav = YES;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [ZZUserHelper shareInstance].userFirstWB = @"userFirstWB";
    
    if (_updateRedPoint) {
        _updateRedPoint();
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isHideNav) {
        _isHideNav = NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.user) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    self.navigationItem.title = @"账号绑定";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"bindcell";
    
    ZZBindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setDataModel:_user indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
//            ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeChangePhone inController:self];
//            helper.user = _user;
//            helper.checkSuccess = ^{
//                [self.tableView reloadData];
//                if (_updateBind) {
//                    _updateBind();
//                }
//            };
//            [helper start];
            ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] init];
            controller.user = _user;
            controller.updateBlock = ^{
                if (_updateBind) {
                    _updateBind();
                }
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:Event_click_bind_qq];
            if (_user.qq.openid) {
                NSDictionary *param = @{@"platform":@"qq",
                                        @"qq":[_user.qq toDictionary]};
                [self sendUnbindWithType:1 param:param];
            } else {
                [self qqBind];
            }
        }
            break;
        case 2:
        {
            [MobClick event:Event_click_bind_wx];
            if (_user.wechat.unionid) {
                NSDictionary *param = @{@"platform":@"wechat",
                                        @"wechat":[_user.wechat toDictionary]};
                [self sendUnbindWithType:2 param:param];
            } else {
                [self wxBind];
            }
        }
            break;
        case 3:
        {
            [MobClick event:Event_click_bind_wb];
            if (_user.weibo.uid) {
                NSDictionary *param = @{@"platform":@"weibo",
                                        @"weibo":[_user.weibo toDictionary]};
                [self sendUnbindWithType:3 param:param];
            } else {
                [self wbBind];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIButtonMethod

- (void)qqBind
{
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialAuthResponse *response = result;
            if (response.openid) {
                NSDictionary *aDict = @{@"access_token":response.accessToken,
                                              @"openid":response.openid};
                NSDictionary *param = @{@"platform":@"qq",
                                            @"qq":aDict};
                [self sendBindWithType:1 param:param];
            }
        }
        if (error) {
            [ZZHUD showErrorWithStatus:@"绑定失败，请重新绑定"];
        }
    }];
}

- (void)wxBind
{
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialAuthResponse *response = result;
            if (response.uid) {
                NSDictionary *aDict = @{@"access_token":response.accessToken,
                                        @"openid":response.openid,
                                        @"unionid":response.uid};
                NSDictionary *param = @{@"platform":@"wechat",
                                        @"wechat":aDict};
                [self sendBindWithType:2 param:param];
            }
        }
        if (error) {
            [ZZHUD showErrorWithStatus:@"绑定失败，请重新绑定"];
        }
    }];
}

- (void)wbBind
{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userInfo = result;
        if (userInfo.uid) {
            NSDictionary *aDict = @{@"access_token":userInfo.accessToken,
                                    @"uid":userInfo.uid,
                                    @"userName":userInfo.name,
                                    @"iconURL":userInfo.iconurl,
                                    @"profileURL":[NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid]};
            NSDictionary *param = @{@"platform":@"weibo",
                                    @"weibo":aDict};
            [self sendBindWithType:3 param:param];
        }
        if (error) {
            [ZZHUD showErrorWithStatus:@"绑定失败，请重新绑定"];
        }
    }];
}

// 1:QQ 2:微信 3:新浪
- (void)sendBindWithType:(NSInteger)type param:(NSDictionary *)param
{
    WS(weakSelf);
    [_user thirdBindWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            switch (type) {
                case 1:
                {
                    [ZZHUD showSuccessWithStatus:@"QQ绑定成功!"];
                    weakSelf.user.qq = user.qq;
                }
                    break;
                case 2:
                {
                    [ZZHUD showSuccessWithStatus:@"微信绑定成功!"];
                    weakSelf.user.wechat = user.wechat;
                }
                    break;
                case 3:
                {
                    [ZZHUD showSuccessWithStatus:@"新浪微博绑定成功!"];
                    weakSelf.user.weibo = user.weibo;
                    if (weakSelf.bindWeiBoSuccessBlock) {
                        weakSelf.bindWeiBoSuccessBlock();
                    }
                }
                    break;
                default:
                    break;
            }
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [self.tableView reloadData];
            if (weakSelf.updateBind) {
                weakSelf.updateBind();
            }
        }
    }];
}

- (void)sendUnbindWithType:(NSInteger)type param:(NSDictionary *)param
{
    [ZZHUD showWithStatus:@"解绑中..."];
    [_user thirdUnbindWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            switch (type) {
                case 1:
                {
                    [ZZHUD showSuccessWithStatus:@"QQ解绑成功!"];
                    _user.qq = user.qq;
                }
                    break;
                case 2:
                {
                    [ZZHUD showSuccessWithStatus:@"微信解绑成功!"];
                    _user.wechat = user.wechat;
                }
                    break;
                case 3:
                {
                    [ZZHUD showSuccessWithStatus:@"新浪微博解绑成功!"];
                    _user.weibo = user.weibo;
                }
                    break;
                default:
                    break;
            }
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [self.tableView reloadData];
            if (_updateBind) {
                _updateBind();
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
