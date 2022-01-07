//
//  ZZSkillDetailViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZRentMemedaViewController.h"
#import "ZZChatViewController.h"
#import "ZZSkillOptionViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZRentPageNavigationView.h"
#import "ZZRentPageBottomView.h"
#import "ESAutoHeightImageScroll.h"

#import "ZZSkillDetailBaseCell.h"
#import "ZZSkillDetailUserCell.h"
#import "ZZSkillDetailPriceCell.h"
#import "ZZSkillDetailContentCell.h"
#import "ZZSkillDetailScheduleCell.h"

#import "ZZDateHelper.h"

@interface ZZSkillDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat marginTop;      //列表据头部高度，（有无技能图片时，会隐藏顶部导航栏）
    CGFloat topHeight;      //头部预设高度
    CGFloat bottomHeight;   //底部栏高度
    BOOL isUserSelf;        //是否是当前用户本人
}

@property (nonatomic, strong) ZZSkill *skill;

@property (nonatomic, strong) ZZRentPageNavigationView *navigationView;//导航view
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ZZRentPageBottomView *bottomView;
@property (nonatomic, strong) ESAutoHeightImageScroll *imageScroll;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *tableHeader;
@property (nonatomic, strong) UIButton *bottomEditBtn;

@end

@implementation ZZSkillDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self getPassPhoto].count > 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
//    self.tabBarController.tabBar.hidden = YES;  //跳转聊天等界面后，返回后显示底部tabbar，未找到原因
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"技能详情";
    [self setInitialData];
    [self createView];
    [self reload];
    
    [self.tableview addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)setInitialData {
    self.skill = self.topic.skills[0];
    isUserSelf = [self.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid];
    marginTop = [self getPassPhoto].count > 0 ? 0 : NAVIGATIONBAR_HEIGHT;
    topHeight = SCREEN_WIDTH;
    bottomHeight = (isUserSelf && _type == SkillDetailTypeShow) ? 0 : isIPhoneX ? 89 : 55;
}

- (void)createView {
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.bottomEditBtn];
    if ([self getPassPhoto].count > 0) {
        [self.view addSubview:self.navigationView];
    }
}

- (void)reload {
    self.navigationView.titleLabel.text = @"技能详情";
    [self.tableview reloadData];
    if ((self.user.rent.status == 2 && self.user.rent.show)) {
        if ([UserHelper isUsersAvatarManuallReviewing:_user]) {
            if ([UserHelper canShowUserOldAvatarWhileIsManualReviewingg:_user]) {
                [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
                self.bottomView.rentBtn.backgroundColor = kYellowColor;
            }
            else {
                [self.bottomView.rentBtn setTitleColor:HEXCOLOR(0x979797) forState:UIControlStateNormal];
                self.bottomView.rentBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            }
        }
        else {
            [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            self.bottomView.rentBtn.backgroundColor = kYellowColor;
        }
    }
    else {
        [self.bottomView.rentBtn setTitleColor:HEXCOLOR(0x979797) forState:UIControlStateNormal];
        self.bottomView.rentBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    [self reloadUser];
}

- (void)reloadUser {
    if (![ZZUserHelper shareInstance].isLogin) {    //未登录不用请求
        [ZZUser getUnloginUserDetailWithUid:self.user.uid dic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                self.user = [[ZZUser alloc] initWithDictionary:data error:nil];
                [self.tableview reloadData];
            }
        }];
    } else {
        [ZZUser loadUser:self.user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                self.user = [[ZZUser alloc] initWithDictionary:data error:nil];
                [self.tableview reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.tableview removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.tableview) {
        CGPoint offset = [[change objectForKey:@"new"] CGPointValue];
        CGFloat scale = MIN(MAX(offset.y, 0), NAVIGATIONBAR_HEIGHT) / NAVIGATIONBAR_HEIGHT;
        self.navigationView.bgView.backgroundColor = [kGoldenRod colorWithAlphaComponent:scale];
        if (scale > 0.5) {
            self.navigationView.titleLabel.textColor = kBlackTextColor;
            self.navigationView.leftImgView.image = [UIImage imageNamed:@"back"];
            self.navigationView.rightImgView.image = [UIImage imageNamed:@"more"];
            self.navigationView.codeImgView.image = [UIImage imageNamed:@"icon_rent_code_black"];
        } else {
            self.navigationView.titleLabel.textColor = [UIColor whiteColor];
            self.navigationView.leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
            self.navigationView.rightImgView.image = [UIImage imageNamed:@"icon_rent_right"];
            self.navigationView.codeImgView.image = [UIImage imageNamed:@"icon_rent_code_white"];
        }
    }
}

#pragma mark -- 界面跳转
- (void)gotoVerifyFace:(NavigationType)type {   // 没有人脸，则验证人脸
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    helper.from = self.user;
    [helper start];
}
- (void)gotoUploadPicture:(NavigationType)type {    // 没有头像，则上传真实头像
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.from = self.user;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)gotoEditView:(ZZUser *)user {
    if (self.fromLiveStream) {
        return;
    }
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    [MobClick event:Event_click_me_icon];
    WeakSelf;
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoUserPage = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.editCallBack = ^{
        [weakSelf reload];
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)askBtnClick:(BOOL)isPrivate {
    if (self.fromLiveStream) {
        return;
    }
    
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    [self gotoChatView:YES];

//    if (![ZZUserHelper shareInstance].isLogin) {
//        [self gotoLoginView];
//        return;
//    }
//    if ([ZZUtils isBan]) {
//        return;
//    }
//    [MobClick event:Event_user_detail_add_mmd];
////    _isPush = YES;
//    ZZRentMemedaViewController *controller = [[ZZRentMemedaViewController alloc] init];
//    controller.uid = self.user.uid;
//    controller.popIndex = 1;
//    controller.isPrivate = isPrivate;
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoChatView:(BOOL)shouldShowGiftView {
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    [ZZRCUserInfoHelper setUserInfo:self.user];
    controller.user = self.user;
    controller.nickName = self.user.nickname;
    controller.uid = self.user.uid;
    controller.portraitUrl = self.user.avatar;
    controller.shouldShowGift = shouldShowGiftView;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- 验证用户信息（人脸信息，用户头像）
//判断是否需要验证-->需要-->是否需要人脸验证-->需要-->人脸验证
//                                   -->不需要-->头像对比通过-->不通过-->上传头像
- (BOOL)verifyUserInfo:(NSString *)info {
    WEAK_SELF();
    if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:info] != NSNotFound && ![[ZZUserHelper shareInstance] isMale]) {   // 判断当前操作是否需要做验证
        if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {    // 如果没有人脸
            NSString *title = [info isEqualToString:@"chat"] ? @"目前账户安全级别较低，将进行身份识别，否则不能聊天" : @"目前账户安全级别较低，将进行身份识别，否则无法下单";
            NavigationType type = [info isEqualToString:@"chat"] ? NavigationTypeChat : NavigationTypeOrder;
            [UIAlertController presentAlertControllerWithTitle:title message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                weakSelf.bottomView.chatBtn.userInteractionEnabled = YES;
                if (!isCancelled) {
                    [weakSelf gotoVerifyFace:type];   // 去验证人脸
                }
            }];
            return NO;
        }
//        // 如果没有头像
//        ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
//        if (photo == nil || photo.face_detect_status != 3) {
//            NSString *title = [info isEqualToString:@"chat"] ? @"您未上传本人正脸五官清晰照，不能聊天，请前往上传真实头像" : @"您未上传本人正脸五官清晰照，无法下单，请前往上传真实头像";
//            NavigationType type = [info isEqualToString:@"chat"] ? NavigationTypeChat : NavigationTypeOrder;
//            [UIAlertController presentAlertControllerWithTitle:title message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
//                weakSelf.bottomView.chatBtn.userInteractionEnabled = YES;
//                if (!isCancelled) {
//                    [weakSelf gotoUploadPicture:type];    // 去上传真实头像
//                }
//            }];
//            return NO;
//        }
    }
    return YES;
}

#pragma mark -- bottomViewAction
//判断是否需要验证-->不需要-->打招呼状态-->say_hi_status != 0-->去聊天
//                                -->say_hi_status == 0-->type == 1-->编辑本人信息
//                                                        type == 2-->发红包
- (void)chatBtnClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    _bottomView.chatBtn.userInteractionEnabled = NO;
    if (![self verifyUserInfo:@"chat"]) {   //验证不通过
        return;
    }
    [MobClick event:Event_user_detail_chat];
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",self.user.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _bottomView.chatBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if ([[data objectForKey:@"say_hi_status"] integerValue] == 0) {
                if (loginedUser.avatar_manual_status == 1) {
                    [UIAlertView showWithTitle:@"提示"
                                       message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                             cancelButtonTitle:@"知道了"
                             otherButtonTitles:nil
                                      tapBlock:nil];
                }
                else {
                    [UIAlertView showWithTitle:@"提示" message:[data objectForKey:@"msg"] cancelButtonTitle:@"放弃" otherButtonTitles:@[[data objectForKey:@"btn_text"]] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            NSInteger type = [[data objectForKey:@"type"] integerValue];
                            switch (type) {
                                case 1: [self gotoEditView:[ZZUserHelper shareInstance].loginer]; break;
                                case 2: [self askBtnClick:YES]; break;
                                default: break;
                            }
                        }
                    }];
                }   
            } else {
                [self gotoChatView: NO];
            }
        }
    }];
}

//马上租他
- (void)rentBtnClick {
    if (_fromLiveStream) {
        return;
    }
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    
    if (self.user.rent.status == 2 && self.user.rent.show) {
        
    }
    else {
        [ZZHUD showErrorWithStatus:@"对方非可邀约的达人身份"];
        return;
    }
    
    // 头像正在人工审核并且没有旧头像不能租
    if ([UserHelper isUsersAvatarManuallReviewing:_user] && ![UserHelper canShowUserOldAvatarWhileIsManualReviewingg:_user]) {
        return;
    }
    
    [MobClick event:Event_user_detail_add_order];
    if ([ZZUserHelper shareInstance].loginer && [ZZUserHelper shareInstance].loginer.avatarStatus == 0) {
        [UIAlertView showWithTitle:@"提示" message:@"本人头像不是自己的照片，请先去修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去修改"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
    } else {
        if (![self verifyUserInfo:@"add_order"]) {  //验证不通过
            return;
        }
        [self gotoRentOrderView];
    }
}
- (void)gotoRentOrderView {
    [MobClick event:Event_rent_choose_skill];
    
    ZZRentOrderInfoViewController *vc = [[ZZRentOrderInfoViewController alloc] init];
    ZZSkill *skill = _topic.skills[0];
    ZZOrder *order = [[ZZOrder alloc] init];
    
    // 查看微信价格
    order.wechat_service = ([ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no);
    order.wechat_price = order.wechat_service ? [ZZUserHelper shareInstance].configModel.order_wechat_price : 0;
    
    order.dated_at_type = 1;
    order.dated_at = [[ZZDateHelper shareInstance] getNextHours:2];
    order.price = [NSNumber numberWithDouble:[skill.price doubleValue]];
    order.skill = skill;
    order.city = _user.rent.city;
    order.to = [[ZZUser alloc] initWithDictionary:@{@"uid":_user.uid} error:nil];
    order.from = [ZZUserHelper shareInstance].loginer;
    vc.order = order;
    vc.user = _user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseBtnClick {        //TODO
//    if (![ZZUserHelper shareInstance].isLogin) {
//        [self gotoLoginView];
//        return;
//    }
//    if ([ZZUtils isBan]) {
//        return;
//    }
//    if (_chooseType == 0) {
//        if ([ZZUtils isConnecting]) {
//            return;
//        }
//        if (_publishId) {
//            if (_canConnect) {
//                [self checkAuthorized];
//            } else {
//                [ZZHUD showErrorWithStatus:@"TA的选择时间已到，无法与对方视频"];
//            }
//        } else {
//            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstConnectAlert]) {
//                [self.view addSubview:self.requestAlertView];
//            } else {
//                [self checkAuthorized];
//            }
//        }
//    } else {
//        if (_chooseType == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        if (_chooseSnatcher) {
//            _chooseSnatcher();
//        }
//    }
}

- (void)attentClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_user_detail_follow];
    if (self.user.follow_status == 0) {
        [self.user followWithUid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                self.user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableview reloadData];
            }
        }];
    } else {
        [self.user unfollowWithUid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                self.user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableview reloadData];
            }
        }];
    }
}

- (void)gotoEditSkill {
    ZZSkillOptionViewController *controller = [[ZZSkillOptionViewController alloc] init];
    controller.type = SkillOptionTypeEdit;
    controller.topic = self.topic;
    [self.navigationController pushViewController:controller animated:YES];
    
//    ZZSkillEditViewController *controller = [[ZZSkillEditViewController alloc] init];
//    controller.skillEditType = SkillEditTypeEditTheme;
//    controller.oldTopicModel = self.topic;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)haveTime {  //是否有设置档期，新版档期 1.上午 2.下午 3.晚上
    BOOL flag = NO;
    ZZSkill *skill = self.topic.skills[0];
    NSArray *schedule = !isNullString(skill.time) ? [skill.time componentsSeparatedByString:@","] : @[];
    for (NSString *key in schedule) {
        if ([key integerValue] < 4) {
            flag = YES;
            break;
        }
    }
    return flag;
}

#pragma mark -- uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        if (![self haveTime]) {
            return 0;
        } else {
            return 1;
        }
    } else if (section == 2) {
        ZZSkill *skill = self.topic.skills[0];
        return (skill.detail.status == 0 || skill.detail.content.length <= 0) ? 0 : 1;
    } else if (_type == SkillDetailTypePreview && (section == 4 || section == 5 || section == 6)) {  //编辑预览不显示‘邀约流程’，‘平台保障’，‘温馨提示’
        return 0;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZSkillDetailBaseCell *cell = [ZZSkillDetailBaseCell dequeueReusableCellForTableView:tableView atIndexPath:indexPath];
    cell.topicModel = self.topic;
    cell.user = self.user;
    [cell setGotoAttent:^{
        [self attentClick];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        ZZSkill *skill = self.topic.skills[0];
        return (skill.detail.status == 0 || skill.detail.content.length <= 0) ? 0 : UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 && [self haveTime]) {
        return 35;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        ZZSkill *skill = self.topic.skills[0];
        return (skill.detail.status == 0 || skill.detail.content.length <= 0) ? 0.1 : 10;
    } else if (section == 3 && ![self haveTime]) {
        return 0.1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3  && [self haveTime])
        return [self getScheduleHeader];
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footer.backgroundColor = kBGColor;
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)getScheduleHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"档期";
    title.textColor = kBlackColor;
    title.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
    [header addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    return header;
}
- (NSArray *)getPassPhoto {
    //过滤出通过审核的图片
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ZZPhoto *photo in _skill.photo) {
        if (photo.status != 0) {
            [tmpArray addObject:photo];
        }
    }
    return [tmpArray copy];
}

#pragma mark -- setter
- (void)setChooseType:(NSInteger)chooseType {
    _chooseType = chooseType;
    _bottomView.userInteractionEnabled = YES;
    [_bottomView.chooseBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    switch (chooseType) {
        case 1: {
            [_bottomView.chooseBtn setTitle:@"选TA" forState:UIControlStateNormal];
            [_bottomView.chooseBtn setTitleColor:HEXCOLOR(0xFC2F52) forState:UIControlStateNormal];
            _bottomView.chooseBtn.backgroundColor = [UIColor whiteColor];;
        } break;
        case 2: {
            [_bottomView.chooseBtn setTitle:@"已选定" forState:UIControlStateNormal];
            _bottomView.chooseBtn.backgroundColor = kYellowColor;
        } break;
        case 3: {
            [_bottomView.chooseBtn setTitle:@"不可选" forState:UIControlStateNormal];
            _bottomView.chooseBtn.backgroundColor = HEXCOLOR(0xDCDCDC);
            _bottomView.userInteractionEnabled = NO;
        } break;
        default: break;
    }
}

#pragma mark -- getter
- (ZZRentPageNavigationView *)navigationView {
    if (nil == _navigationView) {
        WeakSelf
        _navigationView = [[ZZRentPageNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _navigationView.touchLeftBtn = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navigationView.codeBtn.hidden = YES;
        _navigationView.rightImgView.hidden = YES;
        _navigationView.codeImgView.hidden = YES;
        _navigationView.user = self.user;
        _navigationView.ctl = weakSelf;
    }
    return _navigationView;
}
- (UITableView *)tableview {
    if (nil == _tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop - bottomHeight) style:(UITableViewStyleGrouped)];
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 50;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        if ([self getPassPhoto].count > 0) {
            _tableview.tableHeaderView = self.tableHeader;
        }
        [_tableview registerClass:[ZZSkillDetailBaseCell class] forCellReuseIdentifier:SkillDetailBaseCellId];
        [_tableview registerClass:[ZZSkillDetailUserCell class] forCellReuseIdentifier:SkillDetailUserCellId];
        [_tableview registerClass:[ZZSkillDetailPriceCell class] forCellReuseIdentifier:SkillDetailPriceCellId];
        [_tableview registerClass:[ZZSkillDetailContentCell class] forCellReuseIdentifier:SkillDetailContentCellId];
        [_tableview registerClass:[ZZSkillDetailScheduleCell class] forCellReuseIdentifier:SkillDetailScheduleCellId];
        [_tableview registerClass:[ZZSkillDetailContentCell class] forCellReuseIdentifier:SkillDetailFlowCellId];
        [_tableview registerClass:[ZZSkillDetailContentCell class] forCellReuseIdentifier:SkillDetailEnsureCellId];
        [_tableview registerClass:[ZZSkillDetailContentCell class] forCellReuseIdentifier:SkillDetailTipCellId];
    }
    return _tableview;
}
- (ZZRentPageBottomView *)bottomView {
    if (nil == _bottomView) {
        WeakSelf
        _bottomView = [[ZZRentPageBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - marginTop - bottomHeight, SCREEN_WIDTH, bottomHeight)];
        _bottomView.hidden = isUserSelf;
        _bottomView.touchChat = ^{
            [weakSelf chatBtnClick];
        };
        _bottomView.touchAsk = ^{
            [weakSelf askBtnClick:NO];
        };
        _bottomView.touchRent = ^{
            [weakSelf rentBtnClick];
        };
        _bottomView.touchChoose = ^{
            [weakSelf chooseBtnClick];
        };
        _bottomView.fromLiveStream = self.fromLiveStream;
    }
    return _bottomView;
}
- (UIButton *)bottomEditBtn {
    if (nil == _bottomEditBtn) {
        _bottomEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - marginTop - bottomHeight, SCREEN_WIDTH, bottomHeight - SafeAreaBottomHeight)];
        _bottomEditBtn.backgroundColor = kGoldenRod;
        _bottomEditBtn.hidden = _type == SkillDetailTypeShow;   //编辑预览才显示
        [_bottomEditBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        [_bottomEditBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_bottomEditBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)]];
        [_bottomEditBtn addTarget:self action:@selector(gotoEditSkill) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bottomEditBtn;
}
- (ESAutoHeightImageScroll *)imageScroll {
    if (nil == _imageScroll) {
        _imageScroll = [[ESAutoHeightImageScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topHeight)];
        WEAK_OBJECT(_tableHeader, weakTableHeader);
        WEAK_OBJECT(self.pageControl, weakPageControl);
        WEAK_OBJECT(_tableview, weakTable);
        [_imageScroll setFrameDidUpdate:^(CGRect frame, NSInteger index) {
            weakPageControl.currentPage = index;
            weakTableHeader.frame = frame;
            [weakTable setTableHeaderView:weakTableHeader];
        }];
        _imageScroll.urlKey = @"url";
        _imageScroll.images = [self getPassPhoto];
    }
    return _imageScroll;
}
- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = [self getPassPhoto].count;
        _pageControl.pageIndicatorTintColor = [kBlackColor colorWithAlphaComponent:0.3];
        _pageControl.currentPageIndicatorTintColor = kGoldenRod;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
- (UIView *)tableHeader {
    if (nil == _tableHeader) {
        _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topHeight)];
        [_tableHeader addSubview:self.imageScroll];
        [_tableHeader addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(@0);
        }];
    }
    return _tableHeader;
}

@end
