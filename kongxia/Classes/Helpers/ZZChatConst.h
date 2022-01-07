//
//  ZZChatConst.h
//  zuwome
//
//  Created by angBiu on 2016/11/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#ifndef ZZChatConst_h
#define ZZChatConst_h

/**
 *  EVENT
 */
#define ZZRouterEventPlayVoice               1     //播放语音
#define ZZRouterEventTapImage                2     //点击图片
#define ZZRouterEventTapLocation             3     //点击定位图片
#define ZZRouterEventTapRealTime             4     //点击位置共享
#define ZZRouterEventTapOrderInfo            5      //点击订单状态消息
#define ZZRouterEventTapPacket               6      //点击红包
#define ZZRouterEventTapCall                 7      //点击语音或者视频聊天
#define ZZWeiChatPayEventTapCall             8      //点击微信评价
#define ZZWeiChatCheckOrder                  9      //查看微信订单
#define ZZRouterEventTapVideo                10     //点击视频
#define ZZShowUpdateView                     99     // 弹出升级弹窗

#define CHAT_HEAD_WIDTH                 40

#define CHATBOX_MORE_ALBUM_TAG          1001
#define CHATBOX_MORE_CAMERA_TAG         1002
#define CHATBOX_MORE_LOCATION_TAG       1003
#define CHATBOX_MORE_VOICE_TAG          1004
#define CHATBOX_MORE_VIDEO_TAG          1005
#define CHATBOX_MORE_MEMEDA             1006
#define CHATBOX_MORE_BURN               1007

#define CHATBOX_CONTENT_HEIGHT          225
#define CHATBOX_CONTENT_ANIMATE_TIME    0.3
#define CHATBOX_MAX_ROW                 2

#define CHAT_TIME_SHOW_INTERVAL         5    //聊天界面时间显示间隔(s)

#define IMAGENAME(name)         [RCKitUtility imageNamed:name ofBundle:@"RongCloud.bundle"]

#endif /* ZZChatConst_h */
