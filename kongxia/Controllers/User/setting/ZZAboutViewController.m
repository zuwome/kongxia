//
//  ZZAboutViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAboutViewController.h"
#import "ZZSinaShowViewController.h"

#import "ZZAboutCell.h"
#import "ZZAboutWXCell.h"

#import "WeiboSDK.h"

@interface ZZAboutViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIMenuItem *theCopyItem;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation ZZAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关于";
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
    
    [self createHeadView];
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    headView.backgroundColor = kBGColor;
    
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.image = [UIImage imageNamed:@"kongxialogo"];
    [headView addSubview:logoImgView];
    
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headView.mas_top).offset(45);
        make.size.mas_equalTo(CGSizeMake(102, 102));
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = kBlackTextColor;
    infoLabel.font = [UIFont systemFontOfSize:16];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionID = [NSString stringWithFormat:@" 空虾 V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    NSString *buildID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//#ifdef DEBUG
    infoLabel.text = [NSString stringWithFormat:@"%@(%@)",versionID,buildID];
//#endif
    [headView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(logoImgView.mas_bottom).offset(15);
    }];
    
    _tableView.tableHeaderView = headView;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        static NSString *identifier = @"wxcell";
        ZZAboutWXCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZAboutWXCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    } else {
        static NSString *identifier = @"mycell";
        ZZAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (!_theCopyItem) {
            _theCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyClick)];
        }
        [[UIMenuController sharedMenuController] setMenuItems:@[_theCopyItem]];
        
        ZZAboutCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[UIMenuController sharedMenuController] setTargetRect:cell.contentLabel.frame inView:cell.contentLabel.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        _indexPath = indexPath;
    } else if (indexPath.row == 2) {
        if ([WeiboSDK isWeiboAppInstalled]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sinaweibo://userinfo?uid=%@",@"5674712231"]]];
        } else {
            ZZSinaShowViewController *controller = [[ZZSinaShowViewController alloc] init];
            controller.navigationItem.title = [NSString stringWithFormat:@"空虾的个人主页"];
            controller.urlString = @"http://weibo.com/zuwome";
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)copyClick
{
    switch (_indexPath.row) {
        case 1:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"空虾";
            [ZZHUD showSuccessWithStatus:@"公众号复制成功"];
        }
            break;
//        case 2:
//        {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = @"2183289853";
//        }
//            break;
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
