//
//  ZZWXReadedView.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXReadedView.h"
#import "MGSwipeTableCell.h"
#import "ZZUserWXModel.h"

#import "ZZReportModel.h"
#import "UIAlertController+ZZCustomAlertController.h"
#import "ZZWeiChatEvaluationManager.h"
#import "ZZRCUserInfoHelper.h"
#import "ZZChatViewController.h"
@interface ZZWXReadedCell : MGSwipeTableCell <MGSwipeTableCellDelegate>

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZSexImgView *sexImgView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *wxLabel;

@property (nonatomic, copy) void(^touchChat)(void);
@property (nonatomic, copy) void(^touchDelete)(void);
@property (nonatomic, copy) void(^canScroll)(BOOL canScroll);

- (void)setData:(ZZUserWXModel *)model;

@end

@implementation ZZWXReadedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(54, 54));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"为何奶玩电脑厚度";
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(10);
            make.top.mas_equalTo(_headImgView.mas_top).offset(5);
        }];
        
        _sexImgView = [[ZZSexImgView alloc] init];
        [self.contentView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_sexImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(26, 12));
        }];
        
        UIImageView *wxImgView = [[UIImageView alloc] init];
        wxImgView.image = [UIImage imageNamed:@"icon_wx_wx_p"];
        [self.contentView addSubview:wxImgView];
        
        [wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_headImgView.mas_bottom).offset(-3);
            make.size.mas_equalTo(CGSizeMake(18.3, 15));
        }];
        
        _wxLabel = [[UILabel alloc] init];
        _wxLabel.textColor = kBlackTextColor;
        _wxLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_wxLabel];
        
        [_wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wxImgView.mas_right).offset(8);
            make.centerY.mas_equalTo(wxImgView.mas_centerY);
        }];
        
        UIImageView *moreImgView = [[UIImageView alloc] init];
        moreImgView.image = [UIImage imageNamed:@"icon_wx_more"];
        [moreImgView sizeToFit];
        moreImgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:moreImgView];
        
        [moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-25);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(17.5, 2.5));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
        
        MGSwipeButton *deleteBtn = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:kRedColor];
        deleteBtn.buttonWidth = 70;
        MGSwipeButton *chatBtn = [MGSwipeButton buttonWithTitle:@"私信" backgroundColor:kYellowColor];
        chatBtn.buttonWidth = 70;
        self.rightButtons = @[deleteBtn,chatBtn];
        self.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        self.delegate = self;
    }
    
    return self;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    if (index == 1) {
        if (_touchChat) {
            _touchChat();
        }
    } else if (index == 0) {
        if (_touchDelete) {
            _touchDelete();
        }
    }
    return YES;
}

- (void)swipeTableCellWillBeginSwiping:(MGSwipeTableCell *)cell
{
    NSLog(@"111");
    if (_canScroll) {
        _canScroll(NO);
    }
}

- (void)swipeTableCellWillEndSwiping:(MGSwipeTableCell *)cell
{
    NSLog(@"222");
    if (_canScroll) {
        _canScroll(YES);
    }
}

- (void)setData:(ZZUserWXModel *)model
{
    [_headImgView setUser:model.user width:54 vWidth:12];
    _nameLabel.text = model.user.nickname;
    _sexImgView.gender = model.user.gender;
    [_levelImgView setLevel:model.user.level];
    _wxLabel.text = model.wechat_no;
}

#pragma mark  btn method

- (void)chatBtnClick
{
    if (_touchChat) {
        _touchChat();
    }
}

- (void)deleteBtnClick
{
    if (_touchDelete) {
        _touchDelete();
    }
}

@end

@interface ZZWXReadedView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZZWXReadedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableView];
        [self loadData];
    }
    
    return self;
}

- (void)loadData
{
    WeakSelf;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullWithSort_value:nil];
    }];
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUserWXModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullWithSort_value:lastModel.sort_value];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)pullWithSort_value:(NSString *)sort_value
{
    NSDictionary *aDict;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    }
    [ZZUserWXModel getUserWxList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                NSMutableArray *d = [ZZUserWXModel arrayOfModelsFromDictionaries:data error:nil];
                if (sort_value) {
                    [_dataArray addObjectsFromArray:d];
                    if (d.count == 0) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    _dataArray = d;
                    if (d.count == 0) {
                        self.tableView.mj_footer = nil;
                        self.tableView.mj_header = nil;
                    }
                }
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZWXReadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    if (!cell) {
        cell = [[ZZWXReadedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    
    [cell setData:self.dataArray[indexPath.row]];
    __weak typeof(cell)weakCell = cell;
    WeakSelf;
    cell.touchDelete = ^() {
        [weakSelf delete:weakCell];
    };
    cell.touchChat = ^() {
        [weakSelf chat:weakCell];
    };
    cell.headImgView.touchHead = ^{
        [weakSelf touchHead:weakCell];
    };
    cell.canScroll = ^(BOOL canScroll) {
        if (weakSelf.canScroll) {
            weakSelf.canScroll(canScroll);
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    if (_dataArray && _dataArray.count == 0) {
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wx_read_empty"];
        [footView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footView.mas_top).offset(80);
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(185, 154));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0xD8D8D8);
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"你还没查看过其他人的微信号";
        [footView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(30);
        }];
    }
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArray && _dataArray.count == 0) {
        return SCREEN_HEIGHT - 64;
    } else {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZUserWXModel *model = self.dataArray[indexPath.row];
    ZZWeiChatEvaluationModel *evaluationModel = [[ZZWeiChatEvaluationModel alloc]init];
    [ZZUser loadUser:model.user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else if (data) {
            model.user = [[ZZUser alloc] initWithDictionary:data error:nil];
            evaluationModel.user = model.user;
            [ZZWeiChatEvaluationManager LookWeiChatWithModel:evaluationModel watchViewController:nil goToBuy:nil recharge:nil touchChangePhone:nil evaluation:^(BOOL goChat) {
                if (goChat) {
                    if (_gotoChatView) {
                        _gotoChatView(model.user);
                    }
                }
            }];
        }
    }];
  
}

- (void)delete:(UITableViewCell *)cell
{
    [[UIViewController currentDisplayViewController] showOKCancelAlertWithTitle:@"删除微信" message:@"删除TA的微信号后，您再次查看TA的微信号时需要重新支付红包" cancelTitle:@"取消" cancelBlock:^{
            
        } okTitle:@"确定" okBlock:^{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            ZZUserWXModel *model = self.dataArray[indexPath.row];
            [ZZUserWXModel deleteWXRecord:model.wid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else {
                    [_dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//移除tableView中的数据
                    if (_dataArray.count == 0) {
                        [self.tableView.mj_footer beginRefreshing];
                    }
                }
            }];
        }];
}

- (void)chat:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZUserWXModel *model = self.dataArray[indexPath.row];
    if (_gotoChatView) {
        _gotoChatView(model.user);
    }
}

- (void)touchHead:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZUserWXModel *model = self.dataArray[indexPath.row];
    if (_gotoUserPage) {
        _gotoUserPage(model.user);
    }
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
