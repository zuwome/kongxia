//
//  ZZSettingSecurityViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingSecurityViewController.h"
#import "ZZBindViewController.h"
#import "ZZChangePwdViewController.h"
#import "ZZRealNameListViewController.h"
#import "ZZDeleteAccountViewController.h"

#import "ZZSettingSecurityCell.h"
#import "MiPushSDK.h"
#import <RongIMKit/RongIMKit.h>

@interface ZZSettingSecurityViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *reasonArray;

@end

@implementation ZZSettingSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"账号和安全";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZSettingSecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZSettingSecurityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    } else {
        
    }
    switch (indexPath.row) {
        case 0:
        {
            [MobClick event:Event_click_change_password];
            ZZChangePwdViewController *controller = [[ZZChangePwdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:Event_click_bind_account];
            ZZBindViewController *controller = [[ZZBindViewController alloc] init];
            controller.user = _user;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
//            if ([ZZUtils isIdentifierAuthority:_user]) {
                [MobClick event:Event_click_me_realname];
                ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.user = _user;
                [self.navigationController pushViewController:controller animated:YES];
//            } else {
//                [self accountCancel];
//            }
        }
            break;
        case 3:
        {
            [self accountCancel];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)accountCancel
{
    [ZZRequest method:@"GET" path:@"/api/user/account/status" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            BOOL canCancelAccount = [data[@"can_close_account"] boolValue];
            if (canCancelAccount) {
                self.reasonArray = data[@"reason"];
                NSMutableArray *actions = [[NSMutableArray alloc] init];
                for (NSString *reason in self.reasonArray) {
                    [actions addObject:[alertAction createWithTitle:reason style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        WeakSelf;
                        ZZDeleteAccountConfirmViewController *controller = [[ZZDeleteAccountConfirmViewController alloc] initWithReason:reason];
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    }]];
                }
                
                [self showSheetActions:@"希望您能够告诉我们注销的原因，帮助我们不断改进空虾，感谢您的参与"
                               message:nil
                           cancelTitle:@"取消"
                         cancelHandler:nil
                               actions:actions.copy];
                
                
            } else {
                [self showOkAlert:@"邀约未完成" message:@"您还有正在进行中的邀约，请您完成后，再进行账号注销。" confirmTitle:@"确定" confirmHandler:nil];
            }
        }
    }];
}

- (void)gotoConfirmDeleteView:(NSString *)reason {
    ZZDeleteAccountViewController *controller = [[ZZDeleteAccountViewController alloc] init];
    controller.reason = reason;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cancelAccountRequest:(NSString *)reason
{
    [ZZRequest method:@"POST" path:@"/api/user/account/close" params:@{@"reason":reason} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [MiPushSDK unsetAlias:[ZZUserHelper shareInstance].loginer.uid];
            
            [[RCIM sharedRCIM] logout];
            [ZZUserHelper shareInstance].firstCloseTopView = NO;
            [[[ZZUser alloc] init] logout:nil];
            [[ZZUserHelper shareInstance] clearLoginer];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserDidLogout object:self];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
