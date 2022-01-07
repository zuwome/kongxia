//
//  ZZRemarkViewController.m
//  zuwome
//
//  Created by angBiu on 2017/5/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRemarkViewController.h"

@interface ZZRemarkViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ZZRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"备注名称";
    self.view.backgroundColor = kBGColor;
    
    [self createViews];
}

- (void)createViews
{
    self.textField.placeholder = @"给TA一个独一无二的备注吧";
    self.nameLabel.text = _user.nickname;
}

#pragma mark - lazyload

- (UITextField *)textField
{
    if (!_textField) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"备注名：";
        [bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.top.bottom.mas_equalTo(bgView);
            make.left.mas_equalTo(bgView.mas_left).offset(100);
        }];
    }
    return _textField;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"当前昵称：";
        [bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _nameLabel;
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
