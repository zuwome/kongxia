//
//  ZZTopicClassifyViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTopicClassifyViewController.h"
#import "ZZSkillDetailViewController.h"
#import "ZZRentViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZSettingPrivacyViewController.h"
#import "ZZRealNameListViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZRentalAgreementVC.h"

#import "ZZTopicClassifyCell.h"

#import "ZZHomeModel.h"

@interface ZZTopicClassifyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
//datasource
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *sortValue;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ZZTopicClassifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self createNavigationRightDoneBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 0;
    [self createView];
}

- (void)createNavigationRightDoneBtn {
    //登录且未出租，则显示成为达人按钮 系统下架/或者在审核中rent.status == 3 || 2 不显示该button
    if ([ZZUserHelper shareInstance].isLogin && ([ZZUserHelper shareInstance].loginer.rent.status != 3 || [ZZUserHelper shareInstance].loginer.rent.status != 1)) {
        [super createNavigationRightDoneBtn];
        NSString *rightBtnTitle = @"";
        SEL action = nil;
        if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
            //未出租,申请成为达人
            rightBtnTitle = @"成为达人";
            action = @selector(gotoChuzu);
        }
        else if ([ZZUserHelper shareInstance].loginer.rent.status == 2) {
            //已上架
            rightBtnTitle = [ZZUserHelper shareInstance].loginer.rent.show ? @"完善技能" : @"去上架";
            action = [ZZUserHelper shareInstance].loginer.rent.show ? @selector(gotoChuzu) : @selector(showRent);
        }
        [self.navigationRightDoneBtn setTitle:rightBtnTitle forState:(UIControlStateNormal)];
        [self.navigationRightDoneBtn setTitle:rightBtnTitle forState:(UIControlStateHighlighted)];
        [self.navigationRightDoneBtn addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    }
}

// 提取方法 统一判断是否需要去完善头像/人脸
- (BOOL)isReturnWithType:(NavigationType)type {
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
        NSString *tips = @"";
        if (type == NavigationTypeApplyTalent) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息";
        }
        else if (type == NavigationTypeWeChat) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法设置微信号";
        }
        else if (type == NavigationTypeRealName) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法实名认证";
        }
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                // 去验证人脸
                [weakSelf gotoVerifyFace:type];
            }
        }];
        return YES;
    }
    return NO;
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];

}

// 没有头像，则上传真实头像
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    //    vc.from = _user;//不需要用到
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 申请达人(出租自己)
- (void)gotoChuzu {
    // 判断当前操作是否需要做验证 release_rent：发布出租信息操作
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:@"release_rent"] != NSNotFound) {
        if ([self isReturnWithType:NavigationTypeApplyTalent]) {
            return;
        }
    }
    WEAK_SELF();
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {
        // 有开启出租收费
        
        if (loginer.gender_status == 2) {
            // 需要先去完善身份证信息
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.user = loginer;
                    controller.isRentPerfectInfo = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
            return;
        }
        
        if (loginer.rent_need_pay) {
            //此人出租需要付费
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) {
                // 需要先去同意协议
                [self gotoRentalAgreementVC];
            }
            else {
                [self registerRent];
            }
        }
        else {   //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            [self registerRent];
        }
    }
    else {
        // 没有开启出租收费功能
        // 服务端开关，是否验证身份证
        if ([ZZUserHelper shareInstance].configModel.qchat.need_idcard_verify &&
            ((loginer.realname.status == 0 || loginer.realname.status == 3) && (loginer.realname_abroad.status == 0 || loginer.realname_abroad.status == 3))) {// 需要先去完善身份证信息
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.user = loginer;
                    controller.isRentPerfectInfo = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
            return;
        }
        // 服务端如果没有开关，则自己也需要本地判断是否需要验证
        if (loginer.gender_status == 2) {
            // 本身性别有误，也需要验证身份证
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.user = loginer;
                    controller.isRentPerfectInfo = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
        }
        else {
            /*
             未出租:
                1. 有真实头像,或者可用旧头像:跳转出租
                2. 无真实头像:
                    a: 没有人工审核的头像: 跳转到上传头像的页面区
                    b: 正在人工审核,: 跳转到编辑出租的页面
            */
            if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
                
                if ([UserHelper didHaveRealAvatar] || ([UserHelper isAvatarManualReviewing] && [UserHelper didHaveOldAvatar])) {
                    // 有真实头像,或者可用旧头像:跳转出租
                    [self registerRent];
                }
                else {
                    // 无真实头像
                    if ([UserHelper isAvatarManualReviewing]) {
                        // 正在人工审核
                        [self registerRent];
                    }
                    else {
                        // 没有人工审核的头像
                        [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像"
                                                                   message:nil
                                                                 doneTitle:@"去上传"
                                                               cancelTitle:@"取消"
                                                             completeBlock:^(BOOL isCancelled) {
                                                                 if (!isCancelled) {
                                                                     [self gotoUploadPicture:NavigationTypeApplyTalent];
                                                                 }
                                                             }];
                    }
                }
                return;
            }
            [self registerRent];
        }
    }
}

// 出租协议
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerRent {
    WeakSelf
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    } else {
        ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (![ZZUserHelper shareInstance].userFirstRent) {
        [ZZUserHelper shareInstance].userFirstRent = @"userFirstRent";
    }
}

- (void)toTopicManager {    //跳转到管理主题界面
    ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showRent {  //跳转设置中的隐私页面
    [MobClick event:Event_click_setting_privacy];
    ZZSettingPrivacyViewController *controller = [[ZZSettingPrivacyViewController alloc] init];
    controller.user = [ZZUserHelper shareInstance].loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setTopic:(ZZHomeCatalogModel *)topic {
    _topic = topic;
    self.navigationItem.title = topic.name;
    [self.tableview.mj_header beginRefreshing];
}

- (void)createView {
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)getTopics { //下拉刷新
    self.sortValue = @"";
    _pageIndex = 0;
    [ZZHomeModel getUserUnderSkill:self.topic.id withSortValue:self.sortValue pageIndex:_pageIndex next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            [self.dataArray removeAllObjects];
            for (NSDictionary *userDict in data) {
                ZZUserUnderSkillModel *model = [[ZZUserUnderSkillModel alloc] initWithDictionary:userDict error:nil];
                [self.dataArray addObject:model];
            }
            [self.tableview reloadData];
        }
    }];
}

- (void)getMoreTopics { //上拉加载更多
    self.sortValue = [[self.dataArray lastObject] valueForKey:@"sortValue"];
    _pageIndex ++;
    [ZZHomeModel getUserUnderSkill:self.topic.id withSortValue:self.sortValue pageIndex:_pageIndex next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableview.mj_footer endRefreshing];
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            NSArray *userArray = data;
            if (userArray.count == 0) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            } else {
                for (NSDictionary *userDict in data) {
                    ZZUserUnderSkillModel *model = [[ZZUserUnderSkillModel alloc] initWithDictionary:userDict error:nil];
                    [self.dataArray addObject:model];
                }
                [self.tableview reloadData];
            }
        }
    }];
}

- (void)gotoUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.isFromHome = NO;
    controller.user = user;
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoSkillDetail:(ZZUser *)user withTopic:(ZZTopic *)topic {
    ZZSkillDetailViewController *controller = [[ZZSkillDetailViewController alloc] init];
    controller.user = user;
    controller.topic = topic;
    controller.isHideBar = NO;
    controller.fromLiveStream = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZTopicClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicClassifyCellId forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
    [cell setGotoUserInfo:^(ZZUser *user) {
        [self gotoUserInfo:user];
    }];
    [cell setGotoSkillDetail:^(ZZUser *user, ZZTopic *topic) {
        [self gotoSkillDetail:user withTopic:topic];
    }];
    return cell;
}

- (UIView *)tableViewHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 76)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *name = [[UILabel alloc] init];
    name.text = self.topic.name;
    name.textColor = kBlackColor;
    name.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    [header addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@20);
    }];
    UILabel *summary = [[UILabel alloc] init];
    summary.text = self.topic.summary;
    summary.textColor = kBrownishGreyColor;
    summary.font = [UIFont systemFontOfSize:14];
    [header addSubview:summary];
    [summary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).offset(10);
        make.trailing.bottom.equalTo(@-15);
        make.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
    return header;
}

- (UITableView *)tableview {
    if (nil == _tableview) {
        WeakSelf
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 200;
        _tableview.height = UITableViewAutomaticDimension;
        _tableview.tableHeaderView = [self tableViewHeader];
        [_tableview registerClass:[ZZTopicClassifyCell class] forCellReuseIdentifier:TopicClassifyCellId];
        
        _tableview.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf getTopics];
        }];
        _tableview.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf getMoreTopics];
        }];
    }
    return _tableview;
}
- (NSMutableArray *)dataArray {
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
