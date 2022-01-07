//
//  ZZRealNameDoneViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameDoneViewController.h"
#import "ZZRealNameListViewController.h"

#import "ZZRealNameDoneCell.h"
#import "TTTAttributedLabel.h"
#import "ZZRechargeViewController.h"
@interface ZZRealNameDoneViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZRealNameDoneViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBGColor;
    
    [self createLeftButton];
    
    [self.view addSubview:self.tableView];
    self.imgView.hidden = NO;
}

- (void)createLeftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)navigationLeftBtnClick
{
    if (_isTiXian) {
       NSLog(@"PY_%@", self.navigationController.viewControllers);
        for (UIViewController *ctl in self.navigationController.viewControllers) {
            if ([ctl isKindOfClass:[ZZRechargeViewController class]]) {
                [self.navigationController popToViewController:ctl animated:YES];
                break;
            }
        }
        return;
    }
    BOOL haveCtl = NO;
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[ZZRealNameListViewController class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            haveCtl = YES;
            break;
        }
    }
    if (!haveCtl) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZRealNameDoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZRealNameDoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (_isAbroad) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"真实姓名";
            cell.contentLabel.text = [ZZUtils dealUserNameWithStar:_user.realname_abroad.name];
        } else {
            cell.titleLabel.text = @"证件号码";
            cell.contentLabel.text = _user.realname_abroad.code;
        }
    } else {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"姓名";
            cell.contentLabel.text = [ZZUtils dealUserNameWithStar:_user.realname.name];
        } else {
            cell.titleLabel.text = @"身份证";
            cell.contentLabel.text = _user.realname.code;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kBlackTextColor;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [footView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footView.mas_left).offset(15);
        make.right.mas_equalTo(footView.mas_right).offset(-15);
        make.top.mas_equalTo(footView.mas_top).offset(8);
    }];
    
    label.attributedText = [ZZUtils setLineSpace:@"＊为确保您提现顺利，实名认证后的信息不可更改，如有问题请联系客服" space:5 fontSize:12 color:kGrayContentColor];
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_rearname"];
        [self.view addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kBlackTextColor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"身份信息已认证";
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(8);
        }];
    }
    return _imgView;
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
