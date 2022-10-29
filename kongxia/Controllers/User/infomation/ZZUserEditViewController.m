//
//  ZZUserEditViewController.m
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserEditViewController.h"
#import "ZZAgeEditTableViewController.h"
#import "ZZEditViewController.h"
#import "ZZSignEditViewController.h"
#import "ZZBindViewController.h"
#import "ZZAddLabelViewController.h"
#import "ZZAddPersonalLabelViewController.h"
#import "ZZRentViewController.h"
#import "ZZRecordViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZMyLocationsViewController.h"

#import "ZHPickView.h"
#import "ZZUserBindCell.h"
#import "ZZUserInformationCell.h"
#import "ZZRentLabelCell.h"
#import "ZZUserEditVideoCell.h"
#import "ZZIDPhotoStatusCell.h"
#import "ZZUploadWarningTableViewCell.h"

#import "ZZUserEditHeadView.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZIDPhotoManagerViewController.h"

#import "ZZSKModel.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZSendVideoManager.h"

@interface ZZUserEditViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    WBSendVideoManagerObserver,
    ZZIDPhotoManagerViewControllerDelegate,
    ZZMyLocationsViewControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZZUserEditHeadView *headView;

@property (nonatomic, strong) ZHPickView *pickview;

@property (nonatomic, assign) CGFloat interestHeight;

@property (nonatomic, assign) CGFloat personalHeight;

@property (nonatomic, assign) CGFloat myLocationHeight;

@property (nonatomic, strong) ZZUser *loginer;

@property (nonatomic, assign) BOOL updated;

// 正在更新数据
@property (nonatomic, assign) BOOL isUpdatingData;

// 临时保存录制过来的达人视频(去录制了达人视频)
@property (nonatomic, strong) ZZSKModel *sk;

// 是否正在上传达人视频
@property (nonatomic, assign) BOOL isUploadVideo;

@property (nonatomic, assign) BOOL haveToGoBack;

@property (nonatomic, assign) BOOL didModifyNickName;

@property (nonatomic, assign) BOOL didModifySignture;


@property (nonatomic, assign) NSInteger signErrorCode;

// 是否更新了视频
@property (nonatomic, assign) BOOL isVideoUploaded;

@end

@implementation ZZUserEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_pickview remove];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    _isUploadVideo = NO;
    _didModifySignture = NO;
    _didModifyNickName = NO;
    _signErrorCode = -1;
    [GetSendVideoManager() addObserver:self];
    [self createViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserinfo) name:kMsg_PublishedQuestion
                                               object:nil];
    
    switch (self.showType) {
        case ShowHUDType_OpenSanChat: {
            [ZZHUD showTaskInfoStyleLightWithStatus:@"闪聊开通成功\n完善资料可获得更多推荐"];
            break;
        }
        case ShowHUDType_OpenRentSuccess: {
            [ZZHUD showTaskInfoStyleLightWithStatus:@"完善资料可获得更多推荐"];
            break;
        }
        default: break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createViews {
    _loginer = [ZZUserHelper shareInstance].loginer;
    [self getLabelHeigh];
    [self.view addSubview:self.tableView];
    self.headView.photos = _loginer.photos_origin;
    self.headView.isAvatarManuaReviewing = _loginer.avatar_manual_status;
    WeakSelf;
    self.headView.weakCtl = weakSelf;
    [self createLeftButton];
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self
                                    action:@selector(rightBtnClick)
                          forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLeftButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)leftNavClick {
    [ZZHUD dismiss];
    if (_gotoUserPage) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(_gotoRootCtl) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)getLabelHeigh {
    _interestHeight = [ZZUtils getLabelHeight:_loginer.interests_new];
    _personalHeight = [ZZUtils getLabelHeight:_loginer.tags_new];
    _myLocationHeight = [ZZUtils getMyLocationLabelHeight:_loginer.userGooToAddress];
}

- (void)setupModelOfCell:(ZZRentLabelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell setUser:_loginer labelType:LabelTypeLocation];
        cell.redPointView.hidden = YES;
    }
    else if (indexPath.row == 1) {
        [cell setUser:_loginer labelType:LabelTypePersonalLabel];
        if ([ZZUserHelper shareInstance].userFirstPersonalLabel || _loginer.tags_new.count) {
            cell.redPointView.hidden = YES;
        }
        else {
            cell.redPointView.hidden = NO;
        }
    }
    else {
        if ([ZZUserHelper shareInstance].userFirstInterest || _loginer.interests_new.count) {
            cell.redPointView.hidden = YES;
        }
        else {
            cell.redPointView.hidden = NO;
        }
        [cell setUser:_loginer labelType:LabelTypeInterest];
    }
}

- (void)callBack {
    if (_editCallBack) {
        _editCallBack();
    }
}

#pragma mark - UIButtonMethod
- (void)leftBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    if (self.headView.isUploading) {
        [ZZHUD showErrorWithStatus:@"请等待图片上传完毕"];
        self.navigationLeftBtn.enabled = YES;
        return;
    }
    if (self.isUploadVideo) {
        [ZZHUD showErrorWithStatus:@"请等待视频上传完毕"];
        sender.enabled = YES;
        return;
    }
    
    if (_updated || self.headView.isUpdate) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"放弃对资料的修改？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"继续编辑" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (_gotoUserPage) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        [alert addAction:continueAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
            // 弹出后恢复点击
            sender.enabled = YES;
        }];
    }
    else {
       sender.enabled = YES;
        if (_gotoUserPage) {
            [self callBack];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)rightBtnClick {
    _haveToGoBack = YES;
    [self checkIfCanUpdateUserInfo:YES shouldCheckAvatar:YES];
}

/**
 *  检查是否可以上传用户信息
 *  @param shouldCheckAvatar: 是否检查头像为本人
 */
- (void)checkIfCanUpdateUserInfo:(BOOL)shouldShowMatchedToast
               shouldCheckAvatar:(BOOL)shouldCheckAvatar {
    if (self.headView.isUploading) {
        [ZZHUD showErrorWithStatus:@"请等待图片上传完毕"];
        return;
    }
    if (self.isUploadVideo) {
        [ZZHUD showErrorWithStatus:@"请等待视频上传完毕"];
        return;
    }
    
    // 限制多次上传检测人脸
    if (_isUpdatingData) {
        return;
    }
    
    if (_loginer.nickname &&  _loginer.nickname.length == 0) {
        [ZZHUD showErrorWithStatus:@"用户名不能为空"];
        return ;
    }
    
    if (_loginer.photos.count == 0 && self.headView.urlArray.count == 0) {
        [ZZHUD showErrorWithStatus:@"头像不能为空"];
        return ;
    }
    
    // 仅针对达人需要判断是否已进行过人工审核
    if ([[ZZUserHelper shareInstance] isStar]) {
        [ZZUser getManualReviewCount:^(NSInteger count) {
            [self checkAvatar:shouldShowMatchedToast];
        }];
    }
    else {
        if ([[ZZUserHelper shareInstance] isOnRenting] || shouldCheckAvatar) {
            [self checkAvatar:shouldShowMatchedToast];
        }
        else {
            [_loginer.photos removeAllObjects];
            [_loginer.photos addObjectsFromArray:self.headView.urlArray];
            
            NSMutableDictionary *userInfoDic = [_loginer toDictionary].mutableCopy;
            
            if (_didModifySignture) {
                userInfoDic[@"bio_violation_type"] = @(_signErrorCode);
                _didModifySignture = NO;
            }
            else {
                userInfoDic[@"bio_violation_type"] = @(0);
            }
            
            if (_didModifyNickName) {
                userInfoDic[@"nickname_status"] = @(1);
                _didModifyNickName = NO;
            }
            else {
                userInfoDic[@"nickname_status"] = @(0);
                [userInfoDic removeObjectForKey:@"nickname"];
            }
            
            [_loginer updateWithParam:userInfoDic.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                    _isUpdatingData = NO;
                }
                else {
                    [ZZHUD showSuccessWithStatus:@"更新成功"];
                    ZZUser *user = [ZZUser yy_modelWithJSON:data];
                    [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                    _loginer = user;
                    [self callBack];
                    if (_haveToGoBack) {
                        _haveToGoBack = NO;
                        if (_gotoRootCtl) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    else {
                        _isUpdatingData = NO;
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
                    [_tableView reloadData];
                }
            }];
            [self uploadUserInfoLog];
        }
    }
}

/**
 *  检查头像
 */
- (void)checkAvatar:(BOOL)shouldShowMatchedToast {
    WEAK_SELF();
    // 没有人脸/活体的时候
    BOOL canProceed = [[ZZUserHelper shareInstance] didHaveRealFace:NavigationTypeUserInfo action:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (isCancel) {
            // 继续保存
            [weakSelf continueSaveUserInfo:NO];
        } else {
            // 前往识别
            [weakSelf gotoVerifyFace:NSNotFound];
        }
    }];
    
    if (!canProceed) {
        return;
    }
    
    [_loginer.photos removeAllObjects];
    [_loginer.photos addObjectsFromArray:self.headView.urlArray];
    
    [_loginer.photos_origin removeAllObjects];
    [_loginer.photos_origin addObjectsFromArray:self.headView.urlArray];
    
    if ([_loginer isAvatarManualReviewing] || !_headView.isUpdate) {
        ZZUser *user = _loginer;
        user.photos = user.photos_origin;
        NSMutableDictionary *userInfoMutableDic = [[self getUserDictionWithShouldUpdateSK:NO] mutableCopy];
        
        [_loginer updateWithParam:userInfoMutableDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                _isUpdatingData = NO;
            }
            else {
                [ZZHUD showSuccessWithStatus:@"更新成功"];
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                _loginer = user;
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                [self callBack];
                if (_haveToGoBack) {
                    _haveToGoBack = NO;
                    if (_gotoRootCtl) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else {
                    _isUpdatingData = NO;
                }
                
                // 上传完视频之后 需要吧sk置空
                _sk = nil;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
                [_tableView reloadData];
            }
        }];
        return;
    }
    
    [weakSelf uploadUserInfoLog];
    [ZZHUD showWithStatus:@"正在检测头像"];
    _isUpdatingData = YES;
    ZZPhoto *firstPhoto = [_loginer.photos firstObject];
    _loginer.faces = [ZZUserHelper shareInstance].loginer.faces;// 识别完回来要赋值
    if ([[ZZUserHelper shareInstance] isMale]) {
        // 如果是正在人工审核，直接保存
        [weakSelf continueSaveUserInfo: [UserHelper isAvatarManualReviewing] ? NO : YES];
    }
    else {
        [_loginer checkPhotoIsSamePersonNeedLogin:firstPhoto.id photoUrl:firstPhoto.url faces:_loginer.faces next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                _isUpdatingData = NO;
                if (error.code == 1002) {
                    [ZZHUD dismiss];
                    
                    // 如果是正在人工审核，直接保存
                    if ([UserHelper isAvatarManualReviewing]) {
                        [weakSelf continueSaveUserInfo:NO];
                        return ;
                    }
                    
                    [self.headView showErrorStatusImage:error.message];
                    [weakSelf photoFailAction];
                }
                else {
                    [ZZHUD showErrorWithStatus:error.message];
                }
            }
            else {
                NSString *isSame = data[@"isSame"];
                if([isSame isEqual: @"false"]) {
                    [ZZHUD dismiss];
                    _isUpdatingData = NO;
                    
                    // 如果是正在人工审核，直接保存
                    if ([UserHelper isAvatarManualReviewing]) {
                        [weakSelf continueSaveUserInfo:NO];
                        return ;
                    }
                    [self.headView showErrorStatusImage:data[@"message"]];
                    [weakSelf photoFailAction];
                    
                    if ([[data objectForKey:@"tipOpen"] boolValue]) {
                        [UIAlertView showWithTitle:@"提示" message:data[@"tip"] cancelButtonTitle:nil otherButtonTitles:@[@"更换头像",@"识别本人"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                self.headView.isReplaceHead = YES;
                                [self.headView gotoAlbum];
                            }
                            if (buttonIndex == 1) {
                                [self gotoLiveCheck];
                            }
                        }];
                    }
                }
                else {
                    if ([isSame isEqualToString:@"manual"]) {
                        // 去人脸识别
                        if ([[data objectForKey:@"tipOpen"] boolValue]) {
                            [ZZHUD dismiss];
                            [UIAlertView showWithTitle:@"提示" message:data[@"tip"] cancelButtonTitle:nil otherButtonTitles:@[@"识别"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                [self gotoLiveCheck];
                            }];
                            _isUpdatingData = NO;
                            return ;
                        }
                        else {
                            [ZZHUD showWithStatus:@"匹配失败，已转为人工审核，正在保存..."];
                        }
                    }
                    else {
                        if (shouldShowMatchedToast) {
                            [ZZHUD showWithStatus:@"匹配成功，正在保存..."];
                        }
                    }
                    NSMutableDictionary *userInfoMutableDic = [self getUserDictionWithShouldUpdateSK:YES].mutableCopy;
                    [_loginer updateWithParam:userInfoMutableDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        if (error) {
                            [ZZHUD showErrorWithStatus:error.message];
                            _isUpdatingData = NO;
                        }
                        else {
                            [ZZHUD showSuccessWithStatus:@"更新成功"];
                            ZZUser *user = [ZZUser yy_modelWithJSON:data];
                            _loginer = user;
                            [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                            _loginer = user;
                            [self callBack];
                            if (_haveToGoBack) {
                                _haveToGoBack = NO;
                                if (_gotoRootCtl) {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                                else {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }
                            else {
                                _isUpdatingData = NO;
                            }
                            
                            // 上传完视频之后 需要吧sk置空
                            _sk = nil;
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
                            [_tableView reloadData];
                        }
                    }];
                    [weakSelf uploadUserInfoLog];
                }
            }
        }];
    }
}

- (NSDictionary *)getUserDictionWithShouldUpdateSK:(BOOL)shouldUpdateSK {
    // 如果达人视频上传成功的话，则保存的时候需要将 sk 整个Model一起上传
    if (_sk && shouldUpdateSK) {
        _loginer.base_video.sk = _sk;
        _loginer.base_video.status = -1;
    }
    
    ZZUser *user = _loginer;
    user.photos = user.photos_origin;
    NSMutableDictionary *userInfoMutableDic = [user toDictionary].mutableCopy;
    
    if (!_sk) {
        userInfoMutableDic[@"base_video"] = nil;
    }
    
    if (_didModifySignture) {
        userInfoMutableDic[@"bio_violation_type"] = @(_signErrorCode);
        _didModifySignture = NO;
    }
    else {
         [userInfoMutableDic removeObjectForKey:@"bio"];
        userInfoMutableDic[@"bio_violation_type"] = @(0);
    }
    
    if (_didModifyNickName) {
        userInfoMutableDic[@"nickname_status"] = @(1);
        _didModifyNickName = NO;
    }
    else {
        [userInfoMutableDic removeObjectForKey:@"nickname"];
        userInfoMutableDic[@"nickname_status"] = @(0);
    }
    
    if ([userInfoMutableDic[@"avatar_manual_status"] intValue] == 1) {
        [userInfoMutableDic removeObjectForKey:@"avatar_manual_status"];
    }
    
    return userInfoMutableDic;
}

/**
 *  不是真实头像需要的操作
 */
- (void)photoFailAction {
    WEAK_SELF();
    [[ZZUserHelper shareInstance] canSaveWithPhoto:_loginer.photos.firstObject navigateType:NavigationTypeUserInfo block:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (infoIncompleteType == 2) {
            [weakSelf continueSaveUserInfo:!isCancel ? YES : NO];
        }
        else if (infoIncompleteType == 3) {
            if (!isCancel) {
                [weakSelf continueSaveUserInfo:YES];
            }
        }
    }];
}

/**
 *  更新用户信息
 */
- (void)updateUserinfo {
    // 这函数名取的，就差一个字母大小写，害我饶了好久没明白
    WEAK_SELF();
    [ZZUser loadUser:_loginer.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZUserHelper shareInstance].uploadingQuestionVideo = NO;
        if (data) {
            weakSelf.loginer = [ZZUser yy_modelWithJSON:data];;
            [[ZZUserHelper shareInstance] saveLoginer:_loginer postNotif:NO];
            //            weakSelf.headView.photos = _loginer.photos_origin;
            if (weakSelf.sk) {
                weakSelf.loginer.base_video.sk = weakSelf.sk;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}


// 继续保存用户信息
- (void)continueSaveUserInfo:(BOOL)shouldCheckFaceManually {
    // 如果达人视频上传成功的话，则保存的时候需要将 sk Id 上传
    if (_sk) {
        _loginer.base_video.sk = _sk;
        _loginer.base_video.status = -1;
    }
    
    NSMutableDictionary *userInfoMutableDic = [_loginer toDictionary].mutableCopy;
    
    if (!_sk) {
        userInfoMutableDic[@"base_video"] = nil;
    }
    
    if (_didModifySignture) {
        userInfoMutableDic[@"bio_violation_type"] = @(_signErrorCode);
        _didModifySignture = NO;
    }
    else {
        [userInfoMutableDic removeObjectForKey:@"bio"];
        userInfoMutableDic[@"bio_violation_type"] = @(0);
    }
    
    if (_didModifyNickName) {
        userInfoMutableDic[@"nickname_status"] = @(1);
        _didModifyNickName = NO;
    }
    else {
        [userInfoMutableDic removeObjectForKey:@"nickname"];
        userInfoMutableDic[@"nickname_status"] = @(0);
    }
    
    // 假如是在审核中的话，就要把它删除掉 不要再穿了，不要后台会把旧头像清除掉
    if ([userInfoMutableDic[@"avatar_manual_status"] intValue] == 1) {
        [userInfoMutableDic removeObjectForKey:@"avatar_manual_status"];
    }
    else {
        // 是否需要人工审核
        if (shouldCheckFaceManually) {
            userInfoMutableDic[@"avatar_manual_status"] = @1;
        }
    }

    // 用于显示错误的弹窗提示
    NSString *isManualReviewing = shouldCheckFaceManually ? @"1" : @"0";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isManualReviewing forKey: @"isManualReviewing"];
    [userDefaults synchronize];
    
    [_loginer updateWithParam:userInfoMutableDic.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            _isUpdatingData = NO;
        }
        else {
            [ZZHUD showWithStatus:@"更新成功"];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
            _loginer = loginedUser;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
            
            
            if (shouldCheckFaceManually) {
//                ZZPhoto *photo = _loginer.photos.firstObject;
//                NSString *currentReviewedImg = photo.url;
//                [ZZUserDefaultsHelper setObject:currentReviewedImg forDestKey:@"currentReviewedImg"];
            }
            
            [self callBack];
            if (_haveToGoBack) {
                _haveToGoBack = NO;
                if (_gotoRootCtl) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                _isUpdatingData = NO;
            }
            _sk = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZZHUD dismiss];
            });
        }
    }];
    [self uploadUserInfoLog];
}

/**
 *  上传用户信息log
 */
- (void)uploadUserInfoLog {
    if ([ZZUserHelper shareInstance].unreadModel.open_log && [ZZUtils isUserLogin]) {
        NSMutableDictionary *param = [@{@"type":@"用户信息上传",
                                        @"userinfo":[_loginer toDictionary]} mutableCopy];
        NSDictionary *aDict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                @"content":[ZZUtils dictionaryToJson:param]};
        [ZZUserHelper uploadLogWithParam:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                
            }
        }];
    }
}

#pragma mark - ZZMyLocationsViewControllerDelegate
- (void)controllerDidEdited:(ZZMyLocationsViewController *)controller {
    _loginer = [ZZUserHelper shareInstance].loginer;
    [self getLabelHeigh];
    [self.tableView reloadData];
}

#pragma mark - ZZIDPhotoManagerViewControllerDelegate
- (void)IDPhotoDidUpdated:(ZZIDPhotoManagerViewController *)viewController needRefresh:(BOOL)needRefresh{
    _loginer = [ZZUserHelper shareInstance].loginer;
    [_tableView reloadData];
    [self callBack];
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 4;
    }
    else if (section == 3) {
        return 3;
    }
    else if (section == 4) {
        return 3;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZZUploadWarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZUploadWarningTableViewCell cellIdentifier] forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 证件照
            ZZIDPhotoStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZIDPhotoStatusCell cellIdentifier] forIndexPath:indexPath];
            [cell photoModel:_loginer.id_photo];
            return cell;
        }
        else {
            // 达人视频
            static NSString *identifier = @"video";
            ZZUserEditVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZZUserEditVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.isAddProgress = YES;
            [cell setIsUploadVideoBlock:^(BOOL uploading) {
                _isUploadVideo = uploading;
                if (uploading == NO) {
                    // 上传结束，成功或失败
                    WEAK_OBJECT(tableView, weakTable);
                    [weakTable reloadData];
                    
                    [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
                }
            }];
            cell.user = _loginer;
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        static NSString *identifier = @"base";
        ZZUserInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZUserInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell data:_loginer indexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString *identifier = @"base";
        ZZUserInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZUserInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell data:_loginer indexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 4) {
        ZZRentLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelcell"];
        [self setupModelOfCell:cell atIndexPath:indexPath];
        return cell;
    }
    else {
        // 账号绑定
        static NSString *identifier = @"bind";
        ZZUserBindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZUserBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.user = _loginer;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85.5;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 证件照
            return 84.5f;
        }
        else {
            // 证件照
            return 94;
        }
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            if (_loginer.userGooToAddress.count == 0) {
                return 50;
            }
            else {
                return _myLocationHeight;
            }
        }
        else if (indexPath.row == 1) {
            // 个人标签
            if (_loginer.tags_new.count == 0) {
                return 50;
            }
            else {
                return _personalHeight;
            }
        }
        else {
            // 兴趣爱好
            if (_loginer.interests_new.count == 0) {
                return 50;
                
            }
            else {
                return _interestHeight;
            }
        }
    }
    else {
        return 50.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 1: {
            if (indexPath.row == 0) {
                // 证件照
                [MobClick event:Event_click_edit_IDPhoto];
                if (_loginer.id_photo.status == 1) {
                    [ZZHUD showTaskInfoWithStatus:@"证件照审核中，暂不可操作，请等待审核结果"];
                    return;
                }
                if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:@"id_photo"] != NSNotFound) {
                    // 不能
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"目前账户安全级别较低，将进行身份识别" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    return ;
                }
                else {
                    // 没有真实头像是否可以上传证件照
                    ZZIDPhotoManagerViewController *viewController = [[ZZIDPhotoManagerViewController alloc] init];
                    viewController.delegate = self;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
            else if (indexPath.row == 1) {
                // 达人视频
                [MobClick event:Event_click_detail_Apply_talent];
                [self gotoStarVideoView];
            }
            break;
        }
        case 2: {
            if (indexPath.row == 0) {
                // 用户名
                [MobClick event:Event_click_edit_name];
                [self gotoEditViewWithIndexPath:indexPath];
            }
            else if (indexPath.row == 1) {
                // 年龄
                [MobClick event:Event_click_edit_age];
                [self gotoAgeEdit];
            }
            else if (indexPath.row == 2) {
                // 身高
                [MobClick event:Event_click_edit_height];
                [self gotoHeightEdit];
            }
            else if (indexPath.row == 3) {
                // 体重
                [MobClick event:Event_click_edit_weight];
                [self gotoWeightEdit];
            }
            break;
        }
        case 3: {
            if (indexPath.row == 0) {
                // 自我介绍
                [MobClick event:Event_click_edit_introduce];
                [self gotoSignEditViewWithIndexPath:indexPath];
            }
            else if (indexPath.row == 1) {
                // 职业
                [MobClick event:Event_click_edit_work];
                [self gotoWorkEdit];
            }
            else if (indexPath.row == 2) {
                // 常住地
                [MobClick event:Event_click_edit_location];
                [self gotoLocationEdit];
            }
            break;
        }
        case 4: {
            if (indexPath.row == 0) {
                // 常出没地点
                ZZMyLocationsViewController *vc = [[ZZMyLocationsViewController alloc] init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (indexPath.row == 1) {
                // 个人标签
                [MobClick event:Event_click_edit_personlabel];
                ZZAddPersonalLabelViewController *controller = [[ZZAddPersonalLabelViewController alloc] init];
                controller.user = _loginer;
                controller.updateLabel = ^{
                    [weakSelf getLabelHeigh];
                    [weakSelf.tableView reloadData];
                    [weakSelf callBack];
                    [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
                };
                [self.navigationController pushViewController:controller animated:YES];
                if (![ZZUserHelper shareInstance].userFirstPersonalLabel) {
                    [ZZUserHelper shareInstance].userFirstPersonalLabel = @"userFirstPersonalLabel";
                    [self.tableView reloadData];
                }
            }
            else if (indexPath.row == 2) {
                // 兴趣爱好
                [MobClick event:Event_click_edit_interest];
                ZZAddLabelViewController *controller = [[ZZAddLabelViewController alloc] init];
                controller.user = _loginer;
                controller.type = RentLabelTypeInterest;
                controller.updateLabel = ^{
                    [weakSelf getLabelHeigh];
                    [weakSelf.tableView reloadData];
                    [weakSelf callBack];
                    
                    [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
                };
                controller.maxCount = 10;
                [self.navigationController pushViewController:controller animated:YES];
                if (![ZZUserHelper shareInstance].userFirstInterest) {
                    [ZZUserHelper shareInstance].userFirstInterest = @"userFirstInterest";
                    [self.tableView reloadData];
                }
            }
            break;
        }
        case 5: {
            // 账号绑定
            [MobClick event:Event_click_bind_account];
            ZZBindViewController *controller = [[ZZBindViewController alloc] init];
            controller.user = _loginer;
            controller.updateBind = ^{
                [weakSelf.tableView reloadData];
                
                [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
            };
            controller.updateRedPoint = ^{
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = kGrayTextColor;
    infoLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15.0);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    if (section == 1) {
        infoLabel.text = @"个人详情";
    }
    else if (section == 2) {
        infoLabel.text = @"基本资料";
    }
    else if (section == 3) {
        infoLabel.text = @"个人信息";
    }
    else if (section == 4) {
        infoLabel.text = @"个性标签";
    }
    else {
        infoLabel.text = @"账号绑定";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return 50;
    }
    else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 5) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = kGrayTextColor;
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.text = @"仅展示新浪微博  绑定会获取您的微博认证信息";
    [footView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView.mas_centerX);
        make.centerY.mas_equalTo(footView.mas_centerY);
    }];
    return footView;
}

#pragma mark - Navigation
/**
 *  达人视频
 *  要跳转到上传达人视频条件: 1.首先必须要有活体。 2.当前没有正在上传的视频
 */
- (void)gotoStarVideoView {
    BOOL canProceed = [[ZZUserHelper shareInstance] canProceedFollowingAction:NavigationTypeSelfIntroduce block:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (infoIncompleteType == 0) {
            if (!isCancel) {
                // 去验证人脸
                [self gotoVerifyFace:NavigationTypeSelfIntroduce];
            }
        }
        else if (infoIncompleteType == 1) {
            if (!isCancel) {
                // 去上传真实头像
                [self gotoUploadPicture:NavigationTypeSelfIntroduce];
            }
        }
    }];
    
    if (!canProceed) {
        return;
    }
    
    if (self.isUploadVideo) {
        return;
    }
    
    ZZSelfIntroduceVC *introduceVC = [ZZSelfIntroduceVC new];
    introduceVC.isUploadAfterCompleted = NO;
    if (_loginer.base_video.status == 0) {
        introduceVC.reviewStatus = ZZVideoReviewStatusNoRecord;
        if (_loginer.base_video.sk.id) {
            // 当前有录制还未保存，也算进入成功页面
            introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
            introduceVC.loginer = _loginer;
        }
    }
    else if (_loginer.base_video.status == -1) {
        introduceVC.reviewStatus = ZZVideoReviewing;
        introduceVC.loginer = _loginer;
    }
    else if (_loginer.base_video.status == 1) {
        introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
        introduceVC.loginer = _loginer;
    }
    else if (_loginer.base_video.status == 2) {
        introduceVC.reviewStatus = ZZVideoReviewStatusFail;
        introduceVC.loginer = _loginer;
        if (_sk) {
            // 当_sk有值时，说明处于审核失败情况下，他又重新录制了
            introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
            introduceVC.loginer.base_video.sk = _sk;
        }
    }
    [self.navigationController pushViewController:introduceVC animated:YES];
}

/**
 *  年龄
 */
- (void)gotoAgeEdit {
    WeakSelf;
//    if (_loginer.realname.status == 2 && _loginer.birthday) {
//        return;
//    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZZAgeEditTableViewController *controller = [sb instantiateViewControllerWithIdentifier:@"agecontroller"];
    if (_loginer.birthday) {
        controller.defaultBirthday = _loginer.birthday;
    }
    controller.user = _loginer;
    controller.dateChangeBlock = ^(NSDate *birthday) {
        weakSelf.loginer.birthday = birthday;
        weakSelf.loginer.age = (long)[ZZUser ageWithBirthday:birthday];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoEditViewWithIndexPath:(NSIndexPath *)indexPath {
    ZZEditViewController *controller = [[ZZEditViewController alloc] init];
    controller.valueString = indexPath.row == 0 ? _loginer.nickname  : _loginer.work;
    controller.editType = indexPath.row == 0 ? EditTypeName : EditTypeJob;
    if (indexPath.row == 0) {
        // 1为用户名栏
        controller.callBackBlock = ^(NSString *text){
            
            _didModifyNickName = ![_loginer.nickname isEqualToString:text];
            _loginer.nickname = text;
            _updated = YES;
            [self.tableView reloadData];
            
            // 更新用户信息
//            [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
        };
    }
    else {
        controller.callBackBlock = ^(NSString *text){
            _loginer.work = text;
            _updated = YES;
            [self.tableView reloadData];
        };
    }
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  自我介绍
 */
- (void)gotoSignEditViewWithIndexPath:(NSIndexPath *)indexPath {
    ZZSignEditViewController *controller = [[ZZSignEditViewController alloc] init];
    controller.signEditType = SignEditTypeSign;
    controller.valueString = _loginer.bio;
    controller.callBackBlock = ^(NSString *value, BOOL isTimeout, NSInteger errorCode)  {
        _didModifySignture = ![_loginer.bio isEqualToString:value];
        _loginer.bio = value;
        _updated = YES;
        _signErrorCode = errorCode;
        [self.tableView reloadData];
        
        // 更新用户信息
//        [self checkIfCanUpdateUserInfo:NO shouldCheckAvatar:NO];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoRecord {
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
            ZZTopicGroupModel *model = [[ZZTopicGroupModel alloc] init];
            if ([ZZUserHelper shareInstance].configModel.base_sk_group.count > 1) {
                model.groupId = [ZZUserHelper shareInstance].configModel.base_sk_group[0];
                model.content = [ZZUserHelper shareInstance].configModel.base_sk_group[1];
                controller.labelId = model.groupId;
            } else {
                model.groupId = @"585a5556767bdd4624769663";
                model.content = @"新人报道";
                controller.labelId = @"585a5556767bdd4624769663";
            }
            controller.groupModel = model;
            controller.is_base_sk = YES;
            ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navCtl animated:YES completion:nil];
        }
    }];
}

- (void)gotoPlayerView {
    WeakSelf;
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.skId = _loginer.base_sk.id;
    controller.canPop = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.deleteCallBack = ^{
        weakSelf.loginer.base_sk = nil;
        [[ZZUserHelper shareInstance] saveLoginer:weakSelf.loginer postNotif:NO];
        [weakSelf.tableView reloadData];
        if (weakSelf.editCallBack) {
            weakSelf.editCallBack();
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstSkModel = _loginer.base_sk;
}

/**
 *  验证人脸
 */
- (void)gotoVerifyFace:(NavigationType)type {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
}

- (void)gotoLiveCheck {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:0 inController:self];
    [helper start];
}

/**
 *  没有头像，则上传真实头像
 */
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  身高
 */
- (void)gotoHeightEdit {
    WeakSelf;
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 140; i<= 200; i++) {
        [data addObject:[NSString stringWithFormat:@"%dcm", i]];
    }
    _pickview = [[ZHPickView alloc] initPickviewWithArray:data isHaveNavControler:NO];
    _pickview.selectDoneBlock = ^(NSArray *items) {
        weakSelf.loginer.height = [[items firstObject] intValue];
        [weakSelf.tableView reloadData];
    };
    [_pickview showInView:self.view];
    
    NSUInteger row = 0;
    if (_loginer.height)
        row = _loginer.height - 140;
    else if (_loginer.gender == 1)
        row = 170 - 140;
    else
        row = 160 - 140;
    [_pickview.pickerView selectRow:row inComponent:0 animated:YES];
    [_pickview pickerView:_pickview.pickerView didSelectRow:row inComponent:0];
}

/**
 *  体重
 */
- (void)gotoWeightEdit {
    WeakSelf;
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:@[@"保密"]];
    for (int i = 40; i <= 100; i++) {
        [data addObject:[NSString stringWithFormat:@"%dkg", i]];
    }
    _pickview=[[ZHPickView alloc] initPickviewWithArray:data isHaveNavControler:NO];
    _pickview.selectDoneBlock = ^(NSArray *items) {
        weakSelf.loginer.weight = [[items firstObject] intValue];
        if ([[items firstObject] isEqualToString:@"保密"]) {
            weakSelf.loginer.weight = kSecretWeight;
        }
        [weakSelf.tableView reloadData];
    };
    [_pickview showInView:self.view];
    if (_loginer.weight && _loginer.weight != 0) {
        NSInteger row = _loginer.weight - 39;
        if (_loginer.weight == kSecretWeight) {
            row = 0;
        }
        [_pickview.pickerView selectRow:row inComponent:0 animated:YES];
        [_pickview pickerView:_pickview.pickerView didSelectRow:row inComponent:0];
    }
}

/**
 *  编辑职业
 */
- (void)gotoWorkEdit {
    WeakSelf;
    ZZAddLabelViewController *controller = [[ZZAddLabelViewController alloc] init];
    controller.user = _loginer;
    controller.type = RentLabelTypeJob;
    controller.updateLabel = ^{
        [weakSelf.tableView reloadData];
    };
    controller.maxCount = 3;
    [self.navigationController pushViewController:controller animated:YES];
    
    if (![ZZUserHelper shareInstance].userFirstJob) {
        [ZZUserHelper shareInstance].userFirstJob = @"userFirstJob";
        [self.tableView reloadData];
    }
}

/**
 *  编辑常用地
 */
- (void)gotoLocationEdit {
    WeakSelf;
    _pickview = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    _pickview.selectDoneBlock = ^(NSArray *items) {
        weakSelf.loginer.address.province = [items firstObject];
        weakSelf.loginer.address.city = [items lastObject];
        [weakSelf.tableView reloadData];
    };
    [_pickview showInView:self.view];
    
    __block NSInteger row = 0;
    __block NSInteger component = 0;
    __block BOOL contain = NO;
    NSString *cityName = [ZZUserHelper shareInstance].cityName;
    if (!isNullString(_loginer.address.city)) {
        cityName = _loginer.address.city;
    }
    if (!isNullString(cityName)) {
        [_pickview.plistArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [[obj allKeys] firstObject];
            NSArray *cityArray = [obj objectForKey:key];
            [cityArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger index, BOOL * _Nonnull stop) {
                if ([name isEqualToString:cityName]) {
                    row = idx;
                    component = index;
                    contain = YES;
                    *stop = YES;
                }
            }];
            if (contain)
                *stop = YES;
        }];
    }
    if (row >= 0) {
        [_pickview selectIndex:row inComponent:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (component >= 0) {
                [_pickview.pickerView selectRow:component inComponent:1 animated:NO];
            }
        });
    }
}

#pragma mark - WBSendVideoManagerObserver
/**
 *  开始发送视频
 */
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    _updated = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 *  视频发送完成
 */
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    NSLog(@"视频发送成功");
    _sk = sk;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

/**
 *  视频发送失败
 */
- (void)videoSendFailWithError:(NSDictionary *)error {
    NSLog(@"视频发送失败");
    _sk = nil;
    [ZZHUD showTaskInfoWithStatus:@"视频上传失败, 请重新上传"];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
        [_tableView registerClass:[ZZRentLabelCell class]
           forCellReuseIdentifier:@"labelcell"];
        [_tableView registerClass:[ZZUploadWarningTableViewCell class]
           forCellReuseIdentifier:[ZZUploadWarningTableViewCell cellIdentifier]];
        [_tableView registerClass:[ZZIDPhotoStatusCell class]
           forCellReuseIdentifier:[ZZIDPhotoStatusCell cellIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = kLineViewColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (ZZUserEditHeadView *)headView {
    if (!_headView) {
        _headView = [[ZZUserEditHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _headView;
}

@end
