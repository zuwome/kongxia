//
//  ZZRentMemedaViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaViewController.h"
#import "ZZTableView.h"
#import "ZZRentMemedaQuestionViewController.h"
#import "ZZRentMemedaTopicChooseViewController.h"
#import "ZZPayViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZContributionViewController.h"
#import "ZZRentViewController.h"
#import "ZZChatViewController.h"

#import "ZZRentMemedaInfoView.h"
#import "ZZRentMemedaTopicView.h"
#import "ZZVideoAlertView.h"
#import "ZZRentDynamicCell.h"
#import "ZZRightShareView.h"
#import "ZZMemedaAlertView.h"

#import "ZZMemedaTopicModel.h"
#import "ZZMemedaModel.h"
#import "ZZMemedaQuestionModel.h"
@interface ZZRentMemedaViewController () <UITableViewDataSource,UITableViewDelegate>
{
    ZZVideoAlertView                        *_alertView;
    ZZUser                                  *_user;
    ZZRightShareView                        *_shareView;
    ZZMemedaAlertView                       *_infoAlertView;
}

@property (nonatomic, strong) ZZTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *topicsArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) ZZMMDModel *mmdModel;
@property (nonatomic, strong) ZZRentMemedaTopicView *topicView;
@property (nonatomic, strong) ZZRentMemedaInfoView *infoView;
@property (nonatomic, assign) BOOL showList;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) BOOL isInYellow;
@property (nonatomic, strong) NSString *question;

@end

@implementation ZZRentMemedaViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"TA的么么答";
    self.navigationItem.title = @"发红包";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

- (void)createNavigationRightBtn
{
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationRightBtnClick)];
    self.navigationItem.rightBarButtonItem = more;
}

- (void)createViews
{
    _tableView = [[ZZTableView alloc] init];
    [_tableView registerClass:[ZZRentDynamicCell class] forCellReuseIdentifier:@"mycell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.tableHeaderView = [self createHeadView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self reloadTableView];
}

- (UIView *)createHeadView
{
    __weak typeof(self)weakSelf = self;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    _infoView = [[ZZRentMemedaInfoView alloc] init];
    [_infoView setData:_user];
    [_headView addSubview:_infoView];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_top);
        make.left.mas_equalTo(_headView.mas_left);
        make.right.mas_equalTo(_headView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    CGFloat infoHeight = [_infoView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height ;
    
    _topicView = [[ZZRentMemedaTopicView alloc] init];
    _topicView.touchRandom = ^{
        [weakSelf chooseQuestionBtnClick];
    };
    _topicView.touchTopic = ^{
        [weakSelf chooseTopicBtnClick];
    };
    _topicView.removeIndex = ^(NSInteger index){
        [weakSelf removeTopicIndex:index];
    };
    _topicView.touchTopicInfo = ^{
        [weakSelf showTopicInfo];
    };
    _topicView.touchEditType = ^{
        CGFloat height = [weakSelf.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        weakSelf.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        weakSelf.tableView.tableHeaderView = weakSelf.headView;
        
        [weakSelf reloadTableView];
    };
    _topicView.beginEdit = ^{
        weakSelf.lastOffsetY = weakSelf.tableView.contentOffset.y;
        weakSelf.tableView.contentOffset = CGPointMake(0, infoHeight);
    };
    _topicView.endEdit = ^{
        weakSelf.tableView.contentOffset = CGPointMake(0, weakSelf.lastOffsetY);
    };
    [_headView addSubview:_topicView];
    
    [_topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_left);
        make.right.mas_equalTo(_headView.mas_right);
        make.top.mas_equalTo(_infoView.mas_bottom).offset(15);
    }];
    
    _isPrivate = YES;
    NSString *askType = [ZZUserHelper shareInstance].lastAskType;
    if ([askType isEqualToString:@"private"]) {
        [_topicView privateStatus];
    } else if (![askType isEqualToString:@"publick"] && _isPrivate) {
        [_topicView privateStatus];
    } else {
        [_topicView publicStatus];
    }
    
    UIButton *payBtn = [[UIButton alloc] init];
    payBtn.backgroundColor = kRedTextColor;
    payBtn.layer.cornerRadius = 5;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:payBtn];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_left).offset(15);
        make.right.mas_equalTo(_headView.mas_right).offset(-15);
        make.top.mas_equalTo(_topicView.mas_bottom);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(_headView.mas_bottom).offset(-80);
    }];
    
    UIView *payBgView = [[UIView alloc] init];
    payBgView.userInteractionEnabled = NO;
    [payBtn addSubview:payBgView];
    
    [payBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(payBtn.mas_centerX);
        make.top.mas_equalTo(payBtn.mas_top);
        make.bottom.mas_equalTo(payBtn.mas_bottom);
    }];
    
    UIImageView *payImgView = [[UIImageView alloc] init];
    payImgView.image = [UIImage imageNamed:@"icon_rent_memeda_pay"];
    [payBgView addSubview:payImgView];
    
    [payImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payBgView.mas_left);
        make.centerY.mas_equalTo(payBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 17));
    }];
    
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.textAlignment = NSTextAlignmentRight;
    payLabel.textColor = [UIColor whiteColor];
    payLabel.font = [UIFont systemFontOfSize:16];
    payLabel.text = @"发红包";
    [payBgView addSubview:payLabel];
    
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(payBgView.mas_centerY);
        make.right.mas_equalTo(payBgView.mas_right);
        make.left.mas_equalTo(payImgView.mas_right).offset(10);
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = kGrayContentColor;
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.text = @"对方48小时内未回应，钱款将退回您的钱包";
    [_headView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headView.mas_centerX);
        make.top.mas_equalTo(payBtn.mas_bottom).offset(15);
    }];
    
    CGFloat height = [_headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    
    return _headView;
}

- (void)reloadTableView
{
    _showList = _topicView.isPublic;
    
    [_tableView reloadData];
}

#pragma mark - Data

- (void)loadData
{
    [ZZHUD showWithStatus:@"加载中..."];
    [ZZUser loadUser:_uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _user = [ZZUser yy_modelWithJSON:data];;
            
            if (_user.banStatus) {
                [UIAlertView showWithTitle:@"提示" message:@"该用户已被封禁!" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [self createNavigationRightBtn];
                [self createViews];
                
                [self getHotMMD];
            }
        }
    }];
}

- (void)getHotMMD
{
    ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
    [model getHotMemedaUid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _dataArray = [ZZMemedaModel arrayOfModelsFromDictionaries:data error:nil];
            [_tableView reloadData];
            
            if (![ZZUserHelper shareInstance].firstAskMemeda) {
//                [self showTopicInfo];
                [ZZUserHelper shareInstance].firstAskMemeda = @"firstAskMemeda";
            }
        }
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showList ? _dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    ZZRentDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    cell.contributionView.touchContribution = ^{
        [weakSelf contributionBtnClick:indexPath];
    };
    [self setupCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)setupCell:(ZZRentDynamicCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell setMMDData:_dataArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:@"mycell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf setupCell:cell indexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_showList) {
        return _dataArray.count == 0 ? 0.1 :34;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count == 0 || !_showList) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = kBGColor;
    
    UILabel *sumLabel = [[UILabel alloc] init];
    sumLabel.textAlignment = NSTextAlignmentLeft;
    sumLabel.textColor = kGrayContentColor;
    sumLabel.font = [UIFont systemFontOfSize:14];
    sumLabel.text = [NSString stringWithFormat:@"%@共回答了%ld个问题",_user.nickname,_user.answer_count];
    [headView addSubview:sumLabel];
    
    [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.textColor = kGrayContentColor;
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.text = [NSString stringWithFormat:@"%ld人看过",_user.mmd_seen_count];
    [headView addSubview:countLabel];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView.mas_right).offset(-15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_showList) {
        return _dataArray.count == 0 ? 190:0.1;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count != 0 || !_showList) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    } else {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        footView.backgroundColor = kBGColor;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_rent_memeda_empty"];
        [footView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(footView.mas_top).offset(40);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kGrayTextColor;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"暂无内容";
        [footView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(12);
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.textColor = kGrayTextColor;
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.numberOfLines = 0;
        infoLabel.text = @"点击右上角分享TA的主页，邀请朋友来提问";
        [footView addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView.mas_left).offset(15);
            make.right.mas_equalTo(footView.mas_right).offset(-15);
            make.bottom.mas_equalTo(footView.mas_bottom).offset(-35);
        }];
        
        return footView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    ZZMemedaModel *model = _dataArray[indexPath.row];
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.mid = model.mmd.mid;
    controller.deleteCallBack = ^{
        [weakSelf.dataArray removeObject:model];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstMMDModel = model.mmd;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)navigationRightBtnClick
{
    NSInteger index = arc4random() % 4;
    NSString *titleStr = @"么么答，你敢红包提问，我就敢视频接招！";
    NSString *contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去挖料吧",_user.nickname];
    switch (index) {
        case 0:
        {
            titleStr = @"么么答，你敢红包提问，我就敢视频接招！";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去挖料吧",_user.nickname];
        }
            break;
        case 1:
        {
            titleStr = @"么么答，红包真心话大冒险，想来挑战吗？";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去提问吧",_user.nickname];
        }
            break;
        case 2:
        {
            titleStr = @"么么答，能赚钱的短视频问答，等你来玩~";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去提问吧",_user.nickname];
        }
            break;
        case 3:
        {
            titleStr = @"么么答，邀请你来玩有趣有料的视频问答~";
            contentStr = [NSString stringWithFormat:@"%@开通了「么么答」，想知道TA更多猛料？抓紧时间来问！",_user.nickname];
        }
            break;
        default:
            break;
    }
    
    __weak typeof(self)weakSelf = self;
    if (!_shareView) {
        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf];
        
        _shareView.shareTitle = titleStr;
        _shareView.shareContent = contentStr;
        _shareView.shareUrl = [NSString stringWithFormat:@"%@/user/%@/mmd/page", kBase_URL, _user.uid];
        _shareView.shareImg = _infoView.shareImg;
        _shareView.uid = _user.uid;
        ZZPhoto *photo = [[ZZPhoto alloc] init];
        if (_user.photos.count) {
            photo = _user.photos[0];
        } else {
            photo.url = _user.avatar;
        }
        _shareView.userImgUrl = photo.url;
        [self.view.window addSubview:_shareView];
    } else {
        _shareView.shareTitle = titleStr;
        _shareView.shareContent = contentStr;
        [_shareView show];
    }
}

- (void)contributionBtnClick:(NSIndexPath *)indexPath
{
    ZZMemedaModel *model = _dataArray[indexPath.row];
    ZZContributionViewController *controller = [[ZZContributionViewController alloc] init];
    controller.mid = model.mmd.mid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)payBtnClick
{
    if ([ZZUtils isConnecting]) {
        return;
    }
    [MobClick event:Event_click_ask_ask];
//    if (isNullString(_topicView.questionTV.text)) {
//        [ZZHUD showErrorWithStatus:@"请输入问题"];
//        return;
//    }
//    NSString *str = [ZZUtils deleteEmptyStrWithString:_topicView.questionTV.text];
//    if (isNullString(str)) {
//        [ZZHUD showErrorWithStatus:@"问题不能全空格"];
//        return;
//    }
    [self.view endEditing:YES];

 
    [self checkQuestion];
}

- (void)checkQuestion
{
    NSInteger type = 4;
    if (_topicView.isPublic) {
        type = 3;
    }
    _question = _topicView.questionTV.text;
    if (isNullString(_question)) {
        if (_topicView.isPublic) {
            _question = @"你那么好看，可以赏个脸吗？";
        } else {
            _question = @"遇见你很高兴";
        }
    }
    [ZZUserHelper checkTextWithText:_question type:type next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (error.code == 2001) {
                [UIAlertView showWithTitle:@"提示" message:error.message cancelButtonTitle:@"修改问题" otherButtonTitles:@[@"继续提问"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [_topicView.questionTV becomeFirstResponder];
                    } else {
                        _isInYellow = YES;
                        [ZZHUD showWithStatus:@"获取支付信息..."];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.view endEditing:YES];
                            [self loadBalance];
                        });
                    }
                }];
            } else if  (error.code == 2002) {
                [UIAlertView showWithTitle:@"提示" message:error.message cancelButtonTitle:@"修改问题" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    [_topicView.questionTV becomeFirstResponder];
                }];
            } else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else {
            _isInYellow = NO;
            [ZZHUD showWithStatus:@"获取支付信息..."];
            [self loadBalance];
        }
    }];
}

- (void)loadBalance
{
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
            
            [self createAlertView];
        }
    }];
}

- (void)createAlertView
{
    __weak typeof(self)weakSelf = self;
    if (!_alertView) {
        _alertView = [[ZZVideoAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertView.serviceScale = [ZZUserHelper shareInstance].configModel.yj.mmd;
        _alertView.ctl = weakSelf;
        _alertView.user = _user;
        if ([ZZUserHelper shareInstance].lastAskMoney) {
            _alertView.inputTF.text = [ZZUserHelper shareInstance].lastAskMoney;
        }
        [_alertView calculatePrice];
        _alertView.payCallBack = ^{
            [weakSelf payCallBack];
        };
        _alertView.rechargeCallBack = ^{
            [ZZHUD showWithStatus:@"充值成功，余额更新中..."];
            [weakSelf loadBalance];
        };
        [self.view.window addSubview:_alertView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView.inputTF becomeFirstResponder];
        });
    } else {
        _alertView.hidden = NO;
        [_alertView showFirstResponder];
        [_alertView showInfoText];
    }
    _alertView.content = _question;
    _alertView.topicsArray = _topicsArray;
    if (_topicView.isPublic) {
        _alertView.moneyArray = @[@"5.5",@"6.6",@"8.8",@"10",@"15",@"20",@"30",@"50"];
        if ([ZZUserHelper shareInstance].configModel) {
            _alertView.inputTF.placeholder = [NSString stringWithFormat:@"%@~2000",[ZZUserHelper shareInstance].configModel.mmd.public_min_price];
        } else {
            _alertView.inputTF.placeholder = @"5~2000";
        }
        _alertView.type = AlertPayTypeMemeda;
        _alertView.isAnonymous = _topicView.isAnonymous;
    } else {
        _alertView.moneyArray = @[@"20",@"30",@"50",@"66",@"88",@"99",@"128",@"150"];
        
        if ([ZZUserHelper shareInstance].configModel) {
            _alertView.inputTF.placeholder = [NSString stringWithFormat:@"%@~2000",[ZZUserHelper shareInstance].configModel.mmd.private_min_price];
        } else {
            _alertView.inputTF.placeholder = @"6~2000";
        }
        _alertView.type = AlertPayTypePacket;
    }
    _alertView.isInYellow = _isInYellow;
}

- (void)payCallBack
{
    if (_topicView.isPublic) {
        [ZZHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (!_fromChat) {
        [ZZHUD showSuccessWithStatus:@"发送成功"];
        ZZChatViewController *controller = [[ZZChatViewController alloc] init];
        controller.mid = _alertView.mid;
        controller.content = _question;
        controller.user = _user;
        controller.uid = _user.uid;
        controller.nickName = _user.nickname;
        controller.portraitUrl = _user.avatar;
        controller.isInYellow = _isInYellow;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [ZZHUD showSuccessWithStatus:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (_askCallBack) {
            _askCallBack(_question,_alertView.mid,_isInYellow);
        }
    }
}

- (void)chooseTopicBtnClick
{
    __weak typeof(self)weakSelf = self;
    if (_topicsArray.count == 3) {
        [ZZHUD showErrorWithStatus:@"最多选择3个标签"];
        return;
    }
    [self.view endEditing:YES];
    ZZRentMemedaTopicChooseViewController *controller = [[ZZRentMemedaTopicChooseViewController alloc] init];
    controller.selectCallBack = ^(ZZMemedaTopicModel *topic) {
        [weakSelf.topicView addTopic:topic.content];
        CGFloat height = [weakSelf.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        weakSelf.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        weakSelf.tableView.tableHeaderView = weakSelf.headView;
        if (!weakSelf.topicsArray) {
            weakSelf.topicsArray = [NSMutableArray array];
        }
        [weakSelf.topicsArray addObject:[topic toDictionary]];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)removeTopicIndex:(NSInteger)index
{
    [_topicsArray removeObjectAtIndex:index];
    CGFloat height = [_headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _tableView.tableHeaderView = _headView;
}

- (void)chooseQuestionBtnClick
{
    __weak typeof(self)weakSelf = self;
    [self.view endEditing:YES];
    ZZRentMemedaQuestionViewController *controller = [[ZZRentMemedaQuestionViewController alloc] init];
    controller.selectCallBack = ^(ZZMemedaQuestionModel *question) {
        [weakSelf.topicView setQuestion:question.content];
        [question.groups enumerateObjectsUsingBlock:^(ZZMemedaTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            weakSelf.topicView.isEdit = NO;
            [weakSelf.topicView.topicArray removeAllObjects];
            [weakSelf.topicView addTopic:model.content];
            CGFloat height = [weakSelf.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            weakSelf.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
            weakSelf.tableView.tableHeaderView = weakSelf.headView;
            if (!weakSelf.topicsArray) {
                weakSelf.topicsArray = [NSMutableArray array];
            } else {
                [weakSelf.topicsArray removeAllObjects];
            }
            [weakSelf.topicsArray addObject:[model toDictionary]];
        }];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

//标签介绍
- (void)showTopicInfo
{
    [self.view endEditing:YES];
    if (!_infoAlertView) {
        _infoAlertView = [[ZZMemedaAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_infoAlertView];
    } else {
        _infoAlertView.hidden = NO;
    }
}

- (void)dealloc
{
    [_alertView removeFromSuperview];
    _alertView = nil;
    [_shareView removeFromSuperview];
    _shareView = nil;
    [_infoAlertView removeFromSuperview];
    _infoAlertView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
