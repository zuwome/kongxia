//
//  ZZViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavigationLeftButton];
}

- (void)createNavigationLeftButton
{
    
    _navigationLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    _navigationLeftBtn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    _navigationLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    
    [_navigationLeftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
   
    [_navigationLeftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    
    [_navigationLeftBtn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationLeftBtn];
    
    self.navigationItem.leftBarButtonItems =@[leftItem];
  
}

- (void)navigationLeftBtnClick
{
    [ZZHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNavigationRightDoneBtn
{
    _navigationRightDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _navigationRightDoneBtn.frame = CGRectMake(0, 0, 30, 20);
//    [_navigationRightDoneBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
//    [_navigationRightDoneBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateHighlighted];
    _navigationRightDoneBtn.frame = CGRectMake(0, 0, 70, 21);
    [_navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [_navigationRightDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_navigationRightDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_navigationRightDoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:_navigationRightDoneBtn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
    
}

- (void)gotoLoginView
{
      NSLog(@"PY_登录界面%s",__func__);
    [[LoginHelper sharedInstance] showLoginViewIn:self];
}

- (void)dealloc
{
    NSLog(@"%@ ----- dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
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
