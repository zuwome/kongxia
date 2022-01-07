//
//  ZZStoreKey.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZStoreKey.h"

@implementation ZZStoreKey

// 单例
+ (ZZStoreKey *)sharedInstance
{
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (NSString *)homeVideoDataCache
{
    return @"homeVideoDataCache";
}

- (NSString *)uploadFailureVideo
{
    return @"UploadFailureVideo";
}

- (NSString *)firstinstallapp
{
    return @"firstinstallapp";
}

- (NSString *)homeRefreshView
{
    return @"homeRefreshView";
}

- (NSString *)findAttentGuide
{
    return @"findAttentGuide";
}

- (NSString *)messageListUserInfo
{
    return @"messageListUserInfo";
}

- (NSString *)firstMyWxGuide
{
    return @"firstMyWxGuide";
}

- (NSString *)firstHomeWxGuide
{
    return @"firstHomeWxGuide";
}

- (NSString *)questionVersion
{
    return @"questionVersion";
}

- (NSString *)firstQuestionGuide
{
    return @"firstQuestionGuide";
}

- (NSString *)firstPublishOrderAlert
{
    return @"firstPublishOrderAlert";
}

- (NSString *)firstConnectAlert
{
    return @"firstConnectAlert";
}

- (NSString *)firstDeletePublishAlert
{
    return @"firstDeletePublishAlert";
}

- (NSString *)cancel_count_max
{
    return [NSString stringWithFormat:@"%@%@",[ZZUserHelper shareInstance].loginerId,@"cancel_count_max"];
}

- (NSString *)cancel_count
{
    return [NSString stringWithFormat:@"%@%@",[ZZUserHelper shareInstance].loginerId,@"cancel_count"];
}

- (NSString *)firstConnectSnatchGuide
{
    return @"firstConnectSnatchGuide";
}

- (NSString *)firstConnectWaitGuide
{
    return @"firstConnectWaitGuide";
}

- (NSString *)publishSelections
{
    return @"publishSelections";
}

- (NSString *)firstTaskPublishAlert
{
    return @"firstTaskPublishAlert";
}

- (NSString *)firstTaskSnatchListAlert
{
    return @"firstTaskSnatchListAlert";
}

- (NSString *)firstHomeTaskHotGuide
{
    return @"firstHomeTaskHotGuide";
}

- (NSString *)firstTaskCancelConfirmAlert
{
    return @"firstTaskCancelConfirmAlert";
}

- (NSString *)firstConnectSuccessGuide
{
    return @"firstConnectSuccessGuide";
}

- (NSString *)firstOnline {
    
    return @"firstOnline";
}

- (NSString *)firstOffLine {
    
    return @"firstOffLine";
}

- (NSString *)firstProtocol {
    return @"firstProtocol";
}

- (NSString *)firstInitEnableVideo {
    return @"firstInitEnableVideo";
}

- (NSString *)firstFastVideo {
    return @"firstFastVideo";
}

- (NSString *)firstCloseTopView {
    return @"firstCloseTopView";
}

- (NSString *)firstGotoFastChat {
    return @"firstGotoFastChat";
}

- (NSString *)firstShanZuTipView {
    return @"firstShanZuTipView";
}

- (NSString *)firstVideoTipView {
    return @"firstVideoTipView";
}

- (NSString *)publicTask {
    return @"publicTask";
}

- (NSString *)publicFreeTask {
    return @"publicFreeTask";
}

- (NSString *)filterOptions {
    return @"filterOptions";
}

- (NSString *)adInfo {
    return @"adInfo";
}


- (NSString *)chatGiftShowed {
    return @"chatGiftShowed";
}

@end
