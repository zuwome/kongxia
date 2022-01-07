//
//  ZZNetWorkCheckViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNetWorkCheckViewController.h"
#import "TTTAttributedLabel.h"
#import "UILabel+Extension.h"
@interface ZZNetWorkCheckViewController ()<TTTAttributedLabelDelegate>
@property (nonatomic,strong) UILabel *titleOneLab;
@property (nonatomic,strong) UILabel *titleOneDetailoneLab;
@property (nonatomic,strong) UILabel *titleOneDetailTwoLab;
@property (nonatomic,strong) UILabel *titleOneDetailThirdLab;
@property (nonatomic,strong) TTTAttributedLabel*linkLab;
@property (nonatomic,strong) UILabel *titleTwoLab;
@property (nonatomic,strong) UILabel *titleTwoDetailLab;

@end

@implementation ZZNetWorkCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"解决方案";
    [self setUI];
    [self setUpTheConstraints];
}
- (void)setUI {
    [self.view addSubview:self.titleOneLab];
    [self.view addSubview:self.titleOneDetailoneLab];
    [self.view addSubview:self.titleOneDetailTwoLab];
    [self.view addSubview:self.titleOneDetailThirdLab];
    [self.view addSubview:self.linkLab];
    [self.view addSubview:self.titleTwoLab];
    [self.view addSubview:self.titleTwoDetailLab];

}

/**
 设置约束
 */
- (void)setUpTheConstraints {
    [self.titleOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(10);
    }];
    [self.titleOneDetailoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.titleOneLab.mas_bottom).offset(17);
    }];
    [self.linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.titleOneDetailoneLab.mas_bottom).offset(20);

    }];
    [self.titleOneDetailTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.linkLab.mas_bottom).offset(20);

    }];
    [self.titleOneDetailThirdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleOneDetailTwoLab.mas_bottom).offset(17);
        make.right.offset(-15);
    }];

    [self.titleTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleOneDetailThirdLab.mas_bottom).offset(22);
        make.right.offset(-15);
    }];
    [self.titleTwoDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleTwoLab.mas_bottom).offset(10);
        make.right.offset(-15);
    }];
}

- (UILabel *)titleOneLab {
    if (!_titleOneLab) {
        _titleOneLab = [[UILabel alloc]init];
        _titleOneLab.textAlignment = NSTextAlignmentLeft;
        _titleOneLab.textColor = kBlackColor;
        _titleOneLab.text = @"1. 检查网络权限是否打开";
        _titleOneLab.font = ADaptedFontBoldSize(15);
    }
    return _titleOneLab;
}
- (UILabel *)titleOneDetailoneLab {
    if (!_titleOneDetailoneLab) {
        _titleOneDetailoneLab = [[UILabel alloc]init];
        _titleOneDetailoneLab.textAlignment = NSTextAlignmentLeft;
        _titleOneDetailoneLab.textColor = kBlackColor;
        NSString *string = @"打开【设置】-【蜂窝移动网络】-【使用无线局域网与蜂窝的应用】，找到【空虾】，勾选【无线局域网与蜂窝移动数据】即可。";
        _titleOneDetailoneLab.numberOfLines = 0 ;
        [UILabel settingLabelTextAttributesWithLineSpacing:5 FirstLineHeadIndent:0 FontOfSize:15 TextColor:kBlackColor text:string AddLabel:_titleOneDetailoneLab];
    }
    return _titleOneDetailoneLab;
}
- (UILabel *)titleOneDetailTwoLab {
    if (!_titleOneDetailTwoLab) {
        _titleOneDetailTwoLab = [[UILabel alloc]init];
        _titleOneDetailTwoLab.textAlignment = NSTextAlignmentLeft;
        NSString *string  = @"如果在【使用无线局域网与蜂窝移动的应用】中，未找到【空虾】，请重启手机再次尝试。";
        _titleOneDetailTwoLab.numberOfLines = 0 ;
    [UILabel settingLabelTextAttributesWithLineSpacing:5 FirstLineHeadIndent:0 FontOfSize:15 TextColor:kBlackColor text:string AddLabel:_titleOneDetailTwoLab];
    }
    return _titleOneDetailTwoLab;
}

- (UILabel *)titleOneDetailThirdLab {
    if (!_titleOneDetailThirdLab) {
        _titleOneDetailThirdLab = [[UILabel alloc]init];
        _titleOneDetailThirdLab.textAlignment = NSTextAlignmentLeft;
        NSString *string  = @"如果您的手机不是中国版，则：打开【设置】-【蜂窝移动网络】，找到【空虾】，启用开关即可。";
        _titleOneDetailThirdLab.numberOfLines = 0 ;
        [UILabel settingLabelTextAttributesWithLineSpacing:5 FirstLineHeadIndent:0 FontOfSize:15 TextColor:kBlackColor text:string AddLabel:_titleOneDetailThirdLab];

    }
    return _titleOneDetailThirdLab;
}

- (TTTAttributedLabel *)linkLab
{
    if (!_linkLab) {
        _linkLab = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _linkLab.textAlignment = NSTextAlignmentLeft;
        _linkLab.textColor = kBlackTextColor;
        _linkLab.font = CustomFont(15);
        _linkLab.numberOfLines = 0;
        _linkLab.delegate = self;
        _linkLab.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[RGBCOLOR(74, 144, 226) CGColor]};
        _linkLab.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _linkLab.userInteractionEnabled = YES;
        NSString *string = @"立即去设置>>";
        _linkLab.text = string;
        [_linkLab addLinkToURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] withRange:[string rangeOfString:string]];
    }
    return _linkLab;
}
- (UILabel *)titleTwoLab {
    if (!_titleTwoLab) {
        _titleTwoLab = [[UILabel alloc]init];
        _titleTwoLab.textAlignment = NSTextAlignmentLeft;
        _titleTwoLab.textColor = kBlackColor;
        _titleTwoLab.text = @"2、检查本地网络状况";
        _titleTwoLab.font = ADaptedFontBoldSize(15);
    }
    return _titleTwoLab;
}

- (UILabel *)titleTwoDetailLab {
    if (!_titleTwoDetailLab) {
        _titleTwoDetailLab = [[UILabel alloc]init];
        _titleTwoDetailLab.textAlignment = NSTextAlignmentLeft;
        NSString *string = @"请查看您本地的无线网络或手机信号情况，信号差或者打开飞行模式时，也无法正常获取数据";
        _titleTwoDetailLab.numberOfLines = 0 ;
        [UILabel settingLabelTextAttributesWithLineSpacing:5 FirstLineHeadIndent:0 FontOfSize:15 TextColor:kBlackColor text:string AddLabel:_titleTwoDetailLab];
    }
    return _titleTwoDetailLab;
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else{
        NSLog(@"can not open");
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
