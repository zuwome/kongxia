//
//  ZZRealNameNotMainlandViewController.m
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRealNameNotMainlandViewController.h"

#import "ZZRealNameNotMainlandInputCell.h"
#import "ZZRealNameNotMainlandBottomView.h"
#import "TPKeyboardAvoidingTableView.h"

#import "ZZUploader.h"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface ZZRealNameNotMainlandViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) ZZRealNameNotMainlandBottomView *bottomView;
@property (nonatomic, strong) ZZRealname *model;

@end

@implementation ZZRealNameNotMainlandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"港澳台及海外用户认证";
    [self createViews];
}

- (void)createViews
{
    [self.view addSubview:self.tableView];
    CGFloat height = [self.bottomView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tableView.tableFooterView = self.bottomView;
    _user = [ZZUserHelper shareInstance].loginer;
    if (_user.realname_abroad.status == 1) {
        [self.bottomView.applyBtn setTitle:@"已提交 请等待审核结果" forState:UIControlStateNormal];
        self.bottomView.userInteractionEnabled = NO;
        [self.bottomView setModel:self.model];
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
    
    ZZRealNameNotMainlandInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZRealNameNotMainlandInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setIndexPath:indexPath model:self.model];
  
     cell.textField.tag = 100 + indexPath.row;
    if (cell.textField.tag ==100) {
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }else{
       cell.textField.keyboardType = UIKeyboardTypeASCIICapable;

    }
     cell.textField.delegate = self;

    [cell.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    if (_user.realname_abroad.status == 1) {
        cell.textField.userInteractionEnabled = NO;
    } else {
        cell.textField.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldValueChanged:(UITextField *)textField
{
    if (textField.tag == 100) {
        self.model.name = textField.text;
    } else {
        self.model.code = textField.text;
    }
}
#pragma mark - textFiled  代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag != 100) {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }
    
}

#pragma mark - UIButtonMethod

- (void)applyBtnClick
{
    if (isNullString(self.model.name)) {
        [ZZHUD showErrorWithStatus:@"请输入您的名字"];
        return;
    }
    if (isNullString(self.model.code)) {
        [ZZHUD showErrorWithStatus:@"请输入您的证件号码"];
        return;
    }
    if (!self.bottomView.firImage) {
        [ZZHUD showErrorWithStatus:@"请至少上传一张证件照"];
        return;
    }
    [ZZHUD showWithStatus:@"认证中..."];
    [ZZUploader uploadImages:self.bottomView.imgArray progress:^(CGFloat progress) {
        
    } success:^(NSArray *urlArray) {
        NSMutableDictionary *picDic = [@{@"front":urlArray[0]} mutableCopy];
        if (urlArray.count>1) {
            [picDic setObject:urlArray[1] forKey:@"hold"];
        }
        NSDictionary *param = @{@"name":self.model.name,
                                @"code":self.model.code,
                                @"pic":picDic};
        [self authority:param];
    } failure:^{
        [ZZHUD showErrorWithStatus:@"图片上传失败！"];
    }];
}

- (void)authority:(NSDictionary *)param
{
    [ZZRequest method:@"POST" path:@"/api/user/realname_abroad" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"已提交审核"];
            ZZRealname *realname = [[ZZRealname alloc] initWithDictionary:[data objectForKey:@"realname_abroad"] error:nil];
            _user.realname_abroad = realname;
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            if (_isTiXian) {
                
                for (UIViewController *ctl in self.navigationController.viewControllers) {
                    NSLog(@"PY_%@",ctl);
                    if ([ctl isKindOfClass:NSClassFromString(@"ZZRechargeViewController")]) {
                        [self.navigationController popToViewController:ctl animated:YES];
                        break;
                    }
                }
                //海外用户需要审核
                return ;
            }
            else
            {
            [self.navigationController popViewControllerAnimated:YES];
            }
            if (_successCallBack) {
                _successCallBack();
            }
        }
    }];
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (ZZRealNameNotMainlandBottomView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZRealNameNotMainlandBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _bottomView.weakCtl = weakSelf;
        _bottomView.touchApply = ^{
            [weakSelf applyBtnClick];
        };
    }
    return _bottomView;
}

- (ZZRealname *)model
{
    if (!_model) {
        _model = [[ZZRealname alloc] init];
        if (_user.realname_abroad && _user.realname_abroad.status != 3) {
            _model = _user.realname_abroad;
        }
    }
    return _model;
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
