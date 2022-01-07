//
//  ZZGifMessageModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
//#import <RongIMLib/RCMessageContent.h>
//#import <RongIMLib/RCMessageContentView.h>


/**
 用于发送gif 图的
 */
@interface ZZGifMessageModel : RCMessageContent<NSCoding,RCMessageContentView>
/*!
 会话的描述类型
 */
@property(nonatomic, strong) NSString *messageDigest;
/*!
 文件类型
 type :game  代表是玩游戏的gif  Normal常用的gif
 */
@property(nonatomic, strong) NSString *type;
/**
 (游戏的最终结果)结果
 */
@property(nonatomic, assign) NSInteger resultsType;
/*!
 文件的本地路径
 */
@property(nonatomic, strong) NSString *localPath;
/*!
 文件的网络地址
 */
@property(nonatomic, strong) NSString *fileUrl;

/**
 文件的宽  android 要求要int的类型
 */
@property(nonatomic, assign) int gifWidth;
/**
 文件的高
 */
@property(nonatomic, assign) int gifHeight;
/*!
 附加信息
 */
@property(nonatomic, strong) NSString *extra;

@property(nonatomic, strong) NSIndexPath *indexPath;

/**
 所有的可能性
 */
@property(nonatomic, assign) NSInteger allResultsCount;
@end
