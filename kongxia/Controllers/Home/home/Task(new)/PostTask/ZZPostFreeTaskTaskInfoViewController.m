//
//  ZZPostFreeTaskViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostFreeTaskTaskInfoViewController.h"
#import "ZZAllTopicsViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZPostFreeTaskLocTimeViewController.h"

#import "ZZPostTaskViewModel.h"

@interface ZZPostFreeTaskTaskInfoViewController () <ZZPostTaskViewModelDelegate, ZZChooseSkillViewControllerDelegate, ZZAllTopicsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZZPostFreeTaskLocTimeViewControllerDelegate>

@property (nonatomic, strong) ZZPostTaskViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *proceedBtn;

@end

@implementation ZZPostFreeTaskTaskInfoViewController

- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _viewModel = [[ZZPostTaskViewModel alloc] initWithSkill:skill taskType:taskType];
        _viewModel.currentStep = TaskStep2;
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"介绍一下你的活动";
    [self layout];
    [_viewModel configTableView:self.tableview];
}

- (void)dealloc {
    NSLog(@"ZZPostTaskBasicInfoController is Dealloced");
}

#pragma mark - private method
- (void)canTapProceedBtn {
    BOOL canTap = YES;
    if (!_viewModel.currentSkill) {
        canTap = NO;
    }
    else if (!_viewModel.content || isNullString(_viewModel.content)) {
        canTap = NO;
    }
    
    [_proceedBtn setEnabled:canTap];
    _proceedBtn.backgroundColor = canTap ? RGBCOLOR(244, 203, 7) : RGBCOLOR(216, 216, 216);
    
}

#pragma mark - response method
- (void)proceed {
    if (!_viewModel.currentSkill) {
        [ZZHUD showErrorWithStatus:@"请选择技能"];
        return;
    }
    
    if (!_viewModel.content || isNullString(_viewModel.content)) {
        [ZZHUD showErrorWithStatus:@"请填写补充说明"];
        return;
    }
    
    [self jumpToLocationTimeView];
}

#pragma mark - ZZPostTaskViewModelDelegate
// 显示主题
- (void)showSkillThemes:(ZZPostTaskViewModel *)model {
    [self gotoSelectSkills:model];
}

- (void)viewModel:(ZZPostTaskViewModel *)model showSelection:(BOOL)canDelete {
    WeakSelf
    NSString *changeTitle = @"从相册选择";
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    
    if (canDelete) {
        changeTitle = @"更换";
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.viewModel choosePhoto:nil];
        }];
        [alertController addAction:okAction];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:changeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showPhotoBrowser];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewModel:(ZZPostTaskViewModel *)model taskFreeDidInputContent:(NSString *)content {
    [self canTapProceedBtn];
}

#pragma mark - ZZPostFreeTaskLocTimeViewControllerDelegate
- (void)controller:(ZZPostFreeTaskLocTimeViewController *)controller didSelectedLocation:(ZZRentDropdownModel *)location startTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes didAgreed:(BOOL)didAgreed {
    if (location) {
        _viewModel.location = location;
    }
    
    if (!isNullString(startTime)) {
        _viewModel.startTime = startTime;
    }
    
    if (!isNullString(startTimeDescript)) {
        _viewModel.startTimeDescript = startTimeDescript;
    }
    
    if (!isNullString(durationDes)) {
        _viewModel.durantionDes = durationDes;
    }
    
    _viewModel.didAgreed = didAgreed;
}

#pragma mark - ZZChooseSkillViewControllerDelegate
- (void)controller:(ZZChooseSkillViewController *)controller didChooseSkill:(ZZSkill *)skill {
    if (skill) {
        [_viewModel chooseSkill:skill];
    }
    [self canTapProceedBtn];
}

#pragma mark - UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.viewModel choosePhoto:image];
     [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigator
/**
 *  打开相册
 */
- (void)showPhotoBrowser {
    IOS_11_Show

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)gotoSelectSkills:(ZZPostTaskViewModel *)model {
    if (_viewModel.taskType == TaskFree) {
        ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
        allSkills.taskType = model.taskType;
        allSkills.isFromSkillSelectView = YES;
        allSkills.shouldPopBack = YES;
        allSkills.delegate = self;
        allSkills.title = @"选择你想开展的活动主题";
        [self.navigationController pushViewController:allSkills animated:YES];
    }
    else {
        ZZAllTopicsViewController *allTopics = [[ZZAllTopicsViewController alloc] init];
        allTopics.delegate = self;
        allTopics.shouldPopBack = YES;
        allTopics.isFromSkillSelectView = YES;
        [self.navigationController pushViewController:allTopics animated:YES];
    }
}

- (void)jumpToLocationTimeView {
    
    ZZPostTaskViewModel *viewModel = [[ZZPostTaskViewModel alloc] initWithSkill:_viewModel.currentSkill taskType:_viewModel.taskType];
    viewModel.currentStep = TaskStep3;
    viewModel.content = _viewModel.content;
    viewModel.photosArray = _viewModel.photosArray;
    
    if (_viewModel.location) {
        viewModel.location = _viewModel.location;
    }
    
    if (!isNullString(_viewModel.startTime)) {
        viewModel.startTime = _viewModel.startTime;
    }
    
    if (!isNullString(_viewModel.startTimeDescript)) {
        viewModel.startTimeDescript = _viewModel.startTimeDescript;
    }
    
    if (!isNullString(_viewModel.durantionDes)) {
        viewModel.durantionDes = _viewModel.durantionDes;
    }
    
    viewModel.didAgreed = _viewModel.didAgreed;
    
    ZZPostFreeTaskLocTimeViewController *vc = [[ZZPostFreeTaskLocTimeViewController alloc] initWithViewModel:viewModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.proceedBtn];
    
    [_proceedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0);
        make.right.equalTo(self.view).offset(-15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15.0);
        } else {
            make.bottom.equalTo(self.view).offset(-15.0);
        }
    }];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_proceedBtn.mas_top);
    }];
}

#pragma mark - Getter&Setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColor.whiteColor;
    }
    return _tableview;
}

- (UIButton *)proceedBtn {
    if (!_proceedBtn) {
        _proceedBtn = [[UIButton alloc] init];
        _proceedBtn.normalTitle = @"下一步(2/3)";
        _proceedBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _proceedBtn.titleLabel.font = ADaptedFontMediumSize(15);
        [_proceedBtn addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
        _proceedBtn.backgroundColor = RGBCOLOR(216, 216, 216);
        
        _proceedBtn.layer.cornerRadius = 25.0;
        [_proceedBtn setEnabled:NO];
    }
    return _proceedBtn;
}

@end
