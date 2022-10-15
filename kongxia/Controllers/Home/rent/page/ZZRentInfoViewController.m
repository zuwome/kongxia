//
//  ZZRentInfoViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "UIAlertController+ZZCustomAlertController.h"

#import "ZZRentInfoViewController.h"
#import "ZZRentCommentViewController.h"
#import "ZZSinaShowViewController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZWXViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZIDPhotoPreviewController.h"
#import "ZZChangePhoneViewController.h"

#import "ZZComment.h"
#import "ZZRentSinaCell.h"
#import "ZZRentSignCell.h"
#import "ZZRentNormalCell.h"
#import "ZZRentLabelCell.h"
#import "ZZRentVCell.h"
#import "ZZRentCommentCell.h"
#import "ZZRentSkillCell.h"
#import "ZZRentBriefCell.h"
#import "ZZRentScoreCell.h"
#import "ZZRentWXCell.h"
#import "ZZChuzuApplyShareView.h"
#import "ZZWXPayAlertView.h"
#import "ZZUserEditVideoCell.h"
#import "ZZIDPhotoDisplayCell.h"
#import "ZZNotBuyWeiChatAlertView.h"

#import "WeiboSDK.h"
#import "ZZReportModel.h"
#import "ZZRealNameListViewController.h"
#import "ZZRentalAgreementVC.h"
#import "ZZWeiChatEvaluationManager.h"//新版查看微信号

@interface ZZRentInfoViewController () <UITableViewDataSource,UITableViewDelegate,ZZWechatOrderSmallViewDelegate, ZZRentLabelCellDelegate, ZZRentWXCellDelegate, RealIDPresentViewDelegate, ZZRealPhotoCellDelegate> {
    ZZUser                  *_user;
    NSMutableArray          *_comments;
    CGFloat                 _interestHeight;
    CGFloat                 _personalHeight;
    CGFloat                 _myLocationHeight;
    ZZChuzuApplyShareView           *_shareView;
}

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIMenuItem *theCopyItem;

@property (nonatomic, strong) NSMutableArray *skillsArray;

@end

@implementation ZZRentInfoViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _shareView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}

- (void)createViews {
    self.tableView = [[ZZBaseTableView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ZZRentVCell class] forCellReuseIdentifier:@"vcell"];
    [self.tableView registerClass:[ZZRentSignCell class] forCellReuseIdentifier:@"signcell"];
    [self.tableView registerClass:[ZZRentLabelCell class] forCellReuseIdentifier:@"labelcell"];
    [self.tableView registerClass:[ZZRentBriefCell class] forCellReuseIdentifier:@"briefcell"];
    [self.tableView registerClass:[ZZRentScoreCell class] forCellReuseIdentifier:@"score"];
    [self.tableView registerClass:[ZZRentSinaCell class] forCellReuseIdentifier:@"sina"];
    [self.tableView registerClass:[ZZRentNormalCell class] forCellReuseIdentifier:@"info"];
    [self.tableView registerClass:[ZZRentWXCell class] forCellReuseIdentifier:@"wxcell"];
    [self.tableView registerClass:[ZZUserEditVideoCell class] forCellReuseIdentifier:@"videocell"];
    [self.tableView registerClass:[ZZIDPhotoDisplayCell class]
           forCellReuseIdentifier:[ZZIDPhotoDisplayCell cellIdentifier]];
    [self.tableView registerClass:[ZZRealPhotoCell class] forCellReuseIdentifier:@"ZZRealPhotoCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.infoLabel;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -30, 0)];
    self.tableView.estimatedRowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setData:(ZZUser *)user {
    _user = user;
    //剔除未通过审核的技能
    NSArray *topics = user.rent.topics;
    [self.skillsArray removeAllObjects];
    for (ZZTopic *topic in topics) {
        ZZSkill *skill = topic.skills[0];
        if (skill.topicStatus == 2 || skill.topicStatus == 4) {//技能审核状态：0=>审核不通过 1=>待审核 2=>已审核 3=>待确认 4默认通过
            [self.skillsArray addObject:topic];
        }
    }
    _interestHeight = [ZZUtils getLabelHeight:_user.interests_new];
    _personalHeight = [ZZUtils getLabelHeight:_user.tags_new];
    _myLocationHeight = [ZZUtils getMyLocationLabelHeight:_user.userGooToAddress];
    [self.tableView reloadData];
}

- (void)setComments:(NSMutableArray *)comments {
    _comments = comments;
    [self.tableView reloadData];
}

- (void)goGetIDPhoto:(NSString *)channel {
//    if ([ZZUserHelper shareInstance].charge_id) {
//        aDict = @{@"charge_id":[ZZUserHelper shareInstance].charge_id,
//                  @"channel":channel};
//    }
    
    [ZZUser loadUser:self.user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            [ZZHUD showTaskInfoWithStatus:@"购买成功"];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            _user = user;
            [self.tableView reloadData];
            [self showIDPhoto:_user.id_photo.pic];
        }
    }];

}

/**
 获取微信号
 @param channel 获取微信号
 */
- (void)getWXNumber:(NSString *)channel {
    NSDictionary *aDict;
    if ([ZZUserHelper shareInstance].charge_id) {
        aDict = @{@"charge_id":[ZZUserHelper shareInstance].charge_id,
                    @"channel":channel};
    }
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/wechat",_user.uid] params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            [ZZHUD showTaskInfoWithStatus:@"复制成功，前往微信添加"];
            NSString *wxNumber = [data objectForKey:@"wechat_no"];
            if (_user.wechat) {
                _user.wechat.no = wxNumber;
            } else {
                ZZWechat *wechat = [[ZZWechat alloc] init];
                wechat.no = wxNumber;
                _user.wechat = wechat;
            }
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _user.wechat.no;
            _user.can_see_wechat_no = YES;
            [self.tableView reloadData];
        }
    }];
}

- (void)setShowWX:(BOOL)showWX {
    _showWX = showWX;
    if (_user.have_wechat_no && !_user.can_see_wechat_no) {
        [self buyWX];
    }
}

#pragma mark - RealIDPresentViewDelegate
- (void)showProtoclWithView:(RealIDPresentView *)view {
    [self refundView];
}

- (void)goVerifyFaceWithView:(RealIDPresentView *)view {
    [self gotoVerifyFace:NavigationTypeRentInfoRealFace];
}

- (void)changePhotoWithView:(RealIDPresentView *)view {
    [self showUserEdit];
}

- (void)goDateWithView:(RealIDPresentView *)view {
    if (_goDate) {
        _goDate();
    }
}

#pragma mark - ZZRealPhotoCellDelegate
- (void)showIDPhotoWithCell:(ZZRealPhotoCell *)cell {
    if ([_user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        if (_gotoPhotoMangerView) {
            _gotoPhotoMangerView();
        }
    }
    else {
        if (_user.id_photo.status == 2) {
            [self payToSeeIDPhoto];
        }
    }
}

- (void)realPhotoCellActionWithCell:(ZZRealPhotoCell *)cell {
    if ([[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid]) {
        if (![_user didHaveRealAvatar]) {
            if (_user.faces.count == 0) {
                [self gotoVerifyFace:NavigationTypeRentInfoRealFace];
            }
            else {
                [self showUserEdit];
            }
        }
        else {
            if (_user.rent.status != 2) {
                [self goToChooseSkillVC];
            }
        }
    }
}

#pragma mark - ZZRentWXCellDelegate
- (void)cellShowAssistance:(ZZRentWXCell *)cell {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@%@",kBase_URL,@"/assistInRefund"];
    controller.hidesBottomBarWhenPushed = YES;
    controller.title = @"微信协助或退款";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZZRentLabelCellDelegate
- (void)cell:(ZZRentLabelCell *)cell showLocation:(ZZMyLocationModel *)model {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.address_lat longitude:model.address_lng];
    controller.location = location;
    controller.name = [NSString stringWithFormat:@"%@%@",model.simple_address, model.address];
    controller.naviTitle = @"常去地点";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZZWechatOrderSmallViewDelegate
- (void)showDetailsWithOrderID:(NSString *)orderID {
    if (!isNullString(orderID)) {
        ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:orderID];
        [self.navigationController pushViewController:orderDetailsVC animated:YES];
    }
}

#pragma mark - UITableViewMethod
// NEW: 0.微博认证,1.微信号, 2.证件照, 3.自我介绍, 4.达人视频, 5.技能, 6.常去地点, 7.兴趣爱好, 8.个人标签, 9.个人资料
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return _user.weibo.verified ? 1 : 0;
        case 3: return isNullString(_user.bio) ? 0 : 1;
        case 5: return self.skillsArray.count;
        case 9: return 10;
        default: return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //FIXME: iOS13之后不能对不想显示的cell不能直接吧cellheight给0或者0.01 这样子还是会显示出来, 因为赶着上架所以先给一个空的tableviewcell
    switch (indexPath.section) {
        case 0: {
            if (_user.weibo.verified) {
               ZZRentVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vcell"];
                           [cell setData:_user];
                           return cell;
            }
            else {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            break;
        }
        case 1: {
            // 微信
           if (indexPath.section == 1 && !_user.have_wechat_no && ![[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid]) {
               return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
           }
           else if ([ZZUserHelper shareInstance].configModel.hide_see_wechat_at_userdetail) {
               return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
           }
           else {
               ZZRentWXCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wxcell"];
               cell.delegate = self;
               [cell setData:_user];
               return cell;
           }
           break;
        }
        case 2: {
            if ([[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid] || [_user isUsersAvatarReal]) {
                ZZRealPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRealPhotoCell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell showInfoWithUser:_user];
                return cell;
            }
            else {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            break;
        }
        case 3: {
            // 自我介绍
            ZZRentBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:@"briefcell"];
            [self setupBriefCell:cell];
            return cell;
        } break;
        case 4: {
            // 达人视频
//            ZZUserEditVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videocell"];
//            cell.user = _user;
//            return cell;
            return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        } break;
        case 5: {
            // 技能
            ZZRentSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"skill"];
            if (!cell) {
                cell = [[ZZRentSkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"skill"];
            }
            ZZTopic *topic = self.skillsArray[indexPath.row];
            [cell setData:topic indexPath:indexPath];
            return cell;
        } break;
        case 6: {
            // 常去地点
            if (!_user.userGooToAddress.count) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
             ZZRentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelcell"];
            cell.delegate = self;
             cell.arrowImgView.hidden = YES;
             [self setupModelOfCell:cell atIndexPath:indexPath];
            return cell;
        } break;
        case 7: {
            // 兴趣爱好
            
            if (!_user.interests_new.count) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            ZZRentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelcell"];
            cell.arrowImgView.hidden = YES;
            [self setupModelOfCell:cell atIndexPath:indexPath];
            return cell;
            break;
        }
        case 8: {
            // 个人标签
            if (!_user.tags_new.count) {
               return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
           }
            ZZRentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelcell"];
            cell.arrowImgView.hidden = YES;
            [self setupModelOfCell:cell atIndexPath:indexPath];
            return cell;
        } break;
        case 9: {
            // 个人资料
            if (!_user.birthday && indexPath.row == 2) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if (_user.works_new.count == 0 && indexPath.row == 3) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if (!_user.height && indexPath.row == 4) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if ((!_user.weight || _user.weight == kSecretWeight) && indexPath.row == 5) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if (_user.rent.time.count == 0 && indexPath.row == 6) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if (isNullString(_user.address.city) && indexPath.row == 7) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            if (isNullString(_user.weibo.iconURL) && indexPath.row == 8) {
                return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            }
            
            if (indexPath.row == 9) {
                // 信任值
                ZZRentScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"score"];
                cell.gradientView.width = cell.width * (_user.trust_score / 100.0);
                cell.scoreLabel.text = [NSString stringWithFormat:@"%ld分",_user.trust_score];
                cell.levelLabel.text = _user.trust_score_level;
                return cell;
            }
            else if (indexPath.row == 8) {
                // 新浪微博
                ZZRentSinaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sina"];
                [cell setData:_user];
                return cell;
            }
            else {
                // 信息
                ZZRentNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
                [cell setUser:_user indexPath:indexPath];
                if (indexPath.row == 0) {
                    WeakSelf;
                    cell.longPress = ^(UIView *targetView){
                        [weakSelf showMenu:targetView];
                    };
                }
                return cell;
            }
        } break;
        default: {
            ZZRentCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
            if (!cell) {
                cell = [[ZZRentCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
            }
            cell.titleLabel.text = [NSString stringWithFormat:@"评价 (%ld)", (unsigned long)_comments.count];
            return cell;
        } break;
    }
}

- (void)setupModelOfCell:(ZZRentLabelCell *)cell atIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.section == 7) {
        [cell setUser:_user labelType:LabelTypeInterest];
    }
    else if (indexPath.section == 6) {
        [cell setUser:_user labelType:LabelTypeLocation];
    }
    else {
        [cell setUser:_user labelType:LabelTypePersonalLabel];
    }
}

- (void)setupBriefCell:(ZZRentBriefCell *)cell {
    [cell setData:_user];
}

- (void)setVCell:(ZZRentVCell *)cell {
    [cell setData:_user];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        if (_user.weibo.verified) {
            return [tableView fd_heightForCellWithIdentifier:@"vcell" cacheByIndexPath:indexPath configuration:^(id cell) {
                [weakSelf setVCell:cell];
            }];
        } else {
            return 0;
        }
    }
    if (indexPath.section == 1) {
        if (![[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid]) {
            if (!_user.have_wechat_no) {
                return 0;
            }
            else {
                return 93;
            }
        }
    }
    if (indexPath.section == 1 && [ZZUserHelper shareInstance].configModel.hide_see_wechat_at_userdetail) {
        return 0;
    }
    if (indexPath.section == 2) {
        if ([[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid]) {
            if ([_user isUsersAvatarReal] && _user.id_photo.status == 2) {
                return 80.0;
            }
            else {
                return 60;
            }
        }
        else {
            if ([_user isUsersAvatarReal] && _user.id_photo.status == 2) {
                return 80.0;
            }
            else if ([_user isUsersAvatarReal]) {
                return 54;
            }
            else {
                return 0.01;
            }
        }
        
    }
    if (indexPath.section == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"briefcell" cacheByIndexPath:indexPath configuration:^(id cell) {
            [weakSelf setupBriefCell:cell];
        }];
    }
    if (indexPath.section == 4) {
        return 0;//个人资料不再显示达人视频/达人问答，显示在上面的banner
    }
    if (indexPath.section == 5) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section == 6) {
        if (!_user.userGooToAddress.count) {
            return 0;
        } else {
            return _myLocationHeight;
        }
    }
    if (indexPath.section == 7) {
        if (!_user.interests_new.count) {
            return 0;
        } else {
            return _interestHeight;
        }
    }
    if (indexPath.section == 8) {
        if (!_user.tags_new.count) {
            return 0;
        } else {
            return _personalHeight;
        }
    }
    if (indexPath.section == 9) {
        if (!_user.birthday && indexPath.row == 2)
            return 0;
        if (_user.works_new.count == 0 && indexPath.row == 3)
            return 0;
        if (!_user.height && indexPath.row == 4)
            return 0;
        if ((!_user.weight || _user.weight == kSecretWeight) && indexPath.row == 5)
            return 0;
        if (_user.rent.time.count == 0 && indexPath.row == 6)
            return 0;
        if (isNullString(_user.address.city) && indexPath.row == 7)
            return 0;
        if (isNullString(_user.weibo.iconURL) && indexPath.row == 8)
            return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    if (section == 1) {
        return 0.1;
    }
    if (![_user isUsersAvatarReal] && section == 2) {
        return 0.1;
    }
    
    if (section == 4)   //(isNullString(_user.base_sk.skId) && section == 3)
        return 0.1;
    if (self.skillsArray.count == 0 && section == 5)
        return 0.1;
    if (!_user.userGooToAddress.count && section == 6)
        return 0.1;
    if (!_user.interests_new.count && section == 7)
        return 0.1;
    if (!_user.tags_new.count && section == 8)
        return 0.1;
    if (isNullString(_user.bio) && section == 3)
        return 0.1;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (section ==1 && !_user.have_wechat_no && ![[ZZUserHelper shareInstance].loginerId isEqualToString:_user.uid]) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if ([_user isUsersAvatarReal] && section == 2) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (section == 4) {   //(isNullString(_user.base_sk.skId) && section == 3) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (self.skillsArray.count == 0 && section == 5) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (!_user.userGooToAddress.count && section == 6) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (!_user.interests_new.count && section == 7) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (!_user.works_new.count && section == 8) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    if (isNullString(_user.bio) && section == 3) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 35;
    else return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        headView.backgroundColor = kBGColor;
        UILabel *infoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBrownishGreyColor fontSize:13 text:@"个人详情"];
        [headView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_left).offset(15);
            make.centerY.mas_equalTo(headView.mas_centerY);
        }];
        ZZUser *user = _user;
        if (isNullString(UserHelper.loginer.old_avatar) || ![UserHelper didHaveRealAvatar]) {
            // 没有真实头像
        }
        else {
            if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:user.uid]) {
                NSString *infoString = @"";
                NSLog(@"***************user is %@",user);
                if (user.rent.status == 3) {
                    infoString = @"您已被系统下架，如需重新获取达人身份，请联系客服";
                }
                else if (user.rent.status != 2 || !user.rent.show) {
                    infoString = @"你还没有上架哦~点击此处立刻上架";
                    if (user.rent.status != 2) {
                        infoString = @"非达人将无法被邀约哦，点击此处立刻申请";
                    }
                }
                
                UILabel *chuzuLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:13 text:infoString];
                chuzuLabel.userInteractionEnabled = YES;
                [headView addSubview:chuzuLabel];
                [chuzuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(infoLabel.mas_right).offset(8);
                    make.centerY.mas_equalTo(headView.mas_centerY);
                }];
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chuzuStatusLabelClick)];
                [chuzuLabel addGestureRecognizer:recognizer];
            }
        }
        
        return headView;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1: {
            if ([ZZUtils isUserLogin]) {
                [self buyWX];
            }
        } break;
        case 2: {
            if (![ZZUtils isUserLogin]) {
                return;
            }
            if (![_user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
                RealIDPresentView *view = [RealIDPresentView showWithUser:_user isFromSignUpRent:NO];
                view.delegate = self;
                [self.view.window addSubview:view];
            }
            break;
        }
        case 4: {
            if (_pushBarHide) {
                _pushBarHide();
            }
            WeakSelf;
            ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
            controller.fromLiveStream = _fromLiveStream;
            controller.skId = _user.base_sk.id;
            controller.canPop = YES;
            controller.hidesBottomBarWhenPushed = YES;
            controller.deleteCallBack = ^{
                weakSelf.user.base_sk = nil;
                [[ZZUserHelper shareInstance] saveLoginer:[weakSelf.user toDictionary] postNotif:NO];
                [weakSelf.tableView reloadData];
            };
            controller.buyWxCallBack = ^{
                weakSelf.showWX = YES;
            };
            [self.navigationController pushViewController:controller animated:YES];
            controller.firstSkModel = _user.base_sk;
        } break;
        case 5: {
            ZZTopic *topic = self.skillsArray[indexPath.row];
            !self.gotoSkillDetail ? : self.gotoSkillDetail(topic);
        } break;
        case 9: {
            switch (indexPath.row) {
                case 0: {
                    ZZRentNormalCell *cell = (ZZRentNormalCell *)[tableView cellForRowAtIndexPath:indexPath];
                    [self showMenu:cell.bgView];
                } break;
                case 8: {
                    if ([WeiboSDK isWeiboAppInstalled]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sinaweibo://userinfo?uid=%@",_user.weibo.uid]]];
                    } else {
                        if (_pushCallBack) {
                            _pushCallBack();
                        }
                        ZZSinaShowViewController *controller = [[ZZSinaShowViewController alloc] init];
                        controller.navigationItem.title = [NSString stringWithFormat:@"%@ 的个人主页",_user.weibo.userName];
                        controller.urlString = _user.weibo.profileURL;
                        controller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                } break;
                case 9: {
                    if (_fromLiveStream) {
                        return;
                    }
                    if (_pushBarHide) {
                        _pushBarHide();
                    }
                    ZZRentCommentViewController *controller = [[ZZRentCommentViewController alloc] init];
                    controller.urlString = [NSString stringWithFormat:@"%@/user/%@/comment/page",kBase_URL,self.user.uid];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                } break;
                default: break;
            }
        } break;
        default: break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (_scrollLock) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (self.scrollToTop && offsetY <= 0) {  //滑到顶部时通知父列表
        _scrollLock = YES;
        [scrollView setContentOffset:CGPointZero];
        !self.scrollToTop ? : self.scrollToTop();
    }
    if (!_isClickType) {
        CGFloat frameH = scrollView.frame.size.height;
        CGFloat sizeH = scrollView.contentSize.height;
        if (offsetY + frameH > MAX(frameH, sizeH) + 110) {
            if (_scrollToDynamic) {
                _scrollToDynamic();
            }
        }
    }
}

#pragma mark - Method
- (void)refundView {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@%@",kBase_URL,@"/realAvator"];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)userChuZu {
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        // 没有打开定位权限不给去添加技能
        if (![ZZUtils isAllowLocation]) {
            return;
        }
        
        WeakSelf
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    }
    else if ([ZZUserHelper shareInstance].loginer.rent.status == 1) {
        [ZZHUD showWithStatus:@"正在审核中"];
    }
}

- (void)showUserEdit {
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoUserPage = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showIDPhoto:(NSString *)photoURL {
    ZZIDPhotoPreviewController *controller = [[ZZIDPhotoPreviewController alloc] init];
    controller.idPhotoURL = photoURL;
    controller.user = self.user;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 购买查看证件照
- (void)payToSeeIDPhoto {
    // 当查看自己的时候，跳转到ID_Photo
    if ([[ZZUserHelper shareInstance].loginerId isEqualToString:self.user.uid]) {
        [self showIDPhoto:_user.id_photo.pic];
        return;
    }
    
    [MobClick event:Event_click_userpage_IDPhoto_check];
    
    // 当前证件照免费!!
    [SVProgressHUD show];
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/getUserIdPhotoPic?uid=%@", self.user.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [SVProgressHUD dismiss];
        if (!error && data && [data isKindOfClass:[NSString class]]) {
            [self showIDPhoto:data];
        }
        else {
            [ZZHUD showErrorWithStatus:@"查看失败, 请重试"];
        }
    }];
}

// 购买微信查看
- (void)buyWX {
    if ([ZZUtils isBan]) {
        return ;
    }
    
    //当前查看的是自己的跳到查看详情
    if ([[ZZUserHelper shareInstance].loginerId isEqualToString:self.user.uid]) {
        [self gotoWXView];
        return;
    }
    
    //查看的是别人的
    ZZWeiChatEvaluationModel *model = [[ZZWeiChatEvaluationModel alloc]init];
    model.user = self.user;
    model.fromLiveStream = _fromLiveStream;
    model.type = PaymentTypeWX;
    model.source = _source;
    model.mcoinForItem = [ZZUserHelper shareInstance].configModel.wechat_price_mcoin;
    WS(weakSelf);
    
    if (UserHelper.configModel.wechat_new) {
        if (model.isBuy) {
            [SVProgressHUD show];
            [ZZRequest method:@"GET"
                         path:@"/api/wechat/userInfoGetWechatSeenDetail"
                       params:@{
                                @"from": UserHelper.loginerId,
                                @"to": self.user.uid,
                                } next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                    [SVProgressHUD dismiss];
                                    NSLog(@"data");
                                    if (!error && data) {
                                        ZZWechatOrderSmallView *view = [ZZWechatOrderSmallView showWithData:data];
                                        view.delegate = self;
                                        return;
                                    }
                                    else {
                                        [ZZHUD showErrorWithStatus:error.message];
                                    }
                                }];
        }

        [[ZZPaymentManager shared] buyItemWithPayItem:model in:self buyComplete:^(BOOL isSuccess, NSString * _Nonnull payType) {
            if (isSuccess) {
                [weakSelf getWXNumber:payType];
            }
        } rechargeComplete:^(BOOL isSuccess) {
            [ZZUser loadUser:self.user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else if (data) {
                    self.user = [ZZUser yy_modelWithJSON:data];
                }
            }];
        }];
        
        return;
    }
    
    [ZZWeiChatEvaluationManager LookWeiChatWithModel:model watchViewController:self goToBuy:^(BOOL isSuccess, NSString *payType) {
        if (isSuccess) {
            [weakSelf getWXNumber:payType];
            if (weakSelf.didBoughtWechatBlock) {
                weakSelf.didBoughtWechatBlock(YES);
            }
        }
    } recharge:nil touchChangePhone:nil evaluation:^(BOOL goChat) {
        [ZZUser loadUser:self.user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                self.user = [ZZUser yy_modelWithJSON:data];;
            }
        }];
    }];
}

- (void)showMenu:(UIView *)targetView {
    [self becomeFirstResponder];
    if (!_theCopyItem) {
        _theCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyClick)];
    }
    [[UIMenuController sharedMenuController] setMenuItems:@[_theCopyItem]];
    [[UIMenuController sharedMenuController] setTargetRect:targetView.frame inView:targetView.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _user.ZWMId;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//举报虚假微信
- (void)reportFalseWxNo {
    [ZZReportModel reportWithParam:@{@"content":self.user.wechat.no,
                                     @"type":@"1"} uid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
            });
        }
    }];
}

#pragma mark - UIButtonMethod
- (void)chuzuStatusLabelClick {
    if (_user.rent.status == 3) {
        return;
    }
    if (_user.rent.status != 2) {
        [self gotoChuzuView];
    } else {
        if ([self isReturnWithType:NavigationTypeApplyTalent]) {
            return;
        }
        [MobClick event:Event_click_user_detail_chuzu_up];
        ZZUser *user = [ZZUserHelper shareInstance].loginer;
        [user.rent enable:YES next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [ZZHUD dismiss];
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                user.rent.show = YES;
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [self createShareView];
            }
        }];
    }
}

- (void)gotoChuzuView {
    if ([self isReturnWithType:NavigationTypeApplyTalent]) {
        return;
    }
    [MobClick event:Event_click_user_detail_chuzu_apply];
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {   // 有开启出租收费
        if (_user.gender_status == 2) {// 需要先去完善身份证信息
            WEAK_SELF();
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.user = _user;
                    controller.isRentPerfectInfo = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
            return;
        }
        
        if (_user.rent_need_pay) { //此人出租需要付费
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) {
                // 需要先去同意协议
                [self gotoRentalAgreementVC];
            } else {
                [self gotoUserChuZuVC];
            }
        }
        else {
            //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            [self gotoUserChuZuVC];
        }
    } else {
        // 没有开启出租收费功能
        [self gotoUserChuZuVC];
    }
}

// 出租协议
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoUserChuZuVC {
    [MobClick event:Event_click_me_rent];
    //未出租状态前往申请达人，其余状态进入主题管理
    if (_user.rent.status == 0) {
        WeakSelf
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            [weakSelf goToChooseSkillVC];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    } else {
        [self goToSkillThemeManageViewController];
    }
    
    if (![ZZUserHelper shareInstance].userFirstRent) {
        [ZZUserHelper shareInstance].userFirstRent = @"userFirstRent";
//        [self manageRedView];
    }
}

- (void)goToChooseSkillVC {
    ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToSkillThemeManageViewController {
    ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoChangePhoneView {
    if (_fromLiveStream) {
        return;
    }
    ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] init];
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoWXView {
    if ([self isReturnWithType:NavigationTypeWeChat]) {
        return;
    }
    if (_pushBarHide) {
        _pushBarHide();
    }
    WeakSelf;
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.wxUpdate = ^{
        [weakSelf updateData];
    };
}

// 提取方法 统一判断是否需要去完善头像/人脸
- (BOOL)isReturnWithType:(NavigationType)type {
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
        NSString *tips = @"";
        if (type == NavigationTypeApplyTalent) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息";
        } else if (type == NavigationTypeWeChat) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法设置微信号";
        }
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) { // 去验证人脸
                [weakSelf gotoVerifyFace:type];
            }
        }];
        return YES;
    }
    // 如果没有头像
    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
    if (photo == nil || photo.face_detect_status != 3) {
        if (type == NavigationTypeWeChat) {
            // 判断当前操作是否需要做验证 add_wechat:微信操作
            if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_real_avatar indexOfObject:@"add_wechat"] == NSNotFound) {
                return NO;
            }
        }
        
        NSString *tips = @"";
        if (type == NavigationTypeApplyTalent) {
            tips = @"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像";
        } else if (type == NavigationTypeWeChat) {
            tips = @"您未上传本人正脸五官清晰照，无法设置微信号，请前往上传真实头像";
        }
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) { // 去上传真实头像
                [weakSelf gotoUploadPicture:type];
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
    helper.checkSuccess = ^{
        if (type == NavigationTypeRentInfoRealFace) {
            [ZZHUD showSuccessWithStatus:@"提交成功，我们1个工作日内完成头像审核。"];
        }
    };
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateData {
    _user = [ZZUserHelper shareInstance].loginer;
    [self.tableView reloadData];
}

- (void)createShareView {
    [self.tableView reloadData];
    WeakSelf;
    if (_shareView) {
        _shareView.hidden = NO;
    } else {
        _shareView = [[ZZChuzuApplyShareView alloc] initWithFrame:[UIScreen mainScreen].bounds controller:weakSelf];
        _shareView.isFromPage = YES;
        _shareView.shareCallBack = ^{
            if (weakSelf.gotoEdit) {
                weakSelf.gotoEdit();
            }
        };
        _shareView.applyLabel.text = @"上架成功";
        [self.view.window addSubview:_shareView];
    }
}

#pragma mark -
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:kBlackTextColor fontSize:12 text:@"用力上拉将切换到视频"];
        _infoLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    }
    return _infoLabel;
}
- (NSMutableArray *)skillsArray {
    if (nil == _skillsArray) {
        _skillsArray = [NSMutableArray array];
    }
    return _skillsArray;
}

- (void)dealloc {
    [_shareView removeFromSuperview];
    _shareView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
