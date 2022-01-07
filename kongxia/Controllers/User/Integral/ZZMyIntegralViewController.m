//
//  ZZMyIntegralViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMyIntegralViewController.h"
#import "ZZExchangeIntegralViewController.h"//积分兑换
#import "ZZIntegralHelper.h"//积分管理类
#import "ZZIntegralNaVView.h"//自定义的导航积分
#import "ZZIntegtalTopCell.h"//签到任务的
#import "ZZIntegralNoviceCell.h"//新手任务的
#import "ZZDayTaskCell.h"//每日任务的cell
#import "ZZLinkWebViewController.h"//h5
#import "ZZTabBarViewController.h"
#import "ZZExChangeAlertView.h" //弹窗
#import "ZZRealNameListViewController.h"//去实名验证
#import "ZZBindViewController.h"//账号绑定
#import "ZZRecordViewController.h"//去录制
#import "ZZPerfectPictureViewController.h"//上传头像
#import "ZZUserEditViewController.h"//去上传头像
@interface ZZMyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZZIntegralModel *model;
@property (nonatomic,assign) BOOL isHideNav;
@end

@implementation ZZMyIntegralViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        _isHideNav = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的积分";
    [MobClick event:Event_click_myIntegral];

    /**
     接到通知去刷新 积分
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"updateTask" object:nil];;
    [self setUI];
    [self loadData];
}

- (void)loadData {
    [ZZHUD show];
    [ZZIntegralHelper requestIntegralDetailInfoSuccess:^(ZZIntegralModel *model) {
        [ZZHUD dismiss];
         NSLog(@"PY_ 签到积分_%@",model);
        self.model = model;
        [self.tableView reloadData];
    } failure:^(ZZError *error) {
        [ZZHUD showTastInfoErrorWithString:error.message];
    }];
}

/**
 设置UI
 */
- (void)setUI {
    //导航
    ZZIntegralNaVView *view = [[ZZIntegralNaVView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) titleNavLabTitile:@"我的积分" rightTitle:@"积分兑换"];
    [self.view addSubview:view];
    
    [self.view addSubview:self.tableView];
    [self setUpTheConstraints];
    WS(weakSelf);
    view.leftNavClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    view.rightNavClickBlock = ^{
        [weakSelf goToExchangeIntegral];
    };
   

}

/**
 积分兑换
 */
- (void)goToExchangeIntegral {
    _isHideNav = NO;
    ZZExchangeIntegralViewController *exchangeIntegralVC = [[ZZExchangeIntegralViewController alloc]init];
    exchangeIntegralVC.model = self.model;
    WS(weakSelf);
    exchangeIntegralVC.changeBlock = ^(ZZIntegralModel *model) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ZZIntegtalTopCell *cell = (ZZIntegtalTopCell* )[weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.integralLab.text =  [NSString stringWithFormat:@"%ld",(long)model.integral];
        weakSelf.model = model;
    };
    [self.navigationController pushViewController:exchangeIntegralVC animated:YES];
}

#pragma mark - 约束

- (void)setUpTheConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.offset(-SafeAreaBottomHeight);
    } ];
}

#pragma mark - 懒加载


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ZZIntegralNoviceCell class] forCellReuseIdentifier:@"ZZIntegralNoviceCellID"];
         [_tableView registerClass:[ZZDayTaskCell class] forCellReuseIdentifier:@"ZZDayTaskCellID"];

        [_tableView registerClass:[ZZIntegtalTopCell class] forCellReuseIdentifier:@"ZZIntegtalTopCellID"];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.sign_task&&self.model.rookie_task.count>0&&self.model.day_task.count>0) {
        //有新手任务
        return 3;
    }else if (self.model.sign_task &&self.model.day_task.count>0){
        //没有新手任务
        return 2;
    }else{
        //表示数据错误
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        ZZIntegtalTopCell  *cell  = [tableView dequeueReusableCellWithIdentifier:@"ZZIntegtalTopCellID"];
        cell.model = self.model;
        WS(weakSelf);
        cell.ruleBlock = ^{
            [weakSelf goToRule];
        };
        cell.signInBlock = ^(ZZIntegralModel *model) {
            weakSelf.model = model;
        };
        return cell;
    }else if (indexPath.row ==1&&self.model.sign_task&&self.model.rookie_task.count>0&&self.model.day_task.count>0){
        ZZIntegralNoviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZIntegralNoviceCellID"];
        cell.model = self.model;
        WS(weakSelf);
        cell.goToComplete = ^(ZZIntegralTaskModel *modelCell,ZZIntegralNewCell *currentCell) {
            [weakSelf goToCompleteTaskModel:modelCell  cell:currentCell];
        };
        return cell;
    }else {
        ZZDayTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZDayTaskCellID"];
        cell.model = self.model;
         WS(weakSelf);
        cell.gotoComplete = ^(ZZIntegralTaskModel *cellModel) {
            [weakSelf goToCompleteTaskModel:cellModel cell:nil];
        };
        return cell;
    }
}


/**
 规则说明
 */
- (void)goToRule {
      [self goToLinkWebNavTitle:@"积分规则说明" urlTitle:H5Url.pointsRuleDescription isUploadToken:NO];
}

/**
 去h5的页面

 @param navTitle 导航的名称
 @param title url的地址
 */
- (void)goToLinkWebNavTitle:(NSString *)navTitle  urlTitle:(NSString *)title isUploadToken:(BOOL)isUploadToken {
    ZZLinkWebViewController *wevView = [[ZZLinkWebViewController alloc]init];
    wevView.urlString = title;
    wevView.hidesBottomBarWhenPushed = YES;
    wevView.isPush = YES;
    [wevView setCustomNavTitle:navTitle isUploadToken:isUploadToken];
    [self.navigationController pushViewController:wevView animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
         return AdaptedWidth(287);
    }else if(indexPath.row ==1&&self.model.sign_task&&self.model.rookie_task.count>0&&self.model.day_task.count>0){
         return AdaptedWidth(195.5+17);
    }else{
        float height = self.model.day_task.count*77;
        if (self.model.rookie_task.count<=0) {
            height +=17;
        }
        return height+26;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma  mark  - 任务

/**
任务
 */
- (void)goToCompleteTaskModel:(ZZIntegralTaskModel *)model cell:(ZZIntegralNewCell*)currentCell {
    _isHideNav = NO;
    switch ([model.type intValue]) {
        case 2:
        {
            [MobClick event:Event_click_newTask_uploadHeaderImg];

            //上传真实头像
            [self uploadUserHeaderImage];
        }
            break;
        case 3:
        {
            [MobClick event:Event_click_newTask_publish];

            //发布一条视频
            [self gotoRecordCell:currentCell];
        }
            break;
        case 4:
            //绑定微博
        {
            [MobClick event:Event_click_newTask_binding];

            [self gotoUnbindAccountcell:currentCell];
        }
            break;
        case 5:
            //关注公众号
        {
            [MobClick event:Event_click_newTask_attention];

            NSString *urlH5Str = [NSString stringWithFormat:@"%@api/jifen/follow_wxpub.html",kQNPrefix_url_h5];
            [self goToLinkWebNavTitle:@"关注公众号" urlTitle:urlH5Str isUploadToken:YES];
            
        }
            break;
        case 6:
            //实名认证
        {
            [MobClick event:Event_click_newTask_realName];

            [self gotoReaNamecell:currentCell];
        }
            break;
            
        case 7:
        {
            [MobClick event:Event_click_dayTask_share];

            //分享快照
            [self goToLinkWebNavTitle:@"分享快照" urlTitle:H5Url.sharePhoto isUploadToken:NO];
        }
            break;
        case 8:
            //评论视频 -- 到发现界面
        {
            [MobClick event:Event_click_dayTask_comments];

            [self jumpToTabbarWithSelectIndex:1];
        }
            break;
        case 9:
            //点赞视频
        {
            [MobClick event:Event_click_dayTask_giveLike];

            [self jumpToTabbarWithSelectIndex:1];

        }
            break;
        case 10:
            //查看微信号
        {
            [MobClick event:Event_click_dayTask_lookWeiXin];

            [self jumpToTabbarWithSelectIndex:0];

        }
            break;
        case 11:
            //完成线下邀约
        {
            [MobClick event:Event_click_dayTask_invitation];

            [self jumpToTabbarWithSelectIndex:0];
        }
            break;
        default:
            break;
    }
}

/**
 去录制界面
 */
- (void) gotoRecordCell:(ZZIntegralNewCell*)currentCell {
    if ([ZZUtils isAllowRecord]) {
        [ZZUtils checkRecodeAuth:^(BOOL authorized) {
            if (authorized) {
                ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
                ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navCtl animated:YES completion:nil];
            }
        }];
    }
}


/**
 去实名认证

 @param currentCell 实名认证的cell
 */
- (void)gotoReaNamecell:(ZZIntegralNewCell*)currentCell{
   
    if ([self isReturnWithType:NavigationTypeRealName]) {
        return;
    }
    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _user;
    controller.isRentPerfectInfo = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 提取方法 统一判断是否需要去完善头像/人脸
- (BOOL)isReturnWithType:(NavigationType)type {
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
        
        NSString *tips = @"";
        if (type == NavigationTypeRealName) {
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
    
    // 如果没有头像
    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
    if (photo == nil || photo.face_detect_status != 3) {
        
        NSString *tips = @"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像";
        
        
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            
            if (!isCancelled) {
                // 去上传真实头像
                [weakSelf gotoUploadPicture:type];
            }
        }];
        return YES;
    }
    return NO;
}
// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type {
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

/**
绑定微博
 */
- (void)gotoUnbindAccountcell:(ZZIntegralNewCell*)currentCell {
    ZZBindViewController *controller = [[ZZBindViewController alloc] init];
    controller.user = [ZZUserHelper shareInstance].loginer;
    currentCell.model.status = @1;
    controller.bindWeiBoSuccessBlock = ^{
       
        [currentCell updateStateWithState:1];
    };
    [self.navigationController pushViewController:controller animated:YES];

}

/**
 根据任务跳转到对应的界面

 @param index 0 主页-推荐  1 发现页
 */
- (void)jumpToTabbarWithSelectIndex:(NSInteger)index {
    ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
    [controller setSelectIndex:index];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/**
 上传真实头像
 */
- (void)uploadUserHeaderImage {
    ZZUserEditViewController *vc = [[ZZUserEditViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.gotoUserPage = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
