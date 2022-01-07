//
//  ZZTravelSecurityViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTravelSecurityViewController.h"
#import "ZZEmergencyContactViewController.h"
#import "ZZLinkWebViewController.h"

#import "ZZSettingTitleCell.h"

@interface ZZTravelSecurityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZTravelSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"行程安全";
    
    [self createViews];
}

- (void)createViews
{
    self.tableView.hidden = NO;
}

#pragma mark - UITabelViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZSettingTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZSettingTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"紧急联系人";
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"使用教程";
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat scale = SCREEN_WIDTH/375.0;
    return 230*scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat scale = SCREEN_WIDTH/375.0;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230*scale)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:headView.bounds];
    imgView.image = [ZZUtils imageWithName:@"icon_security_guide"];
    [headView addSubview:imgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, imgView.height - 0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = kLineViewColor;
    [headView addSubview:lineView];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ZZEmergencyContactViewController *controller = [[ZZEmergencyContactViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
            controller.urlString = H5Url.emergencyHelpTutorial;
            controller.navigationItem.title = @"紧急求助使用教程";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _tableView;
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
