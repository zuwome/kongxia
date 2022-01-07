//
//  ZZMessageListViewController+ZZTableView.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/15.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZMessageListViewController+ZZTableView.h"
#import "ZZMessageSystemCell.h"
#import "ZZMessageListCell.h"
#import "ZZMessagelistBoxCell.h"
#import "ZZMessageBoxViewController.h"
#import "ZZMessageNotificationViewController.h"
#import "ZZMessageCommentViewController.h"
#import "ZZChatServerViewController.h"
#import "ZZChatMemeViewController.h"
#import "ZZChatViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZMessageMyDynamicViewController.h"
#import "ZZMessageSystemViewController.h"
#import "ZZUserOnlineStateManage.h"
#import "ZZSanChatMessageListGuide.h"
#import "ZZMessageHeadView.h"
#import "ZZMessageSnatchCell.h"
#import "ZZLiveStreamViewController.h"
#import "ZZTasksViewController.h"

@implementation ZZMessageListViewController (ZZTableView)

- (void)registerCellForTableView:(UITableView *)tableView {
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ZZMessageSystemCell class] forCellReuseIdentifier:@"messageListSystemCellID"];
    [tableView registerClass:[ZZMessageListCell class] forCellReuseIdentifier:@"ZZMessageListCellID"];
    [tableView registerClass:[ZZMessagelistBoxCell class] forCellReuseIdentifier:@"ZZMessagelistBoxCellID"];
    [tableView registerClass:[ZZMessageSnatchCell class] forCellReuseIdentifier:ZZMessageSnatchCellId];
}

/**
 *  点击头部系统消息item
 */
- (void)didSelectItem:(ZZMessageHeadViewCell *)cell OnHeadViewAtIndexPath:(NSIndexPath *)indexPath {
    [self didClickJumpOtherViewControllerWithCell:cell];
    switch (indexPath.row) {
        case 0: {
            if (self.pushCallBack) {
                self.pushCallBack();
            }
            [MobClick event:Event_click_message_notification];
            [self gotoMessageMyDynamicViewController];
        } break;
        case 1: {
            [MobClick event:Event_click_message_notification];
            [self gotoMessageSystemViewController];
        } break;
        case 2: {
            [MobClick event:Event_click_message_comment];
            [self gotoCommentView];
        } break;
        default: break;
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    } else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZZMessageHeadView *header = [[ZZMessageHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MsgHeaderHeight)];
        header.msgListSystemUIDict = self.messageListUIDic;
        header.backgroundColor = UIColor.greenColor;
        [header setSystemCellClick:^(ZZMessageHeadViewCell *cell, NSIndexPath *indexPath) {
            [self didSelectItem:cell OnHeadViewAtIndexPath:indexPath];
        }];
        return header;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];

        headView.backgroundColor = kBGColor;
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }
    else {
        return 10.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return self.conversationArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return [[UITableViewCell alloc] init];
        } break;
        default: {
            id object;
            if (indexPath.row < self.conversationArray.count) {
                object = self.conversationArray[indexPath.row];
            }
            if ([object isKindOfClass:[RCConversation class]]) {
                //已经关注的人的cell
                ZZMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZMessageListCellID"];
                RCConversation *model = (RCConversation *)object;
                ZZUserInfoModel *userInfo = [self getUserInfoModel:model.targetId];
                [cell setData:model userInfo:userInfo];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSLog(@"已经关注的人打招呼");
                return cell;
            } else if ([object isKindOfClass:[ZZUserUnread class]]) {    //抢任务cell
                ZZMessageSnatchCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZMessageSnatchCellId];
                [cell setData:object];
                return cell;
            } else {
                //盒子的消息
                ZZMessagelistBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZMessagelistBoxCellID"];
                [cell setData];
                NSLog(@"盒子消息");
                return cell;
            }
        } break;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView setEditing:NO animated:YES];
        RCConversation *model = self.conversationArray[indexPath.row];
        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:model.targetId];
        BOOL success = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
        if (success) {
            [self.conversationArray removeObject:model];
            NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfoDict]];
            [aDict removeObjectForKey:model.targetId];
            [self saveUserInfoDict:aDict];
            [self.userInfoDict removeObjectForKey:model.targetId];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        [self getUnreadCountWithCount:0];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        id object = self.conversationArray[indexPath.row];
        if ([object isKindOfClass:[RCConversation  class]]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ;
    } else {
        //第二区
        if (indexPath.row < self.conversationArray.count) {
            id object = self.conversationArray[indexPath.row];
            if ([object isKindOfClass:[RCConversation class]]) {
                RCConversation *model;
                model = (RCConversation *)self.conversationArray[indexPath.row];
                model.unreadMessageCount = 0;
                [self gotoChatViewWithIndexPath:indexPath];
            }
            else if ([object isKindOfClass:[ZZUserUnread class]]) {
                [self gotoLiveSteam];
            }
            else {
                //盒子的人打招呼
                [self gotoMessageBoxView];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - 当系统消息去除小红点的时候跳转界面
- (void)didClickJumpOtherViewControllerWithCell:(ZZMessageHeadViewCell *)cell {
    NSInteger currentCount = [[cell getUnreadCount] integerValue];
    if (currentCount <= 0) {
        return;
    }
    //系统的小红点减去当前cell上的小红点
    [cell hideUnreadLabel];
}

#pragma mark - 跳转去其他界面
- (void)gotoChatMeme {
    ZZChatMemeViewController *controller = [[ZZChatMemeViewController alloc] init];
    controller.conversationType = ConversationType_PRIVATE;
    controller.targetId = kMmemejunUid;
    controller.enableNewComingMessageIcon = YES;//开启消息提醒
    controller.enableUnreadMessageIcon = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 去单聊
 */
- (void)gotoChatViewWithIndexPath:(NSIndexPath *)indexPath {
    if ([ZZUtils isBan]) {
        return;
    }
    RCConversation *model = self.conversationArray[indexPath.row];
    //只有发生了消息才开始刷新
    [ZZUserHelper shareInstance].updateMessageList = NO;

    if ([model.targetId isEqualToString:kMmemejunUid]) {
        //么么君的直接去单聊
        [self gotoChatServerView];
        return;
    }
   
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.uid = model.targetId;
    //只有非系统的消息才能提示弹窗
    if ([model.objectName containsString:@"RC"]) {
        controller.lastMessageSendId = model.senderUserId;
    }
    else {
        controller.lastMessageSendId = nil;
    }
    ZZUserInfoModel *infoModel = [self getUserInfoModel:model.targetId];
    controller.nickName = infoModel.nickname;
    controller.portraitUrl = infoModel.avatar;
    controller.hidesBottomBarWhenPushed = YES;
    __weak typeof(model) selfModel = model;
    controller.lastMessage = ^(RCMessage *chatMessage) {
        selfModel.lastestMessage = chatMessage.content;
          NSString *draftString = [[RCIMClient sharedRCIMClient] getTextMessageDraft:ConversationType_PRIVATE targetId:model.targetId];
        if (![model.draft isEqualToString:draftString]) {
            model.draft = draftString;
            ZZUserInfoModel *userInfo = [self getUserInfoModel:model.targetId];
            //消息列表接收到消息，列表顺序可能改变，不能用原indexpath取cell
            NSInteger index = -1;
            for (NSInteger i = 0; i < self.conversationArray.count; i++) {
                id object = self.conversationArray[i];
                if ([object isKindOfClass:[RCConversation class]]) {
                    RCConversation *conversation = (RCConversation *)object;
                    if ([conversation.targetId isEqualToString:model.targetId]) {
                        index = i;
                        break;
                    }
                }
            }
            if (index != -1) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:1];
                ZZMessageListCell *cell  = (ZZMessageListCell *)[self.tableView cellForRowAtIndexPath:path];
                [cell setData:model userInfo:userInfo];
            }
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**
 评论
 */
- (void)gotoCommentView {
    if ([ZZUtils isBan]) {
        return;
    }
    ZZMessageCommentViewController *controller = [[ZZMessageCommentViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    if ([[ZZUserHelper shareInstance].unreadModel.reply integerValue]>0) {
        [ZZUserHelper shareInstance].unreadModel.reply = @0;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]withRowAnimation:UITableViewRowAnimationNone];
    }
}

/**
 客服
 */
- (void)gotoChatServerView {
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
}

/**
 互动
 */
- (void)gotoMessageMyDynamicViewController {
    if ([ZZUtils isBan]) {
        return;
    }
    ZZMessageMyDynamicViewController *myCtl = [[ZZMessageMyDynamicViewController alloc] init];
    myCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCtl animated:YES];
}

/**
 跳去系统
 */
- (void)gotoMessageSystemViewController {
    ZZMessageSystemViewController *sysCtl = [[ZZMessageSystemViewController alloc] init];
    if ([[ZZUserHelper shareInstance].unreadModel.system_msg integerValue]>0) {
        [ZZUserHelper shareInstance].unreadModel.system_msg = @0;
    }
    sysCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sysCtl animated:YES];
}

/**
 跳转去通知
 */
- (void)gotoNotificationView {
    ZZMessageNotificationViewController *controller = [[ZZMessageNotificationViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 跳转去盒子
 */
- (void)gotoMessageBoxView {
    if ([ZZUtils isBan]) {
        return;
    }
    ZZMessageBoxViewController *controller = [[ZZMessageBoxViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 *  跳转到抢任务列表
 */
- (void)gotoLiveSteam {
    ZZTasksViewController *vc = [[ZZTasksViewController alloc] initWithTaskType:TaskNormal];
//    ZZLiveStreamViewController *controller = [[ZZLiveStreamViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
