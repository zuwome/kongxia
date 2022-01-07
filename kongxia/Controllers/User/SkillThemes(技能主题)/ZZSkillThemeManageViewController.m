//
//  ZZSkillThemeManageViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillThemeManageViewController.h"
#import "ZZSkillEditViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZSkillDetailViewController.h"

#import "ZZTableView.h"
#import "ZZSkillThemeCell.h"
#import "ZZPrivateLetterSwitchCell.h"
#import "ZZPostTaskRulesToastView.h"

#import "ZZPrivateChatPayManager.h"

#define OpenString  @"收到每条私信可获得收益，24小时内回复自动领取"      //开启的文案
#define CloseString @"开启后收到私信可获得咨询收益"                   //关闭的文案

@interface ZZSkillThemeManageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZZTableView *tableview;

@property (nonatomic, strong) NSMutableArray *themesArray;

@end

@implementation ZZSkillThemeManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    self.themesArray = loginer.rent.topics;
    [self.tableview reloadData];    //做完主题增删改查后，会更新到ZZUser中，每次进入界面时获取最新的数据，并刷新界面（项目中通知太多传的我头都晕了，以后有机会再做优化，不想用通知）-- lql.2018.8.9
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"达人信息";
    [self setInitialData];
    [self createRightBarButton];
    [self createView];
    [self requestSkillCatalog];
}

- (void)showProtocol {
    [ZZPostTaskRulesToastView showWithRulesType:RulesTypeAddSkill];
}

- (void)setInitialData {
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    self.themesArray = loginer.rent.topics;
}

- (void)requestSkillCatalog {
    [[ZZSkillThemesHelper shareInstance] getSkillsCatalog:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUser *user= [ZZUserHelper shareInstance].loginer;
            [self.themesArray removeAllObjects];
            for (NSDictionary *topicDict in data) {
                ZZTopic *topic = [[ZZTopic alloc] initWithDictionary:topicDict error:nil];
                //旧数据price在ZZTopic中，新版本price在ZZSkill中，对旧数据兼容 -- lql.2018.8.9
                if (!topic.skills || topic.skills.count == 0) continue;
                ZZSkill *skill = topic.skills[0];
                skill.price = topic.price;
                
                [self.themesArray addObject:topic];
            }
            user.rent.topics = self.themesArray;
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            [self.tableview reloadData];
        }
    }];
}

- (void)createRightBarButton {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"" forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitle:@"" forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn setImage:[UIImage imageNamed:@"icDoubt"] forState:UIControlStateNormal];
    [self.navigationRightDoneBtn addTarget:self action:@selector(doubtClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createView {
    [self.view addSubview:self.tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)doubtClick {    //查看说明
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@?a=%u",H5Url.darenInfoManagement,arc4random()];
    controller.isPush = YES;
    controller.isHideBar = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addTheme {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return ;
    }
    
    ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
    controller.choosenArray = self.themesArray;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)editThemeAtIndexPath:(NSIndexPath *)indexPath {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return ;
    }
    
    ZZTopic *topic = self.themesArray[indexPath.row];
    
//    自定义主题这版不做，先不加 -- TODO
//    ZZSkill *skill = topic.skills[0];
//    if (isNullString(skill.id)) {   //自定义主题，id为空（后台说的，有问题再修改）
//        if (skill.topicStatus == 1 || skill.topicStatus == 3) {     //1.待审核，3.待确认
//            [ZZHUD showTastInfoErrorWithString:@"审核中，暂不支持编辑"];
//        } else if (skill.topicStatus == 0) {    //0.审核不通过
//            //进入编辑页面，编辑完成后，重新提交审核
//        } else {
//            //进入编辑页面，同非自定义技能，不可以编辑主题名称
//        }
//    } else {
//        //进入编辑页面
//    }
//
//    ZZSkillEditViewController *controller = [[ZZSkillEditViewController alloc] init];
//    controller.skillEditType = SkillEditTypeEditTheme;
//    controller.oldTopicModel = topic;
//    [self.navigationController pushViewController:controller animated:YES];
    
    ZZSkillDetailViewController *controller = [[ZZSkillDetailViewController alloc] init];
    controller.user = [ZZUserHelper shareInstance].loginer;
    controller.topic = topic;
    controller.type = SkillDetailTypePreview;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)modifyPrivateLetter:(UISwitch *)openSwitch {    //switch响应事件
    if (openSwitch.on) {
        [UIAlertController presentAlertControllerWithTitle:nil message:@"开启后收到私信可获得咨询收益，但可能会大幅度降低收到私信的数量" doneTitle:@"确认开启" cancelTitle:@"我再想想" showViewController:self completeBlock:^(BOOL isSureOpen) {
            if (!isSureOpen) {
                openSwitch.on = YES;
                [self isModifyOpenChatWithSwitch:openSwitch isFirstRent:YES];
            } else {
                openSwitch.on = NO;
                [self updatePayChat:openSwitch];
            }
        }];
    }
    else {
        [self isModifyOpenChatWithSwitch:openSwitch isFirstRent:YES];
    }
}

- (void)isModifyOpenChatWithSwitch:(UISwitch *)openSwitch isFirstRent:(BOOL)isFistRent {
    if (!isFistRent) {
        [self updatePayChat:openSwitch];
    }
    else {
        [MobClick event:Event_click_PayChat_Set_Switch];
        [ZZPrivateChatPayManager modifyPrivateChatPayState:openSwitch.on callBack:^(NSInteger state) {
            if (state != -1) {
                openSwitch.on = [ZZUserHelper shareInstance].loginer.open_charge;
                [self updatePayChat:openSwitch];
            }
        }];
    }
}

- (void)updatePayChat:(UISwitch *)openSwitch {  //更新cell
    ZZPrivateLetterSwitchCell *cell = (ZZPrivateLetterSwitchCell *)[[openSwitch superview] superview];
    cell.promptLable.text = cell.openSwitch.on ? OpenString : CloseString;
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (UserHelper.loginer.gender == 2) {
        return 2;
    }
    else {
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (UserHelper.loginer.gender == 2) {
        if (section == 0) {
            return 1;
        }
        else {
            return self.themesArray.count >= 3 ? 3 : self.themesArray.count + 1;
        }
    }
    else {
        return self.themesArray.count >= 3 ? 3 : self.themesArray.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UserHelper.loginer.gender == 2) {
        if (indexPath.section == 0) {
            ZZPrivateLetterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateLetterSwitchCellId forIndexPath:indexPath];
            cell.openSwitch.on = [ZZUserHelper shareInstance].loginer.open_charge;
            cell.promptLable.text = cell.openSwitch.on ? OpenString : CloseString;
            [cell.openSwitch addTarget:self action:@selector(modifyPrivateLetter:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else {
            ZZSkillThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:SkillThemeCellIdentifier forIndexPath:indexPath];
            if (indexPath.row >= self.themesArray.count) {
                cell.cellType = SkillThemeTypeAddTheme;
                [cell setAddTheme:^{
                    [self addTheme];
                }];
            }
            else {
                ZZTopic *topic = self.themesArray[indexPath.row];
                cell.cellType = SkillThemeTypeSystemTheme;
                [cell setTopicModel:topic];
                [cell setEditTheme:^{
                    [self editThemeAtIndexPath:indexPath];
                }];
            }
            return cell;
        }
    }
    else {
        ZZSkillThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:SkillThemeCellIdentifier forIndexPath:indexPath];
        if (indexPath.row >= self.themesArray.count) {
            cell.cellType = SkillThemeTypeAddTheme;
            [cell setAddTheme:^{
                [self addTheme];
            }];
        }
        else {
            ZZTopic *topic = self.themesArray[indexPath.row];
            cell.cellType = SkillThemeTypeSystemTheme;
            [cell setTopicModel:topic];
            [cell setEditTheme:^{
                [self editThemeAtIndexPath:indexPath];
            }];
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UserHelper.loginer.gender == 2) {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            if (self.themesArray.count == 0) {
                return 50;
            }
            else {
                if (indexPath.row > self.themesArray.count - 1) {
                    return 50;
                }
                else {
                    return 85;
                }
            }
        }
    }
    else {
        if (self.themesArray.count == 0) {
            return 50;
        }
        else {
            if (indexPath.row > self.themesArray.count - 1) {
                return 50;
            }
            else {
                return 85;
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UserHelper.loginer.gender == 2) {
        return 35;
    }
    else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (UserHelper.loginer.gender == 2) {
        return [self tableHeaderInSection:section];
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (UIView *)tableHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    header.backgroundColor = kBGColor;
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.text = section == 0 ? @"开启私信收益" : @"管理你的技能（最多添加3个）";
    headerTitle.textColor = RGBCOLOR(153, 153, 153);
    headerTitle.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    [header addSubview:headerTitle];
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    return header;
}

#pragma mark -- lazy load
- (ZZTableView *)tableview {
    if (nil == _tableview) {
        _tableview = [[ZZTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:(UITableViewStylePlain)];
        [_tableview setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44.0);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        //设置富文本
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:@"平台担保支付"];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,
                                       RGBCOLOR(153, 153, 153),NSForegroundColorAttributeName,nil];
        [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
        
        //添加图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"icHelpYyCopy"];
        attach.bounds = CGRectMake(3, -1, 16, 16);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 appendAttributedString:attributeStr2];
        titleLabel.attributedText = attributeStr1;
        [footerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView);
            make.top.bottom.equalTo(footerView);
            make.width.equalTo(@200);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProtocol)];
        [titleLabel addGestureRecognizer:tap];
        
        [_tableview setTableFooterView:footerView];
        _tableview.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 50;
        [_tableview registerClass:[ZZSkillThemeCell class] forCellReuseIdentifier:SkillThemeCellIdentifier];
        [_tableview registerClass:[ZZPrivateLetterSwitchCell class] forCellReuseIdentifier:PrivateLetterSwitchCellId];
    }
    return _tableview;
}

- (NSMutableArray *)themesArray {
    if (nil == _themesArray) {
        _themesArray = [NSMutableArray array];
    }
    return _themesArray;
}

@end
