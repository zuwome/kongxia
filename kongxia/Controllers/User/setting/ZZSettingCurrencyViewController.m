//
//  ZZSettingCurrencyViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingCurrencyViewController.h"

#import "ZZSettingSwitchCell.h"

@interface ZZSettingCurrencyViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView                         *_tableView;
}

@end

@implementation ZZSettingCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"通用";
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.tag = indexPath.row + 100;
    [cell.settingSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    
    cell.lineView.hidden = NO;
    switch (indexPath.row) {
        case 0:
        {
            cell.lineView.hidden = YES;
            cell.titleLabel.text = @"仅WIFI播放";
            if ([ZZUserHelper shareInstance].allow3GPlay) {
                cell.settingSwitch.on = NO;
            } else {
                cell.settingSwitch.on = YES;
            }
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"仅WIFI上传";
            if ([ZZUserHelper shareInstance].allow3GUpload) {
                cell.settingSwitch.on = NO;
            } else {
                cell.settingSwitch.on = YES;
            }
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"开启位置服务";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UISwitchMethod

- (void)switchDidChange:(UISwitch *)sender
{
    switch (sender.tag - 100) {
        case 0:
        {
            if (sender.on) {
                [MobClick event:Event_click_currency_wifi_on];
                [ZZUserHelper shareInstance].allow3GPlay = nil;
            } else {
                [MobClick event:Event_click_currency_wifi_off];
                [ZZUserHelper shareInstance].allow3GPlay = @"allow3GPlay";
            }
        }
            break;
        case 1:
        {
            if (sender.on) {
                [ZZUserHelper shareInstance].allow3GUpload = nil;
            } else {
                [ZZUserHelper shareInstance].allow3GUpload = @"allow3GUpload";
            }
        }
            break;
        default:
            break;
    }
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
