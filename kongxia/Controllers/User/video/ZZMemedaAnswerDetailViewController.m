//
//  ZZMemedaAnswerDetailViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaAnswerDetailViewController.h"
#import "ZZRentViewController.h"
#import "ZZReportViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZRecordViewController.h"

#import "ZZAttentView.h"
#import "ZZMemedaAlertView.h"
#import "TTTAttributedLabel.h"
#import "ZZUploader.h"
#import "ZZReportModel.h"

#import <RongIMKit/RongIMKit.h>
#import "ZZMemedaModel.h"
#import <QiniuSDK.h>

@interface ZZMemedaAnswerDetailViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) ZZAttentView *attentView;
@property (nonatomic, assign) BOOL isBan;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) ZZMemedaAlertView *alertView;
@property (nonatomic, strong) ZZMemedaModel *model;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;
@property (nonatomic, assign) BOOL isReporting;

@end

@implementation ZZMemedaAnswerDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"回答问题";
    
    self.view.backgroundColor = kBGColor;
    [self initRightButton];
    [self loadData];
}

- (void)initRightButton {
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = more;
}

- (void)loadData
{
    if (!_mid) {
        _mid = _model.mmd.mid;
    }
    [ZZMemedaModel getMemedaDetaiWithMid:_mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _model = [[ZZMemedaModel alloc] initWithDictionary:data error:nil];
            [self createViews];
        }
    }];
}

- (void)createViews
{
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:_model.mmd.from.uid success:^(int bizStatus) {
        if (bizStatus == 0) {
            _isBan = YES;
        } else {
            _isBan = NO;
        }
    } error:^(RCErrorCode status) {
        
    }];
    __weak typeof(self)weakSelf = self;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kBGColor;
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    ZZHeadImageView *headImgView = [[ZZHeadImageView alloc] init];
    [bgView addSubview:headImgView];
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(15);
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [headImgView setUser:_model.mmd.from width:50 vWidth:10];
    
    headImgView.isAnonymous = _model.mmd.is_anonymous;
    headImgView.touchHead = ^{
        [weakSelf headBtnClick];
    };
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = kBlackTextColor;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = _model.mmd.from.nickname;
    [bgView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImgView.mas_right).offset(8);
        make.bottom.mas_equalTo(headImgView.mas_centerY);
    }];
    
    UIImageView *sexImgView = [[UIImageView alloc] init];
    sexImgView.contentMode = UIViewContentModeScaleToFill;
    sexImgView.image = [UIImage imageNamed:@"boy"];
    [bgView addSubview:sexImgView];
    
    [sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    if (_model.mmd.from.gender == 2) {
        sexImgView.image = [UIImage imageNamed:@"girl"];
    } else if (_model.mmd.from.gender == 1) {
        sexImgView.image = [UIImage imageNamed:@"boy"];
    } else {
        sexImgView.image = [UIImage new];
    }
    
    if (_model.mmd.from.weibo.verified) {
        UIImageView *vImgView = [[UIImageView alloc] init];
        vImgView.image = [UIImage imageNamed:@"v"];
        vImgView.contentMode = UIViewContentModeScaleToFill;
        [bgView addSubview:vImgView];
        
        [vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_left);
            make.top.mas_equalTo(headImgView.mas_centerY).offset(5);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        UILabel *vLabel = [[UILabel alloc] init];
        vLabel.textAlignment = NSTextAlignmentLeft;
        vLabel.textColor = kGrayTextColor;
        vLabel.font = [UIFont systemFontOfSize:12];
        vLabel.text = _model.mmd.from.weibo.verified_reason;
        [bgView addSubview:vLabel];
        
        [vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(vImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(vImgView.mas_centerY);
            make.right.mas_equalTo(bgView.mas_right).offset(-90);
        }];
    }
    
    _attentView = [[ZZAttentView alloc] init];
    _attentView.fontSize = 14;
    _attentView.touchAttent = ^{
        [weakSelf attentBtnClick];
    };
    [bgView addSubview:_attentView];
    
    [_attentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
    
    _attentView.listFollow_status = _model.mmd.from.follow_status;
    
    if (_model.mmd.is_anonymous) {
        _attentView.hidden = YES;
    }
    
    UIView *contentBgView = [[UIView alloc] init];
    contentBgView.backgroundColor = [UIColor whiteColor];
    contentBgView.layer.cornerRadius = 5;
    [bgView addSubview:contentBgView];
    
    [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.top.mas_equalTo(headImgView.mas_bottom).offset(12);
    }];
    
    contentBgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    contentBgView.layer.shadowOffset = CGSizeMake(0, 1);
    contentBgView.layer.shadowOpacity = 0.9;
    contentBgView.layer.shadowRadius = 1;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = kBlackTextColor;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = [NSString stringWithFormat:@"问题：%@",_model.mmd.content];
    [contentBgView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentBgView.mas_left).offset(10);
        make.right.mas_equalTo(contentBgView.mas_right).offset(-10);
        make.top.mas_equalTo(contentBgView.mas_top).offset(10);
    }];
    
    UIImageView *lineImgView = [[UIImageView alloc] init];
    lineImgView.image = [UIImage imageNamed:@"icon_rent_line"];
    lineImgView.contentMode = UIViewContentModeScaleToFill;
    [contentBgView addSubview:lineImgView];
    
    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentLabel.mas_left);
        make.right.mas_equalTo(contentLabel.mas_right);
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = HEXCOLOR(0xadadb1);
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.text = @"录制视频回答后可获得赏金，并会公开显示";
    infoLabel.numberOfLines = 0;
    [contentBgView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineImgView.mas_bottom).offset(10);
        make.left.mas_equalTo(contentLabel.mas_left);
        make.right.mas_equalTo(contentLabel.mas_right);
    }];
    
    UIButton *publicBtn = [[UIButton alloc] init];
    [bgView addSubview:publicBtn];
    
    [publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(contentBgView.mas_left);
        make.width.mas_equalTo(@65);
    }];
    
    UIImageView *publicImgView = [[UIImageView alloc] init];
    publicImgView.image = [UIImage imageNamed:@"icon_memeda_public"];
    publicImgView.contentMode = UIViewContentModeScaleToFill;
    publicImgView.userInteractionEnabled = NO;
    [publicBtn addSubview:publicImgView];
    
    [publicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(publicBtn.mas_left).offset(10);
        make.centerY.mas_equalTo(publicBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(54, 23));
    }];
    
    UIButton *questionBtn = [[UIButton alloc] init];
    [questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentBgView addSubview:questionBtn];
    
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(publicBtn.mas_right).offset(10);
        make.bottom.mas_equalTo(contentBgView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIImageView *questionImgView = [[UIImageView alloc] init];
    questionImgView.contentMode = UIViewContentModeScaleToFill;
    questionImgView.image = [UIImage imageNamed:@"btn_memeda_question"];
    questionImgView.userInteractionEnabled = NO;
    [questionBtn addSubview:questionImgView];
    
    [questionImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(publicBtn.mas_centerY);
        make.left.mas_equalTo(questionBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = kGrayContentColor;
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.text = _model.mmd.created_at_text;
    [contentBgView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(questionBtn.mas_centerY);
        make.right.mas_equalTo(contentLabel.mas_right);
    }];
    
    UIButton *recordBtn = [[UIButton alloc] init];
    [recordBtn setTitle:@"点击录制视频回答" forState:UIControlStateNormal];
    [recordBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    recordBtn.backgroundColor = kYellowColor;
    recordBtn.layer.cornerRadius = 2;
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:recordBtn];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentBgView.mas_bottom).offset(40);
        make.left.mas_equalTo(contentBgView.mas_left);
        make.right.mas_equalTo(contentBgView.mas_right);
        make.height.mas_equalTo(@50);
    }];
    
    _attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _attributedLabel.backgroundColor = [UIColor clearColor];
    _attributedLabel.textAlignment = NSTextAlignmentCenter;
    _attributedLabel.textColor = kBlackTextColor;
    _attributedLabel.font = [UIFont systemFontOfSize:13];
    _attributedLabel.numberOfLines = 0;
    _attributedLabel.delegate = self;
    _attributedLabel.highlightedTextColor = [UIColor redColor];
    _attributedLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
    _attributedLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
    _attributedLabel.userInteractionEnabled = YES;
    [bgView addSubview:_attributedLabel];
    
    [_attributedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.top.mas_equalTo(recordBtn.mas_bottom).offset(15);
    }];
    
    NSString *str = @"如遇骚扰，请点击此处立即举报";
    NSRange range = [str rangeOfString:@"立即举报"];
    _attributedLabel.text = str;
    [_attributedLabel addLinkToURL:[NSURL URLWithString:@"立即举报"] withRange:range];
    
    if (_model.mmd.content_check_status == 1) {
        _attributedLabel.text = nil;
    }
    
    UILabel *recordInfoLabel1 = [[UILabel alloc] init];
    recordInfoLabel1.textAlignment = NSTextAlignmentCenter;
    recordInfoLabel1.textColor = HEXCOLOR(0xadadb1);
    recordInfoLabel1.font = [UIFont systemFontOfSize:12];
    recordInfoLabel1.numberOfLines = 0;
    recordInfoLabel1.text = @"超过48小时未回答 赏金将退回对方账户";
    [bgView addSubview:recordInfoLabel1];
    
    [recordInfoLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.top.mas_equalTo(_attributedLabel.mas_bottom).offset(5);
    }];
    
    UILabel *recordInfoLabel2 = [[UILabel alloc] init];
    recordInfoLabel2.textAlignment = NSTextAlignmentCenter;
    recordInfoLabel2.textColor = HEXCOLOR(0xadadb1);
    recordInfoLabel2.font = [UIFont systemFontOfSize:12];
    recordInfoLabel2.numberOfLines = 0;
    recordInfoLabel2.text = @"提倡文明互动 违规行为平台有权作出相应处罚";
    [bgView addSubview:recordInfoLabel2];
    
    [recordInfoLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
    }];
}

#pragma mark - UIButtonMethod

- (void)rightBtnClick
{
    if (!_model) {
        return;
    }
    [self showSheetActions:nil
                   message:nil
               cancelTitle:@"取消"
             cancelHandler:nil
                   actions:@[
        [alertAction createWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ZZReportViewController *controller = [[ZZReportViewController alloc] init];
                ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
                controller.uid = _model.mmd.from.uid;
                [self.navigationController presentViewController:navCtl animated:YES completion:NULL];
            });
        }],
        [alertAction createWithTitle:_isBan?@"取消拉黑":@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_isBan) {
                [ZZUser removeBlackWithUid:_model.mmd.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        _isBan = NO;
                        
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        
                        NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
                        if (!muArray) {
                            muArray = @[].mutableCopy;
                        }
                        
                        if ([muArray containsObject:_model.mmd.from.uid]) {
                            [muArray removeObject:_model.mmd.from.uid];
                        }
                        
                        [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
                        [userDefault synchronize];
                    }
                }];
            } else {
                [ZZUser addBlackWithUid:_model.mmd.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        _isBan = YES;
                    }
                }];
            }
        }],
    ]];
}

- (void)headBtnClick
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = _model.mmd.from.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)attentBtnClick
{
    _attentView.userInteractionEnabled = NO;
    ZZUser *user = [[ZZUser alloc] init];
    if (_model.mmd.from.follow_status == 0) {
        [user followWithUid:_model.mmd.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                _attentView.userInteractionEnabled = YES;
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                _model.mmd.from.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                _attentView.listFollow_status = _model.mmd.from.follow_status;
                _attentView.userInteractionEnabled = YES;
            }
        }];
    } else {
        [user unfollowWithUid:_model.mmd.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                _attentView.userInteractionEnabled = YES;
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                _model.mmd.from.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                _attentView.listFollow_status = _model.mmd.from.follow_status;
                _attentView.userInteractionEnabled = YES;
            }
        }];
    }
}

- (void)recordBtnClick
{
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            [self gotoRecord];
        }
    }];
}

- (void)gotoRecord
{
    [MobClick event:Event_click_video_record];
    ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
    controller.type = RecordTypeMemeda;
    controller.model = _model.mmd;
    controller.isHidePhoto = YES;
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:nil];
    
    controller.callBack = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)questionBtnClick
{
    if (!_alertView) {
        _alertView = [[ZZMemedaAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_alertView];
    } else {
        _alertView.hidden = NO;
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (_isReporting) {
        return;
    }
    _isReporting = YES;
    [ZZHUD showWithStatus:@"正在截图举报"];
    UIImage *image = [ZZUtils getViewImage:self.view.window];
    [ZZUploader uploadImage:image progress:^(NSString *key, float percent) {
        [ZZHUD showWithStatus:@"正在截图举报"];
    } success:^(NSString *url) {
        NSDictionary *param = @{@"photos":@[url]};
        [ZZReportModel reportWithParam:param uid:_model.mmd.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _isReporting = NO;
            if (data) {
                [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
                _attributedLabel.textColor = kRedColor;
                _attributedLabel.text = @"举报成功";
                _attributedLabel.textAlignment = NSTextAlignmentCenter;
            } else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        }];
    } failure:^{
        _isReporting = NO;
        [ZZHUD showErrorWithStatus:@"图片上传失败"];
    }];
}

- (void)dealloc
{
    [_alertView removeFromSuperview];
    _alertView = nil;
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
