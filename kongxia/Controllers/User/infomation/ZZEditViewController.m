//
//  ZZEditViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZEditViewController.h"

@interface ZZEditViewController ()
@property (strong, nonatomic)  UITextField *textField;
@property (strong, nonatomic)  UILabel *infoLabel;

@end

@implementation ZZEditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBGColor;
    
    if (_editType == EditTypeName) {
        self.navigationItem.title = @"修改用户名";
        self.placeholder = @"请输入您的用户名 ^_^";
    } else {
        self.navigationItem.title = @"职业";
        self.placeholder = @"请输入您的职业 ^_^";
    }
    
    [self createNavigationRightButton];
    [self createViews];
    
    _textField.text = _valueString;
    _textField.placeholder = _placeholder;
    [_textField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)createNavigationRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)createViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.textColor = kBlackTextColor;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_textField];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_infoLabel];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(bgView.mas_bottom).offset(8);
    }];
}

#pragma mark - UITextFieldMethod

- (void)textValueChange:(UITextField *)textField
{
    switch (_editType) {
        case EditTypeName:
        {
            if ([ZZUtils lenghtWithString:textField.text] > 15) {
//                textField.text = [textField.text substringToIndex:15];
                _infoLabel.text = @"用户名不能超过7个汉字或15个字母";
                _infoLabel.textColor = [UIColor grayColor];
            } else {
                _infoLabel.text = @"";
            }
        }
            break;
        case EditTypeJob:
        {
            if (textField.text.length > 20) {
                textField.text = [textField.text substringToIndex:20];
                _infoLabel.text = @"职业控制在20个字符内";
                _infoLabel.textColor = [UIColor grayColor];
            }
        }
        default:
            break;
    }
}

- (BOOL)validateNickname:(NSString *)nickname
{
    NSString *regex = @"[a-zA-Z0-9_\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:nickname];
}

#pragma mark - UIbuttonClick

- (void)doneBtnClick
{
    if (_editType == EditTypeName) {
        if (_textField.text.length == 0 || [ZZUtils lenghtWithString:_textField.text] > 15) {
            [ZZHUD showErrorWithStatus:@"用户名不能超过7个汉字或15个字母"];
            return;
        }
        NSString *str = [ZZUtils deleteEmptyStrWithString:_textField.text];
        if (isNullString(str)) {
            [ZZHUD showErrorWithStatus:@"用户名不能全空格"];
            return;
        }
        
        [ZZUserHelper checkTextWithText:str type:2 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [self callBack];
            }
        }];
    } else {
        [self callBack];
    }
}

- (void)callBack
{
    if (_callBackBlock) {
        _callBackBlock(_textField.text);
        [self.navigationController popViewControllerAnimated:YES];
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
