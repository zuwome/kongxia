//
//  ZZChatHelper.h
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#ifndef ZZChatHelper_h
#define ZZChatHelper_h

#import "RealTimeLocationViewController.h"
#import "ZZOrderLocationViewController.h"
#import "ZZRentViewController.h"
#import "ZZRentMemedaViewController.h"
#import "ZZOrderDetailViewController.h"
#import "ZZOrderCommentViewController.h"
#import "ZZReportViewController.h"
#import "ZZPayViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZRentChooseSkillViewController.h"
#import "ZZOrderOptionsTableViewController.h"
#import "ZZUserEditViewController.h"
#import "TZImagePickerController.h"

#import "ZZChatOrderStatusView.h"
#import "ZZChatPacketAlertView.h"
#import "ZZChatStatusSheetView.h"
#import "ZZOrderTimeLineView.h"
#import "ZZChatOrderDealView.h"
#import "ZZChatTopView.h"

#import "ZZMessage.h"
#import "ZZChatStatusModel.h"
#import "ZZOrder.h"

#import <RongIMKit/RongIMKit.h>
#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"
#import "ZZRecordManager.h"
#import "ZZFileHelper.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoItem.h"
#import "ZZUploader.h"
#import "ZZReportModel.h"
#import "ZZPublishModel.h"
#import "ZZLiveStreamHelper.h"

#import "ZZChatBaseModel.h"
#import "ZZChatPacketModel.h"
#import "ZZChatOrderInfoModel.h"
#import "ZZChatReportModel.h"
#import "ZZChatCancelModel.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZChatConnectModel.h"
#import "ZZChatSelectionModel.h"

#import "ZZChatHeadLodingView.h"
#import "ZZChatVoiceHud.h"
#import "ZZChatPacketInfoView.h"
#import "ZZChatSensitiveAlertView.h"
#import "ZZliveStreamConnectingView.h"
#import "ZZLiveStreamConnectViewController.h"

#import "ZZChatBaseCell.h"
#import "ZZChatTextCell.h"
#import "ZZChatImageCell.h"
#import "ZZChatVoiceCell.h"
#import "ZZChatLocationCell.h"
#import "ZZChatRealTimeStartCell.h"
#import "ZZChatRealTimeEndCell.h"
#import "ZZChatNotificationCell.h"
#import "ZZChatPacketCell.h"
#import "ZZChatOrderInfoCell.h"
#import "ZZChatConnectCell.h"

static NSString *SightVideoText = @"SightVideoTextCell";
static NSString *ChatText = @"ChatTextCell";
static NSString *ChatImage = @"ChatImageCell";
static NSString *ChatVoice = @"ChatVoiceCell";
static NSString *ChatCall = @"ChatCall";
static NSString *ChatGiftCell = @"ChatGiftCell";
static NSString *ChatKTVCell = @"ChatKTVCell";
static NSString *ChatLoacation = @"ChatLoacation";
static NSString *ChatVideoMessageCell = @"ChatVideoMessageCell";
static NSString *ChatRealTimeStart = @"ChatRealTimeStart";
static NSString *ChatRealTimeEnd = @"ChatRealTimeEnd";
static NSString *ChatInfoNotification = @"ChatInfoNotification";
static NSString *ChatRecall = @"ChatRecall";
static NSString *ChatPacket = @"ChatPacket";
static NSString *ChatOrderInfo = @"ChatOrderInfo";
static NSString *ChatConnect = @"ChatConnect";
static NSString *BurnAfterRead = @"BurnReaded";//阅后即焚
static NSString *PrivateChatPay = @"PrivateChatPay";//私聊付费
static NSString *ChatGifMessageCell = @"ChatGifMessageCell";//gif的
static NSString *ChatTaskFreeModelMessageCell = @"ChatTaskFreeModelMessageCell";//gif的
static NSString *ChatInviteVideoChatModelMessageCell = @"ChatInviteVideoChatModelMessageCell";//邀请视频聊天

static NSString *ChatWechatPayModel = @"ZZMessageChatWechatPayModel";//微信号评价
static NSString *ChatIDPhotoPayCellIdentifier = @"ChatIDPhotoPayCellIdentifier";//微信号评价

static NSInteger BurnMaxCount = 30;

/**
 *  工具栏 -- 更多类别
 */
typedef NS_ENUM(NSInteger, ChatBoxMoreType) {
    /**
     *  照片
     */
    ChatBoxMoreTypeAlbum = 0,
    /**
     *  拍照
     */
    ChatBoxMoreTypeCamera,
    /**
     *  位置
     */
    ChatBoxMoreTypeLocation,
    /**
     *  语音通话
     */
    ChatBoxMoreTypeVoice,
    /**
     *  视频通话
     */
    ChatBoxMoreTypeVideo,
    /**
     *  么么答提问
     */
    ChatBoxMoreTypeMemeda,
    /**
     *  阅后即焚
     */
    ChatBoxMoreTypeBurn
};

typedef NS_ENUM(NSInteger, ChatBoxType) {
    /**
     *  录音
     */
    ChatBoxTypeRecord = 10000,
    /**
     *  图片
     */
    ChatBoxTypeImage = 10001,
    /**
     *  视频或语言聊天
     */
    ChatBoxTypeVideo = 10002,
    /**
     *  红包
     */
    ChatBoxTypePacket = 10003,
    /**
     *  位置
     */
    ChatBoxTypeLocation = 10004,
    /**
     *  表情
     */
    ChatBoxTypeEmoji = 10005,
    /**
     *  阅后即焚
     */
    ChatBoxTypeBurn = 10006,
    /**
     *  关闭阅后即焚
     */
    ChatBoxTypeCancel = 10007,
    /**
     *  常用语
     */
    ChatBoxTypeGreeting = 10008,
    
    /**
     *  拍摄视频
     */
    ChatBoxTypeShot = 10009,
    
    /**
     *  发送礼物
     */
    ChatBoxTypeGift = 10010,
    
    ChatBoxTypeMore = 11000,

};

/**
 *  工具栏---状态
 */
typedef NS_ENUM(NSInteger, ChatBoxStatus) {
    /**
     *  正常状态
     */
    ChatBoxStatusNormal = 0,
    /**
     *  录音状态
     */
    ChatBoxStatusShowRecord,
    /**
     *  显示键盘状态
     */
    ChatBoxStatusShowKeyboard,
    /**
     *  显示表情状态
     */
    ChatBoxStatusShowEmoji,
    /**
     *  显示更多状态
     */
    ChatBoxStatusShowMore,
    /**
     *  显示常用语状态
     */
    ChatBoxStatusShowGreeting,
    
    /**
     *  阅后即焚
     */
    ChatBoxStatusBurn,
    
    /**
     *  红包
     */
    ChatBoxStatusRedPacket,
    
    
    ChatBoxStatusGift
};

#endif /* ZZChatHelper_h */
