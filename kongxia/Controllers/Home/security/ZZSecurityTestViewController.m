//
//  ZZSecurityTestViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityTestViewController.h"
#import "ZZSecurityOperationViewController.h"

#import "ZZSecurityView.h"

@interface ZZSecurityTestViewController ()

@property (nonatomic, strong) ZZSecurityView *securityView;

@end

@implementation ZZSecurityTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"试用";
    [self createViews];
}

- (void)createViews
{
    self.securityView.test = YES;
}

#pragma mark - Navigation

- (void)gotoSecurityOperationView
{
    if ([ZZUtils isConnecting]) {
        return;
    }
    [ZZVideoHelper checkAudioAuthority:^(BOOL authorized) {
        if (authorized) {
            ZZSecurityOperationViewController *controller = [[ZZSecurityOperationViewController alloc] init];
            controller.test = YES;
            controller.navigationItem.title = @"试用";
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

#pragma mark - lazyload

- (ZZSecurityView *)securityView
{
    WeakSelf;
    if (!_securityView) {
        _securityView = [[ZZSecurityView alloc] init];
        [self.view addSubview:_securityView];
        
        [_securityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        _securityView.touchHelp = ^{
            [weakSelf gotoSecurityOperationView];
        };
    }
    return _securityView;
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
