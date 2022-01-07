//
//  ZZSkillEditViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditViewController.h"
#import "ZZScheduleEditViewController.h"
#import "ZZSignEditViewController.h"
#import "ZZSubmitThemePictureViewController.h"
#import "ZZChooseTagViewController.h"
#import "ZZSkillOptionViewController.h"

#import "ZZSkillEditCellHeader.h"
#import "ZZSkillEditCellFooter.h"
#import "ZZSkillEditBaseCell.h"
#import "ZZSkillEditInputCell.h"
#import "ZZSkillEditPressCell.h"
#import "ZZSkillEditIntroduceCell.h"
#import "ZZSkillEditPictureCell.h"
#import "ZZSkillEditTagCell.h"
#import "ZZTableView.h"

#define TopLabelHeight 50       //顶部标题高度，新增主题才有
#define BottomBtnHeight 50      //底部按钮高度，编辑主题才有

@interface ZZSkillEditViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) ZZTableView *tableview;
@property (nonatomic, strong) UIButton *deleteThemeBtn;
@property (nonatomic, strong) ZZSkillEditCellFooter *footerStage;

@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) ZZTopic *currentTopicModel;
@property (nonatomic, assign) BOOL isUpdated;   //是否做过修改，是则弹出提示框

@end

@implementation ZZSkillEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialData];
    [self createRightBarButton];
    [self createView];
    [self requestSkillDetail];
}

- (void)navigationLeftBtnClick {
    if (self.isUpdated && self.skillEditType == SkillEditTypeEditTheme) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已修改，确认放弃？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *giveUp = [UIAlertAction actionWithTitle:@"放弃" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //退出编辑，重置修改标记
            [[ZZSkillThemesHelper shareInstance] resetUpdateSign];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:giveUp];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createRightBarButton {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = self.skillEditType != SkillEditTypeEditTheme ? @"技能介绍" : @"编辑技能";
}

- (void)nextClick {
    ZZSkill *skill = self.currentTopicModel.skills[0];
    if (self.skillEditType == SkillEditTypeAddCustomTheme && [skill.name isEqualToString:@""]) {
        [ZZHUD showTastInfoErrorWithString:@"请输入技能名称"];
    } else if (self.skillEditType == SkillEditTypeAddCustomTheme && (skill.name.length < 2 || skill.name.length > 4)) {
        [ZZHUD showTastInfoErrorWithString:@"请输入2-4个中文汉字"];
    } else if ([skill.price integerValue] == 0) {
        [ZZHUD showTastInfoErrorWithString:@"请输入价格"];
    } else if ([skill.price integerValue] > 300) {
        [ZZHUD showTastInfoErrorWithString:@"价格不能超过300/小时"];
    } else {
        ZZSkillOptionViewController *controller = [[ZZSkillOptionViewController alloc] init];
        controller.type = self.skillEditType == SkillEditTypeEditTheme ? SkillOptionTypeEdit : SkillOptionTypeAdd;
        controller.topic = self.currentTopicModel;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)combinePhotosToModel {
    //修改主题时提交，需要把cell中的图片数据整合进当前model里
    //cell中的图片数据不但存放zzphoto对象，所以没做实时绑定
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    ZZSkillEditPictureCell *cell = (ZZSkillEditPictureCell *)[self.tableview cellForRowAtIndexPath:indexPath];
    return [cell synconizePhotos];
}

- (void)setInitialData {
    self.currentTopicModel = self.oldTopicModel;
    if (!self.skillEditType) {
        self.skillEditType = SkillEditTypeAddSystemTheme;
    }
    self.sectionTitleArray = @[@"技能类型*", @"价格*", @"更多介绍（完善的技能资料，才能获得推荐哦）"];
}

- (void)createView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerLabel];
//    [self.view addSubview:self.deleteThemeBtn];
    [self.view addSubview:self.tableview];
    if (self.skillEditType != SkillEditTypeEditTheme) {
        [self.view addSubview:self.footerStage];
    }
}

- (void)requestSkillDetail {
//    ZZSkill *skill = self.currentTopicModel.skills[0];
//    [[ZZSkillThemesHelper shareInstance] getSkillById:skill.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//
//    }];
}

- (void)deleteThemeClick {
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    if (loginer.rent.topics.count > 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除技能，技能相关的所有内容都会被删除，确认删除？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self requestDeleteTheme];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"身为达人至少需要一个技能哦，你可以尝试修改技能内容" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)requestDeleteTheme {
    ZZSkill *skill = self.currentTopicModel.skills[0];
    if (skill && skill.id) {
        [[ZZSkillThemesHelper shareInstance] deleteSkillById:skill.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) { //成功则查找当前ZZUser，删除其中的topic，并保存
                NSInteger deleteIndex = -1;
                ZZUser *user = [ZZUserHelper shareInstance].loginer;
                NSMutableArray *topics = user.rent.topics;
                for (int i = 0; i < topics.count; i++) {
                    ZZTopic *topic = topics[i];
                    ZZSkill *topicSkill = topic.skills[0];
                    if ([topicSkill.id isEqualToString:skill.id]) {
                        deleteIndex = i;
                        break;
                    }
                }
                if (deleteIndex != -1) {
                    [user.rent.topics removeObjectAtIndex:deleteIndex];
                }
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                //退出编辑，重置修改标记
                [[ZZSkillThemesHelper shareInstance] resetUpdateSign];
                [self.navigationController popViewControllerAnimated:YES];
                [ZZHUD showSuccessWithStatus:@"删除技能成功"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- tableviewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 3 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    ZZSkillEditBaseCell *cell = [ZZSkillEditBaseCell dequeueReusableCellForTableView:tableView atIndexPath:indexPath withEditType:self.skillEditType topicModel:self.currentTopicModel];
    [cell setUpdateBlock:^(BOOL isUpdated) {
        weakSelf.isUpdated = isUpdated;
    }];
    //主题图片cell
    [cell addToParentViewController:self];
    //文字介绍cell
    WEAK_OBJECT(cell, weakCell)
    [cell setShowIntroduceDialog:^{
        [tableView bringSubviewToFront:weakCell];
    }];
    [cell setBeginEditIntroduce:^{
        [tableView setContentOffset:CGPointMake(0, weakCell.frame.origin.y) animated:YES];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.skillEditType != SkillEditTypeEditTheme && section == 2) {
//        return SkillEditCellFooterHeight;
//    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZZSkillEditCellHeader *header = [[ZZSkillEditCellHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [header setTitleText:self.sectionTitleArray[section]];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 2 && self.skillEditType != SkillEditTypeEditTheme) {
//        ZZSkillEditCellFooter *footer = [[ZZSkillEditCellFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SkillEditCellFooterHeight)];
//        footer.stage = 2;
//        return footer;
//    } else {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        return footer;
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //收起主题介绍示例
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:2];
    if ([[tableView cellForRowAtIndexPath:index] isKindOfClass:[ZZSkillEditIntroduceCell class]]) {
        ZZSkillEditIntroduceCell *cell = [tableView cellForRowAtIndexPath:index];
        [cell hideDialog];
    }
    
    ZZSkill *skill = self.currentTopicModel.skills[0];
    if (indexPath.section == 2 && indexPath.row == 0) {
        ZZChooseTagViewController *controller = [[ZZChooseTagViewController alloc] init];
        controller.selectedArray = [skill.tags mutableCopy];
        controller.catalogId = skill.pid ? skill.pid : skill.id;
        [controller setChooseTagCallback:^(NSArray *tags) {
            weakSelf.isUpdated = YES;   //更新修改标记
            [ZZSkillThemesHelper shareInstance].tagUpdate = YES;
            skill.tags = (NSArray<ZZSkillTag> *)tags;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.section == 2 && self.skillEditType != SkillEditTypeEditTheme) {
        if (indexPath.row == 1 && skill.detail.content.length <= 0) {
            ZZSignEditViewController *controller = [[ZZSignEditViewController alloc] init];
            controller.signEditType = SignEditTypeSkill;
            controller.valueString = skill.detail.content;
            controller.skillName = skill.name;
            controller.sid = skill.id;  //此处传id不传pid，是因为只有添加主题会走到这里，且添加主题时id既是主题的pid
            controller.callBackBlock = ^(NSString *value, BOOL isTimeout, NSInteger errorCode) {
                weakSelf.isUpdated = YES;   //更新修改标记
                [ZZSkillThemesHelper shareInstance].introduceUpdate = YES;
                skill.detail.content = value;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            };
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 2 && skill.photo.count <= 0) {
            ZZSubmitThemePictureViewController *controller = [[ZZSubmitThemePictureViewController alloc] init];
            controller.pictureArray = [NSMutableArray arrayWithArray:skill.photo];
            controller.topic = self.currentTopicModel;
            [controller setSavePhotoCallback:^(NSArray<ZZPhoto> *photos) {
                weakSelf.isUpdated = YES;   //更新修改标记
                [ZZSkillThemesHelper shareInstance].photoUpdate = YES;
                ZZSkill *skill = self.currentTopicModel.skills[0];
                skill.photo = photos;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark -- lazy load
- (UILabel *)headerLabel {
    if (nil == _headerLabel) {
        CGRect frame;
        if (self.skillEditType != SkillEditTypeEditTheme) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, TopLabelHeight);
        } else {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        }
        _headerLabel = [[UILabel alloc] initWithFrame:frame];
        _headerLabel.backgroundColor = [UIColor whiteColor];
        _headerLabel.text = @"秀出你的才华和故事";
        _headerLabel.textColor = [UIColor blackColor];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = [UIFont systemFontOfSize:16];
    }
    return _headerLabel;
}
- (UITableView *)tableview {
    if (nil == _tableview) {
        CGFloat topHeight = self.headerLabel.frame.size.height;
        CGFloat bottomHeight = 0; //self.deleteThemeBtn.frame.size.height;
        CGRect frame = CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SafeAreaBottomHeight - topHeight - bottomHeight);
        _tableview = [[ZZTableView alloc] initWithFrame:frame style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 50;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        [_tableview registerClass:[ZZSkillEditBaseCell class] forCellReuseIdentifier:SkillEditBaseCellId];
        [_tableview registerClass:[ZZSkillEditInputCell class] forCellReuseIdentifier:SkillEditInputCellId];
        [_tableview registerClass:[ZZSkillEditPressCell class] forCellReuseIdentifier:SkillEditPressCellId];
        [_tableview registerClass:[ZZSkillEditIntroduceCell class] forCellReuseIdentifier:SkillEditIntroduceCellId];
        [_tableview registerClass:[ZZSkillEditPictureCell class] forCellReuseIdentifier:SkillEditPictureCellId];
        [_tableview registerClass:[ZZSkillEditTagCell class] forCellReuseIdentifier:SkillEditTagCellId];
    }
    return _tableview;
}
- (UIButton *)deleteThemeBtn {
    if (nil == _deleteThemeBtn) {
        CGRect frame;
        if (self.skillEditType != SkillEditTypeEditTheme) {
            frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        } else {
            frame = CGRectMake(0, SCREEN_HEIGHT - BottomBtnHeight - NAVIGATIONBAR_HEIGHT - SafeAreaBottomHeight, SCREEN_WIDTH, BottomBtnHeight);
        }
        _deleteThemeBtn = [[UIButton alloc] initWithFrame:frame];
        [_deleteThemeBtn setTitle:@"删除技能" forState:UIControlStateNormal];
        [_deleteThemeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteThemeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_deleteThemeBtn setBackgroundColor:RGBCOLOR(244, 203, 7)];
        [_deleteThemeBtn addTarget:self action:@selector(deleteThemeClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteThemeBtn;
}
- (ZZSkillEditCellFooter *)footerStage {
    if (nil == _footerStage) {
        _footerStage = [[ZZSkillEditCellFooter alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SafeAreaBottomHeight - SkillEditCellFooterHeight, SCREEN_WIDTH, SkillEditCellFooterHeight)];
        _footerStage.stage = 2;
    }
    return _footerStage;
}

@end
