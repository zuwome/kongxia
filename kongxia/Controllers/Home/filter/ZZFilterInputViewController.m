//
//  ZZFilterInputViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFilterInputViewController.h"
#import "ZZFilterInputCell.h"
#import "ZZRentHelper.h"
#import "ZZUserHelper.h"
#import "ZZRentViewController.h"
#import "ZZSignUpS3ViewController.h"
#import "ZZFansEmptyView.h"
@interface ZZFilterInputViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ZZFansEmptyView *emptyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (strong, nonatomic) NSDate *photo_updated_at;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, assign) BOOL isPush;//跳转到个人页顶部有黄色导航栏
@property (nonatomic, strong) NSString *highlight;
@property (nonatomic, assign) BOOL isUpdataSearchString;//是否更新搜索的数据
@property (nonatomic,assign) BOOL isHideNav;

@end

@implementation ZZFilterInputViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isPush = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.navigationController.navigationBarHidden) {
        _isHideNav = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!_isPush&&_isHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBGColor;
    [self createViews];
    
    [_textField becomeFirstResponder];
}

#pragma mark - Views

- (void)createViews
{
    __weak typeof(self)weakSelf = self;
    //黄色底
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, isFullScreenDevice ? 88 : 64)];
    topView.backgroundColor = kYellowColor;
    [self.view addSubview:topView];
    
    //白色
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4;
    [topView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView.mas_left).offset(8);
        make.bottom.mas_equalTo(topView.mas_bottom).offset(-5);
        make.right.mas_equalTo(topView.mas_right).offset(-48);
        make.height.mas_equalTo(@34);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_filter_search"];
    imgView.userInteractionEnabled = NO;
    [bgView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(8);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入用户名或么么号";
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.textColor = kBlackTextColor;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeySearch;
    [bgView addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top);
        make.bottom.mas_equalTo(bgView.mas_bottom);
        make.left.mas_equalTo(imgView.mas_right).offset(8);
        make.right.mas_equalTo(bgView.mas_right).offset(-8);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_right);
        make.right.mas_equalTo(topView.mas_right);
        make.bottom.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(@44);
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        weakSelf.photo_updated_at = nil;
        [weakSelf search];
    }];
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUser *model = [weakSelf.dataArray lastObject];
        weakSelf.photo_updated_at = model.photo_updated_at;
        [weakSelf search];
    }];
    self.emptyView.hidden = YES;

}
- (ZZFansEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZFansEmptyView alloc] init];
        _emptyView.contentLabel.text = @"啊欧!当前搜索的用户不存在,请换个搜索";
        [self.view addSubview:_emptyView];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.equalTo(self.tableView.mas_top);
        }];
    }
    return _emptyView;
}
#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZFilterInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZFilterInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setDataModel:self.dataArray[indexPath.row] highlight:_highlight];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
        _isPush = YES;
        ZZUser *user = self.dataArray[indexPath.row];
        ZZRentViewController *vc = [[ZZRentViewController alloc] init];
        vc.uid = user.uid;
        [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)gotoUploadPhoto
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ZZSignUpS3ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CompleteUserInfo"];
    vc.faces = [NSMutableArray arrayWithArray:[ZZUserHelper shareInstance].loginer.faces];
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark - UITextFieldMethod

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_isSearching) {
        return NO;
    }
    self.emptyView.hidden = YES;
    _isUpdataSearchString = YES;
    _photo_updated_at = nil;
    [self search];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Request

- (void)search
{
    
    _isSearching = YES;
    NSString *highString = _textField.text;
    NSLog(@"PY_搜索数据为%@",highString);
    NSMutableDictionary *param = [@{@"nickname":highString} mutableCopy];
    [ZZHUD showWithStatus:@"正在搜索中"];
    ZZRentHelper *rentHelper = [[ZZRentHelper alloc] init];
    if ([ZZUserHelper shareInstance].isLogin) {
        [rentHelper pullWithParams:param lt:_photo_updated_at next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [ZZHUD dismiss];
            if (error) {
                if (error.code ==1111) {
                    if (self.dataArray.count<=0) {
                        self.emptyView.hidden = NO;
                    }else{
                        self.emptyView.hidden = YES;
                    }
                }else{
                [ZZHUD showErrorWithStatus:error.message];
                }
            } else {
                self.emptyView.hidden = YES;
                _highlight = highString;
                NSArray *array = [ZZUser arrayOfModelsFromDictionaries:data error:nil];
                if (!array.count) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (!_photo_updated_at) {
                    [self.dataArray removeAllObjects];
                }
                if (_isUpdataSearchString) {
                    self.dataArray = [array mutableCopy];
                    _isUpdataSearchString = NO;
                    [_tableView setContentOffset:CGPointMake(0,0)animated:NO];
                }
                else{
                    [self.dataArray addObjectsFromArray:array];

                }
                [self.tableView reloadData];
            }
          
            self.tableView.hidden = NO;
            _isSearching = NO;
        }];
    } else {
        [rentHelper pullExploreWithParamsAll:param lt:_photo_updated_at next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_footer resetNoMoreData];
            [ZZHUD dismiss];
         
            if (error) {
                if (error.code ==1111) {
                    if (self.dataArray.count<=0) {
                        self.emptyView.hidden = NO;
                    }else{
                        self.emptyView.hidden = YES;
                    }
                }else{
                    [ZZHUD showErrorWithStatus:error.message];
                }
            } else {
                self.emptyView.hidden = YES;
                _highlight = highString;
                NSArray *array = [ZZUser arrayOfModelsFromDictionaries:data error:nil];
                if (!array.count) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (!_photo_updated_at) {
                    [self.dataArray removeAllObjects];
                }
                
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
            self.tableView.hidden = NO;
            _isSearching = NO;
        }];
    }
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
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
