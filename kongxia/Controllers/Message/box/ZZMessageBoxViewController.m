//
//  ZZMessageBoxViewController.m
//  zuwome
//
//  Created by angBiu on 2017/6/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMessageBoxViewController.h"
#import "ZZChatViewController.h"

#import "ZZMessageBoxCell.h"

#import "ZZMessageBoxModel.h"
#import "ZZDateHelper.h"

#import <RongIMKit/RongIMKit.h>
#import "ZZVideoMessage.h"
@interface ZZMessageBoxViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) NSInteger unreadCount;

@end

@implementation ZZMessageBoxViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"消息盒子";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createViews];
    [self loadData];
}

- (void)createViews {
    [self.view addSubview:self.topBtn];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewMessageBox) name:kMsg_ReceiveMessageBox
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBlack:)
                                                 name:kMsg_AddUserBlack
                                               object:nil];
}

#pragma mark - data

- (void)loadData {
    WeakSelf;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullRequest:nil];
    }];
//    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
//        ZZMessageBoxModel *model = [weakSelf.dataArray lastObject];
//        [weakSelf pullRequest:model.sort_value];
//    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)pullRequest:(NSString *)sortValue
{
    NSDictionary *param;
    if (sortValue) {
        param = @{@"sort_value":sortValue};
    }
    [ZZMessageBoxModel getMessageBoxList:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZMessageBoxModel arrayOfModelsFromDictionaries:data error:nil];
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sortValue) {
                [self.dataArray addObjectsFromArray:array];
            } else {
                if (_unreadCount != 0) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _infoLabel.superview.top = 0;
                        _countLabel.superview.top = -_countLabel.height;
                    } completion:^(BOOL finished) {
                        [self animateComplete];
                    }];
                    _unreadCount = 0;
                }
                self.dataArray = array;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)updateMessageBox
{
    if ([self.tableView.mj_header isRefreshing]) {
        [self pullRequest:nil];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)addBlack:(NSNotification *)notification
{
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    for (ZZMessageBoxModel *model in self.dataArray) {
        if ([model.say_hi_total.from.uid isEqualToString:uid]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0];
            [self deleteWithIndexPath:indexPath];
            break;
        }
    }
}

- (void)receiveNewMessageBox {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_unreadCount == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                _infoLabel.superview.top = -_infoLabel.height;
                _countLabel.superview.top = 0;
            } completion:^(BOOL finished) {
                [self animateComplete];
            }];
        }
        _unreadCount++;
        NSString *string = [NSString stringWithFormat:@"您收到%ld条新的招呼，点击查看",_unreadCount];
        _countLabel.attributedText = [ZZUtils setWordSpace:string space:1.2 fontSize:13 color:[UIColor whiteColor]];
    });
}

- (void)animateComplete
{
    if (_unreadCount == 0) {
        _infoLabel.superview.top = 0;
        _countLabel.superview.top = _countLabel.height;
    } else {
        _infoLabel.superview.top = _infoLabel.height;
        _countLabel.superview.top = 0;
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count > 8 ? 8 : self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    if (!cell) {
        cell = [[ZZMessageBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    [cell setData:self.dataArray[indexPath.row]];
    WeakSelf;
    __weak typeof(cell)weakCell = cell;
    cell.touchAddBlock = ^{
        [weakSelf blackBtnClick:weakCell];
    };
    cell.touchDelete = ^{
        [weakSelf deleteBtnClick:weakCell];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageBoxModel *model = self.dataArray[indexPath.row];
    int count = [[RCIMClient sharedRCIMClient] getMessageCount:ConversationType_PRIVATE targetId:model.say_hi_total.from.uid];
    
    if (count > 0) {
        [self gotoChatView:model haveLocalMessage:YES];
    }
    else {
        [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/from/%@/say_hi/all",model.say_hi_total.from.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                NSMutableArray *array = [ZZMessageBoxModel arrayOfModelsFromDictionaries:data error:nil];
                for (int i=0; i<array.count; i++) {
                    ZZMessageBoxModel *boxModel = array[array.count - 1 - i];
                    
                  id  sayHiMessage;
                    if ([boxModel.say_hi.videoMessageType isEqualToString:@"视屏挂断的消息"] ) {
                        sayHiMessage = [ZZVideoMessage messageWithContent:boxModel.say_hi.content];
                    }
                    else{
                     sayHiMessage =  [RCTextMessage messageWithContent:boxModel.say_hi.content];
                    }
                    NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:boxModel.say_hi.created_at];
                    [[RCIMClient sharedRCIMClient] insertIncomingMessage:ConversationType_PRIVATE targetId:model.say_hi_total.from.uid senderUserId:boxModel.say_hi.from.uid receivedStatus:ReceivedStatus_READ content:sayHiMessage sentTime:[date timeIntervalSince1970]*1000 ];
                    
                   
                }
                ;
                [self gotoChatView:model haveLocalMessage:NO];
            }
        }];
    }
}

#pragma mark - UIButtonMethod

- (void)blackBtnClick:(ZZMessageBoxCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZMessageBoxModel *model = self.dataArray[indexPath.row];
    [ZZUser addBlackWithUid:model.say_hi_total.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            
        }
    }];
}

- (void)deleteBtnClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self deleteWithIndexPath:indexPath];
}

- (void)deleteWithIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageBoxModel *model = self.dataArray[indexPath.row];
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/say_hi_total/%@/del",model.say_hi_total.boxId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if ([self.dataArray containsObject:model]) {
                [self.dataArray removeObject:model];
//<<<<<<< HEAD
                [CATransaction begin];
                [CATransaction setCompletionBlock: ^{
                    [self.tableView reloadData];
                    if (_dataArray.count == 0) {
                        [self.tableView.mj_footer beginRefreshing];
                    }
                }];
                
//                if (indexPath.row < [self.tableView numberOfRowsInSection:indexPath.section]) {
//                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                }
//                else {
                    [self.tableView reloadData];
//                }
                [CATransaction commit];
//                [self.tableView reloadData];
//                if (_dataArray.count == 0) {
//                    [self.tableView.mj_footer beginRefreshing];
//                }
                
//                [CATransaction begin];
//                [CATransaction setCompletionBlock: ^{
//                    [self.tableView reloadData];
//                    if (_dataArray.count == 0) {
//                        [self.tableView.mj_footer beginRefreshing];
//                    }
//                }];
//
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [CATransaction commit];
            }
        }
    }];
}

- (void)touchTopView
{
    if (_unreadCount > 0) {
        [self updateMessageBox];
    }
}

#pragma mark - Navigation

- (void)gotoChatView:(ZZMessageBoxModel *)model haveLocalMessage:(BOOL)haveLocalMessage
{
    WeakSelf;
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.uid = model.say_hi_total.from.uid;
    controller.nickName = model.say_hi_total.from.nickname;
    controller.portraitUrl = [model.say_hi_total.from displayAvatar];
    controller.user = model.say_hi_total.from;
    controller.hidesBottomBarWhenPushed = YES;
    controller.isMessageBox = YES;
    controller.isMessageBoxTo = YES;
    controller.shouldSendHighlyReplyRequest = YES;
    controller.haveLocalMessage = haveLocalMessage;
    [self.navigationController pushViewController:controller animated:YES];
    controller.updateMessageBox = ^{
        [weakSelf updateMessageBox];
    };
    [ZZUserHelper shareInstance].updateMessageList = YES;
    
    if (model.say_hi_total.count != 0) {
        model.say_hi_total.count = 0;
        [self.tableView reloadData];
    }
}

#pragma mark - lazyload

- (UIButton *)topBtn
{
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 27)];
        [_topBtn addTarget:self action:@selector(touchTopView) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *infoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 27)];
        infoBgView.backgroundColor = RGBCOLOR(254, 251, 210);
        infoBgView.userInteractionEnabled = NO;
        [_topBtn addSubview:infoBgView];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 27)];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        [infoBgView addSubview:_infoLabel];
        
        
        NSString *infoStr = @"部分包含令人反感词语的招呼已被隐藏";
        if ([ZZUserHelper shareInstance].loginer.gender == 1) {
            infoStr = @"等级越高将会受到越多推荐, 会有更多达人私信你";
        }
        NSMutableAttributedString *priceAttriString = [[NSMutableAttributedString alloc] initWithString:infoStr];
        [priceAttriString addAttribute:NSFontAttributeName
                                  value:ADaptedFontMediumSize(13)
                                  range: NSMakeRange(0, infoStr.length)];
        [priceAttriString addAttribute:NSForegroundColorAttributeName
                                  value:HEXCOLOR(0xCD8831)
                                  range: NSMakeRange(0, infoStr.length)];

        _infoLabel.attributedText = priceAttriString;
        
        UIView *countBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 27)];
        countBgView.backgroundColor = HEXCOLOR(0xFE623C);
        countBgView.userInteractionEnabled = NO;
        [_topBtn addSubview:countBgView];
        countBgView.top = countBgView.height;
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 27)];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:13];
        [countBgView addSubview:_countLabel];
    }
    return _topBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topBtn.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _topBtn.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
