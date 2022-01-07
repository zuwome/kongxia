//
//  ZZVideoCommentViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZVideoCommentViewController.h"

@interface ZZVideoCommentViewController () <UITextViewDelegate>
{
    UIButton                    *_sendBtn;
    UITextView                  *_textView;
}

@end

@implementation ZZVideoCommentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HEXCOLOR(0x282828);
    
    [self createNavigationView];
}

- (void)createNavigationView
{
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(self.view.mas_top).offset(STATUSBAR_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = CustomFont(17);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"发表评论";
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.height.mas_equalTo(@44);
    }];
    
    _sendBtn = [[UIButton alloc] init];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    _sendBtn.layer.cornerRadius = 2;
    _sendBtn.clipsToBounds = YES;
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _sendBtn.backgroundColor = kYellowColor;
    [self.view addSubview:_sendBtn];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.centerY.mas_equalTo(cancelBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 30));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.backgroundColor = HEXCOLOR(0x282828);
    _textView.tintColor = [UIColor whiteColor];
    if (_nickName) {
        _textView.placeholder = [NSString stringWithFormat:@"回复%@",_nickName];
    } else {
        _textView.placeholder = [NSString stringWithFormat:@"填写评论"];
    }
    _textView.placeholderColor = kGrayTextColor;
    [self.view addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.top.mas_equalTo(cancelBtn.mas_bottom).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@150);
    }];
    
    [_textView becomeFirstResponder];
}



#pragma mark - UITextViewMethod

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 140) {
        _textView.text = [textView.text substringToIndex:140];
    }
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendBtnClick
{
    if (isNullString(_textView.text)) {
        [ZZHUD showErrorWithStatus:@"评论不能为空"];
        return;
    }
    
    if (_touchComment) {
        _touchComment(_textView.text);
    }
    
    [self cancelBtnClick];
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
