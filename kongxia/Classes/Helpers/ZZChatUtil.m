//
//  ZZChatUtil.m
//  zuwome
//
//  Created by angBiu on 2016/11/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatUtil.h"

#import "ZZDateHelper.h"
#import "ZZVideoMessage.h"//视屏挂断
#import "ZZMessageChatWechatPayModel.h"//微信号评价
#import "ZZGifMessageModel.h"
#import "TTTAttributedLabel.h"
#import "ZZChatTaskFreeModel.h"
#import "ZZChatGiftModel.h"
#import "ZZChatKTVModel.h"
#import "ZZVideoInviteModel.h"

@implementation ZZChatUtil

+ (BOOL)isUpdatePrivChatMessage:(RCMessageContent *)content {
    if ([content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *message = ( RCTextMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[ZZGifMessageModel class]]) {
        ZZGifMessageModel *message = ( ZZGifMessageModel *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCVoiceMessage class]]) {
        RCVoiceMessage *message = ( RCVoiceMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *message = ( RCImageMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCLocationMessage class]]) {
        RCLocationMessage *message = ( RCLocationMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (BOOL)isPrivChatMessage:(ZZChatBaseModel *)model {
    RCMessageContent *content = model.message.content;
    if ([content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *message = ( RCTextMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCVoiceMessage class]]) {
        RCVoiceMessage *message = ( RCVoiceMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *message = ( RCImageMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[RCLocationMessage class]]) {
        RCLocationMessage *message = ( RCLocationMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    if ([content isKindOfClass:[ZZGifMessageModel class]]) {
        ZZGifMessageModel *message = ( ZZGifMessageModel *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
        if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
            return YES;
        }
        return NO;
    }
    return NO;
}
+ (BOOL)canShowMenu:(ZZChatBaseModel *)model
{
    RCMessageContent *content = model.message.content;
    if ([content isKindOfClass:[RCTextMessage class]]) {
        return YES;
    }
    if ([content isKindOfClass:[RCVoiceMessage class]]) {
        return YES;
    }
    if ([content isKindOfClass:[RCImageMessage class]]) {
        return YES;
    }
    if ([content isKindOfClass:[RCLocationMessage class]]) {
        return YES;
    }
    if ([content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        return YES;
    }
    if ([content isKindOfClass:[RCRealTimeLocationEndMessage class]]) {
        return NO;
    }
    if ([content isKindOfClass:[RCInformationNotificationMessage class]]) {
        return NO;
    }
    if ([content isKindOfClass:[ZZChatOrderInfoModel class]]) {
        return NO;
    }
    if ([content isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
        return NO;
    }
    if ([content isKindOfClass:[RCTextMessage class]]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getIdentifierStringWithMessage:(ZZChatBaseModel *)model
{
    RCMessageContent *content = model.message.content;
    if ([content isKindOfClass:[RCTextMessage class]]) {
        return ChatText;
    }
    else if ([content isKindOfClass:[RCSightMessage class]]) {
        return SightVideoText;
    }
    else if ([content isKindOfClass:[RCVoiceMessage class]]) {
        return ChatVoice;
    }
    else if ([content isKindOfClass:[RCImageMessage class]]) {
        return ChatImage;
    }
    else if ([content isKindOfClass:[RCLocationMessage class]]) {
        return ChatLoacation;
    }
    else if ([content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        return ChatRealTimeStart;
    }
    else if ([content isKindOfClass:[RCRealTimeLocationEndMessage class]]) {
        return ChatRealTimeEnd;
    }
    else if ([content isKindOfClass:[ZZChatPacketModel class]]) {
        return ChatPacket;
    }
    else if ([content isKindOfClass:[RCInformationNotificationMessage class]]) {
        return ChatInfoNotification;
    }
    else if ([content isKindOfClass:[RCRecallNotificationMessage class]]) {
        return ChatInfoNotification;
    }
    else if ([content isKindOfClass:[ZZChatOrderInfoModel class]]) {
        return ChatOrderInfo;
    }
    else if ([content isKindOfClass:[ZZChatOrderNotifyModel class]]){
        return ChatOrderInfo;
    }
    else if ([content isKindOfClass:[ZZChatConnectModel class]]) {
        return ChatConnect;
    }
    else if ([content isKindOfClass:[ZZVideoMessage class]]) {
        return ChatVideoMessageCell;
    }
    else if ([content isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
        return ChatWechatPayModel;
    }
    else if ([content isKindOfClass:[ZZGifMessageModel class]]) {
        return ChatGifMessageCell;
    }
    else if ([content isKindOfClass:[ZZChatTaskFreeModel class]]) {
        return ChatTaskFreeModelMessageCell;
    }
    else if ([content isKindOfClass:[ZZChatGiftModel class]]) {
        return ChatGiftCell;
    }
    else if ([content isKindOfClass:[ZZChatKTVModel class]]) {
        return ChatKTVCell;
    }
    else if ([content isKindOfClass:[ZZVideoInviteModel class]]) {
        return  ChatInviteVideoChatModelMessageCell;
    }
    return ChatInfoNotification;
}

+ (ChatCellType)getCellTypeWithMessage:(ZZChatBaseModel *)model {
    RCMessageContent *content = model.message.content;
    if ([content isKindOfClass:[RCTextMessage class]]) {
        return ChatCellTypeText;
    }
    else if ([content isKindOfClass:[RCSightMessage class]]) {
        return ChatCellTypeSightVideo;
    }
    else if ([content isKindOfClass:[RCVoiceMessage class]]) {
        return ChatCellTypeVoice;
    }
    else if ([content isKindOfClass:[RCImageMessage class]]) {
        return ChatCellTypeImage;
    }
    else if ([content isKindOfClass:[RCLocationMessage class]]) {
        return ChatCellTypeLoacation;
    }
    else if ([content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        return ChatCellTypeRealTimeStart;
    }
    else if ([content isKindOfClass:[RCRealTimeLocationEndMessage class]]) {
        return ChatCellTypeRealTimeEnd;
    }
    else if ([content isKindOfClass:[ZZChatPacketModel class]]) {
        return ChatCellTypePacket;
    }
    else if ([content isKindOfClass:[RCInformationNotificationMessage class]]) {
        return ChatCellTypeNofitication;
    }
    else if ([content isKindOfClass:[RCRecallNotificationMessage class]]) {
        return ChatCellTypeNofitication;
    }
    else if ([content isKindOfClass:[ZZChatOrderInfoModel class]]) {
        return ChatCellTypeOrderInfo;
    }
    else if ([content isKindOfClass:[ZZChatOrderNotifyModel class]]) {
        return ChatCellTypeOrderInfo;
    }
    else if ([content isKindOfClass:[ZZChatConnectModel class]]) {
        return ChatCellTypeConnect;
    }
    else if ([content isKindOfClass:[ZZVideoMessage class]]) {
        return ChatCellTypeCallVideo;
    }
    else if ([content isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
        return ChatCellTypeWechatPay;
    }
    else if ([content isKindOfClass:[ZZGifMessageModel class]]) {
        return ChatCellTypeGif;
    }
    else if ([content isKindOfClass:[ZZChatTaskFreeModel class]]) {
        return ChatCellTypeTaskFree;
    }
    else if ([content isKindOfClass:[ZZChatGiftModel class]]) {
        return ChatCellTypeGift;
    }
    else if ([content isKindOfClass:[ZZChatKTVModel class]]) {
        return ChatCellTypeKTV;
    }
    else if ([content isKindOfClass:[ZZVideoInviteModel class]]) {
        return ChatCellTypeInviteVideo;
    }
    return ChatCellTypeNofitication;
}

+ (ChatCellLongPressType)getCellLongPressTypeWithMessage:(ZZChatBaseModel *)model {
    RCMessage *message = model.message;
    if (message.messageDirection == MessageDirection_SEND) {
        if ([message.content isKindOfClass:[RCTextMessage class]]) {
            return [model isPassRevokeTime] ? ChatCellLongPressTypeDeleteAndCopy : ChatCellLongPressTypeAll;
        }
        else if ([message.content isKindOfClass:[ZZChatPacketModel class]]) {
            return ChatCellLongPressTypeDelete;
        }
        else if ([ZZDateHelper isNearTime:message.sentTime]) {
            return ChatCellLongPressTypeDeleteAndRecall;
        }
        else {
            return ChatCellLongPressTypeDelete;
        }
    }
    else {
        if ([message.content isKindOfClass:[RCTextMessage class]]) {
            return ChatCellLongPressTypeDeleteAndCopyAndReport;
        }
        else if ([message.content isKindOfClass:[RCImageMessage class]]) {
            return ChatCellLongPressTypeDeleteAndReoprt;
        }
        else if ([message.content isKindOfClass:[ZZChatPacketModel class]]) {
            return ChatCellLongPressTypeDelete;
        }
        else {
            return ChatCellLongPressTypeDelete;
        }
    }
}

+ (NSString *)getInfoStringWithString:(NSString *)string {
    NSString *infoString = @"";

    NSRange range20 = [string rangeOfString:@"电话"];
    NSRange range21 = [string rangeOfString:@"手机"];
    NSRange range3 = [string rangeOfString:@"身份证"];
    if (range20.location != NSNotFound || range21.location != NSNotFound) {
        infoString = @"请注意保护自己的隐私，建议不要把联系电话直接提供给对方哦~可试试 空虾视频通话";
    } else if (range3.location != NSNotFound) {
        infoString = @"请注意保护自己的隐私，建议不要把个人身份信息直接给对方哦~";
    }
    
    return infoString;
}

+ (CGFloat)getCellHeightWithModel:(ZZChatBaseModel *)model {
    ChatCellType type = [self getCellTypeWithMessage:model];
    CGFloat height = 30;
    if (model.showTime && type != ChatCellTypeInviteVideo) {
        height = 60;
    }
    RCMessage *message = model.message;
    float  currentHeight =0;
    if (model.cellHeight>0) {
        return height + model.cellHeight;
    }
    switch (type) {
        case ChatCellTypeTaskFree: {
            currentHeight = 85;
            break;
        }
        case ChatCellTypeSightVideo: {
            RCSightMessage *sightMessage = (RCSightMessage *)model.message.content;
            CGFloat imageHeight = 180;
            currentHeight = imageHeight ;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:sightMessage.extra][@"payChat"];
            if ([sightMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 11.8;
            }
            break;
        }
        case ChatCellTypeWechatPay: {
            if ([message.content isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
                ZZMessageChatWechatPayModel *infoModel = (ZZMessageChatWechatPayModel *)message.content;
                CGFloat titleHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH];
                CGFloat contentHeight = [ZZUtils heightForCellWithText:infoModel.content fontSize:12 labelWidth:(SCREEN_WIDTH - 30 - 16)];
                currentHeight = titleHeight + 10 + 5 + 10 + contentHeight ;
            }
            break;
        }
        case ChatCellTypeText: {
            CGFloat maxWidth = SCREEN_WIDTH - 180;
            RCTextMessage *text = (RCTextMessage *)message.content;
            currentHeight  = [ZZUtils heightForCellWithText:text.content fontSize:15 labelWidth:maxWidth] + 24 ;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:text.extra][@"payChat"];
            if ([text.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 10;
            }
            break;
         }
        case ChatCellTypeGif: {
            ZZGifMessageModel *gifMessage = (ZZGifMessageModel *)message.content;
            if (gifMessage.gifHeight<=0) {
                gifMessage.gifHeight = 120;
                gifMessage.gifWidth = 120;
            }
            currentHeight  = (gifMessage.gifHeight/2.0f) +5;
            
            NSString *extra =  [ZZUtils dictionaryWithJsonString:gifMessage.extra][@"payChat"];
            if ([gifMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 10;
            }
            break;
        }
        case ChatCellTypeVoice: {
            RCVoiceMessage *voiceMessage = (RCVoiceMessage *)message.content;
            currentHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH] + 24 ;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:voiceMessage.extra][@"payChat"];
            if ([voiceMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 10;
            }
            break;
        }
        case ChatCellTypeImage: {
            RCImageMessage *ImageMessage = (RCImageMessage *)model.message.content;
            CGFloat imageHeight = 120;
            if (ImageMessage.thumbnailImage.size.width > 121 || ImageMessage.thumbnailImage.size.height > 121) {
                imageHeight = ImageMessage.thumbnailImage.size.height / 2.0f;
            } else {
                imageHeight = ImageMessage.thumbnailImage.size.height;
            }
            currentHeight = imageHeight ;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:ImageMessage.extra][@"payChat"];
            if ([ImageMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 11.8;
            }
            break;
        }
        case ChatCellTypeLoacation: {
            RCLocationMessage *locationMessage = (RCLocationMessage *)model.message.content;
            CGFloat imageWidth = SCREEN_WIDTH/2.0f;
            CGFloat imageHeight = imageWidth * locationMessage.thumbnailImage.size.height/locationMessage.thumbnailImage.size.width;
            currentHeight = imageHeight ;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:locationMessage.extra][@"payChat"];
            if ([locationMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                currentHeight = currentHeight + 11.8;
            }
            break;
        }
        case ChatCellTypeCall: {
            currentHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH] + 24 ;
            break;
        }
        case ChatCellTypeOrderInfo: {
            if ([message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
                ZZChatOrderInfoModel *infoModel = (ZZChatOrderInfoModel *)message.content;
                CGFloat titleHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH];
                CGFloat contentHeight = [ZZUtils heightForCellWithText:infoModel.content fontSize:12 labelWidth:(SCREEN_WIDTH - 30 - 16)];
                currentHeight = titleHeight + 10 + 5 + 10 + contentHeight ;
            }
            else if ([message.content isKindOfClass:[ZZChatOrderNotifyModel class]]) {
                ZZChatOrderNotifyModel *notifyModel = (ZZChatOrderNotifyModel *)message.content;
                CGFloat titleHeight = [ZZUtils heightForCellWithText:notifyModel.title fontSize:15 labelWidth:SCREEN_WIDTH];
                CGFloat contentHeight = [ZZUtils heightForCellWithText:notifyModel.message fontSize:12 labelWidth:(SCREEN_WIDTH - 30 - 16)];
                currentHeight = titleHeight + 10 + 5 + 10 + contentHeight;
            }
            else {
                height = 10;
            }
            break;
        }
        case ChatCellTypePacket: {
            ZZChatPacketModel *packetModel = (ZZChatPacketModel *)message.content;
            CGFloat width = SCREEN_WIDTH - 40*2 - 20;
            if (message.messageDirection == MessageDirection_RECEIVE) {
                width = width - 8;
            }
            CGFloat bgHeight = 0;
            CGFloat contentHeight = [ZZUtils heightForCellWithText:packetModel.content fontSize:14 labelWidth:(width - 44 - 24)];
            if (contentHeight < 80) {
                bgHeight = 80 + 28;
            }
            else {
                bgHeight = contentHeight + 28;
            }
            currentHeight = bgHeight ;
            break;
        }
        case ChatCellTypeNofitication: {
            currentHeight = height - 30;
            NSString *content = @"哈哈哈哈";
            CGFloat maxWidth = SCREEN_WIDTH - 30;
            if ([message.content isKindOfClass:[RCInformationNotificationMessage class]]) {
                RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)message.content;
                content = notificationMessage.message;
            }
            else if ([message.content isKindOfClass:[RCRecallNotificationMessage class]]) {
                content = @"你撤回了一条消息";
            }
            else if ([message.content isKindOfClass:[ZZChatReportModel class]]) {
                ZZChatReportModel *model = (ZZChatReportModel *)message.content;
                content = model.message;
            }
            else if ([message.content isKindOfClass:[ZZChatSelectionModel class]]) {
                ZZChatSelectionModel *model = (ZZChatSelectionModel *)message.content;
                content = model.message;
            }
            else if ([message.content isKindOfClass:[ZZChatCancelModel class]]) {
                ZZChatCancelModel *model = (ZZChatCancelModel *)message.content;
                content = model.message;
            }
            else {
                content = @"无法识别的类型，请升级到最新版本";
            }
            CGFloat contentHeight = [TTTAttributedLabel sizeThatFitsAttributedString:[ZZUtils setLineSpace:content space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)] withConstraints:CGSizeMake(maxWidth, 9999) limitedToNumberOfLines:999].height;
            currentHeight = contentHeight + currentHeight + 25;
            break;
        }
        case ChatCellTypeRealTimeStart: {
            currentHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH] + 24 ;
            break;
        }
        case ChatCellTypeRealTimeEnd: {
            currentHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH] + 6 ;
            break;
        }
        case ChatCellTypeConnect: {
            ZZChatConnectModel *content = (ZZChatConnectModel *)model.message.content;
            if (model.message.messageDirection == MessageDirection_SEND && content.type == 1) {
                height = 120;
            }
            else {
                height = 0;
            }
             break;
        }
        case ChatCellTypeCallVideo: {   //暂时用自适应解决显示问题，内容多了可能会卡顿，后期如有需要再排查（原因在于融云返回的数据文本与界面显示文本不一致，计算高度有误导致的）
            CGFloat maxWidth = SCREEN_WIDTH - 40 - 10 - 20 - 50;
            RCTextMessage *text = (RCTextMessage *)message.content;
            currentHeight = [ZZUtils heightForCellWithText:text.content fontSize:15 labelWidth:maxWidth] + 24 ;
            break;
        }
        case ChatCellTypeGift: {
            CGFloat maxWidth = 204;
            ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
            CGFloat titleHeight  = [ZZUtils heightForCellWithText:giftMessage.from_msg_a fontSize:15 labelWidth:maxWidth];
            CGFloat subTitleHeight  = [ZZUtils heightForCellWithText:giftMessage.to_msg_a fontSize:13 labelWidth:maxWidth];
            currentHeight += titleHeight + 3 + subTitleHeight + 24;
            currentHeight = currentHeight < 75 ? 75 : currentHeight;
            break;
        }
        case ChatCellTypeKTV: {
            currentHeight = 94;
            break;
        }
        case ChatCellTypeInviteVideo: {
            height = 0;
            if ([model.message.senderUserId isEqualToString: [ZZUserHelper shareInstance].loginer.uid]) {
                currentHeight = 0;
            }
            else {
                currentHeight = 42;
            }
            break;
        }
        default:
            break;
    }
    
    model.cellHeight = currentHeight;
    height =  model.cellHeight  + height;
    return height;
}

+ (NSString *)getSensitiveStringWithString:(NSString *)content
{
    NSArray *strings = [ZZUserHelper shareInstance].configModel.chat_forbidden_words;
    for (NSString *string in strings) {
        NSRange range = [content rangeOfString:string];
        if (range.location != NSNotFound) {
            return @"如遇骚扰，请点击此处立即举报";
            break;
        }
    }
    return nil;
}

+ (NSString *)getThirdPayInfoStringWithString:(NSString *)string {
    NSString *infoString = @"";
    if ([self isFiveContinuityLetterOrNumber:string]) {
        infoString = [self thirdInfoString];
    }
    return infoString;
}

+ (NSString *)thirdInfoString {
    return @"为了保障双方利益，请不要通过微信等第三方软件联系，如果出现纠纷，平台只视空虾APP聊天凭证为有效证据";
}

+ (NSString *)oldPayInfoString {
    return @"为了保障您的交易安全，建议不要通过其他平台或银行卡来进行交易转账";
}

+ (NSString *)newThirdInfoString {
    return @"为了保障双方利益，请不要通过微信、支付宝等第三方支付方式进行交易，若涉嫌引导平台外交易，可立即匿名截屏举报";
}

+ (BOOL)isWxSensitiveString:(NSString *)content {
    if ([self isFiveContinuityLetterOrNumber:content]) {
        return YES;
    } else {
        NSArray *array = @[@"微信",@"wx",@"WX",@"weixin"];
        for (NSString *subString in array) {
            NSRange range = [content rangeOfString:subString];
            if (range.location != NSNotFound) {
                return YES;
                break;
            }
        }
    }
    return NO;
}

+ (BOOL)isAviableMessage:(RCMessage *)message {
    if ([message.content isKindOfClass:[RCInformationNotificationMessage class]] && message.conversationType == ConversationType_PRIVATE) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)message.content;
        if ([notification.message isEqualToString:[self thirdInfoString]]) {
            return NO;
        }
        if ([notification.message isEqualToString:[self oldPayInfoString]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)shouldSendReadStatus:(RCMessage *)message {
    if (message.messageDirection == MessageDirection_SEND) {
        return NO;
    }
    if ([message.content isKindOfClass:[ZZChatOrderInfoModel class]] || [message.content isKindOfClass:[RCInformationNotificationMessage class]] || [message.content isKindOfClass:[ZZChatCancelModel class]]) {
        return NO;
    } else if ([message.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)message.content;
        if ([text.extra isEqualToString:@"FromLocalServer"]) {
            return NO;
        }
    }
    return YES;
}

+ (id)getMessageListContent:(RCConversation *)model userInfo:(ZZUserInfoModel *)userInfo {
    
    if (isNullString(model.draft)) {
        if ([userInfo.animationUsersArr containsObject: [ZZUserHelper shareInstance].loginer.uid]) {
            NSString *string =  @"[收到礼物]";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(254, 66, 70) range:NSMakeRange(0, string.length)];
            return attributedString;
        }

        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *message = (RCTextMessage *)model.lastestMessage;
            return message.content;
        }
        else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
            return @"[图片]";
        }
        else if ([model.lastestMessage isKindOfClass:[RCSightMessage class]]) {
            return @"[小视频]";
        }
        else if ([model.lastestMessage isKindOfClass:[ZZVideoMessage class]]) {
            return @"[视频通话]";
        }
        else if ([model.lastestMessage isKindOfClass:[ZZGifMessageModel class]]) {
            return @"[动画表情]";
        }
        else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
            return @"[位置]";
        }
        else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
            return @"[语音]";
        }
        else if ([model.lastestMessage isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
            return @"我发起了位置共享";
        }
        else if ([model.lastestMessage isKindOfClass:[RCRealTimeLocationEndMessage class]]) {
            return @"位置共享已结束";
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatPacketModel class]]) {
            return @"[红包留言]";
        }
        else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]) {
            RCRecallNotificationMessage *message = (RCRecallNotificationMessage *)model.lastestMessage;
            if ([message.operatorId isEqualToString:userInfo.uid]) {
                return [NSString stringWithFormat:@"%@撤回了一条消息",userInfo.nickname];
            } else {
                return @"你撤回了一条消息";
            }
        }
        else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]) {
            RCInformationNotificationMessage *message = (RCInformationNotificationMessage *)model.lastestMessage;
            return message.message;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatOrderInfoModel class]]) {
            ZZChatOrderInfoModel *message = (ZZChatOrderInfoModel *)model.lastestMessage;
            return message.title;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatReportModel class]]) {
            ZZChatReportModel *message = (ZZChatReportModel *)model.lastestMessage;
            return message.message;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatCancelModel class]]) {
            ZZChatCancelModel *message = (ZZChatCancelModel *)model.lastestMessage;
            return message.message;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatOrderNotifyModel class]]) {
            ZZChatOrderNotifyModel *message = (ZZChatOrderNotifyModel *)model.lastestMessage;
            return message.message;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatConnectModel class]]) {
            ZZChatConnectModel *message = (ZZChatConnectModel *)model.lastestMessage;
            return message.content;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatSelectionModel class]]) {
            ZZChatSelectionModel *message = (ZZChatSelectionModel *)model.lastestMessage;
            return message.message;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
            ZZMessageChatWechatPayModel *message = (ZZMessageChatWechatPayModel *)model.lastestMessage;
            return message.conversationDigest;
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatGiftModel class]]) {
            if (model.lastestMessageDirection == MessageDirection_SEND) {
                return @"心意已送达，TA打开私信就能看到你的礼物";
            }
            else {
                NSString *string =  @"[收到礼物]";
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(254, 66, 70) range:NSMakeRange(0, string.length)];
                return attributedString;
            }
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatKTVModel class]]) {
            ZZChatKTVModel *ktvModel = (ZZChatKTVModel *)model.lastestMessage;
            if (model.lastestMessageDirection == MessageDirection_SEND) {
                return ktvModel.songStatus;
            }
            else {
                return @"[唱趴任务]";
            }
        }
        else if ([model.lastestMessage isKindOfClass:[ZZChatTaskFreeModel class]]) {
            ZZChatTaskFreeModel *message = (ZZChatTaskFreeModel *)model.lastestMessage;
            if (isNullString(message.message)) {
                return @"嗨，我对你发布的活动很感兴趣";
            }
            else {
                return message.message;
            }
        }
        else if ([model.lastestMessage isKindOfClass:[ZZVideoInviteModel class]]) {
            ZZVideoInviteModel *message = (ZZVideoInviteModel *)model.lastestMessage;
            if (isNullString(message.message)) {
                return @"他在线邀请您视频通话";
            }
            else {
                return message.message;
            }
        }
        else {
            return @"";
        }
    } else {
        NSString *string = [NSString stringWithFormat:@"[草稿]%@",model.draft];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [string rangeOfString:@"[草稿]"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range];
        return attributedString;
    }
}

+ (BOOL)isFiveContinuityLetterOrNumber:(NSString *)string
{
    NSInteger count = 0;
    for (int i=0; i<string.length; i++) {
        NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
        NSString *phoneRegex = @"^[A-Za-z0-9_-]+$";
        if (i==0) {
            phoneRegex = @"^[A-Za-z0-9]+$";
        }
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL isMatch = [pred evaluateWithObject:subString];
        if (isMatch) {
            count++;
            if (i == string.length - 1) {
                if (count >= 6 && count <= 20) {
                    return YES;
                }
            }
        } else {
            if (count >= 6 && count <= 20) {
                return YES;
            }
            count = 0;
        }
    }
    return NO;
}

+ (NSString *)getPushContent:(BOOL)showPushName
{
    if (!showPushName) {
        return @"收到一条新的信息";
    } else {
        
        return nil;
    }
}

/**
自定义视频挂断消息
 */
+ (NSString *)getPushVideoContent
{
   return @"[新的视频通话]";
}

+ (BOOL)isReceiveBurnReadedMessage:(ZZChatBaseModel *)model
{
    RCMessageContent *content = model.message.content;
    if ([content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)content;
        if ([text.extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    } else if ([content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *image = (RCImageMessage *)content;
        if ([image.extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    }
    return NO;
}

/**
 阅后即焚
 
 */
+ (BOOL)isBurnAfterReadMessage:(ZZChatBaseModel *)model
{
    RCMessageContent *content = model.message.content;
    if (model.message.messageDirection == MessageDirection_SEND) {
        if (model.message.sentStatus == SentStatus_READ) {
            return [self isMesssageContentIsBurnReaded:content];
        }
    } else {
        return [self isMesssageContentIsBurnReaded:content];
    }
    return NO;
}

+ (BOOL)isMesssageContentIsBurnReaded:(RCMessageContent *)content {
    if ([content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:text.extra][@"payChat"];
        if ([text.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    }
    else if ([content isKindOfClass:[RCVoiceMessage class]]) {
        RCVoiceMessage *voice = (RCVoiceMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:voice.extra][@"payChat"];
        if ([voice.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    }
    else if ([content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *image = (RCImageMessage *)content;
         NSString *extra =  [ZZUtils dictionaryWithJsonString:image.extra][@"payChat"];
        if ([image.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    }
    else if ([content isKindOfClass:[ZZGifMessageModel class]]) {
        RCImageMessage *image = (RCImageMessage *)content;
        NSString *extra =  [ZZUtils dictionaryWithJsonString:image.extra][@"payChat"];
        if ([image.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isLocalBurnReadedMessage:(ZZChatBaseModel *)model {
    RCMessageContent *content = model.message.content;
    
    if (model.message.messageDirection == MessageDirection_SEND) {
        if (model.message.sentStatus == SentStatus_READ) {
            return [self isMesssageContentIsBurnReaded:content];
        }
    } else {
        if ([content isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *text = (RCTextMessage *)content;
            NSDictionary *extraDic  = [ZZUtils dictionaryWithJsonString:text.extra];
            NSString *extra = extraDic[@"payChat"];
            if ([text.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
                return YES;
            }
        } else if ([content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *image = (RCImageMessage *)content;
            NSDictionary *extraDic  = [ZZUtils dictionaryWithJsonString:image.extra];
            NSString *extra = extraDic[@"payChat"];
            if ([image.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
                return YES;
            }
        } else if ([content isKindOfClass:[RCVoiceMessage class]]) {
            RCVoiceMessage *voice = (RCVoiceMessage *)content;
            NSDictionary *extraDic  = [ZZUtils dictionaryWithJsonString:voice.extra];
            NSString *extra = extraDic[@"payChat"];
            if (([voice.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead])&& model.message.receivedStatus == ReceivedStatus_LISTENED) {
                return YES;
            }
        }
        else if ([content isKindOfClass:[ZZGifMessageModel class]]) {
            RCImageMessage *image = (RCImageMessage *)content;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:image.extra][@"payChat"];
            if ([image.extra isEqualToString:BurnAfterRead]||[extra isEqualToString:BurnAfterRead]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - 判断聊天的消息是否有礼物

@end

