//
//  ZZActivityUrlNetManager.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZActivityUrlNetManager.h"
#import "ZZActivityUrlModel.h"
#import "ZZGenericGuide.h"
@implementation ZZActivityUrlNetManager

+ (ZZActivityUrlNetManager *)shareInstance {
 
    dispatch_once(&ActivityUrlNetManagerOnce, ^{
        ActivityUrlNetManagerShareInstace = [[self alloc] init];
    });
    return ActivityUrlNetManagerShareInstace;
}
+ (void)requestHtmlActivityUrlDetailInfo {
    
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/system/config"]  params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
         NSLog(@"PY_h5活动的网址_%@",data);
            ZZActivityUrlModel *model = [[ZZActivityUrlModel alloc]initWithDictionary:data error:nil];
             NSString *sanChatTip = data[@"qchat"][@"tip"];
            [ZZActivityUrlNetManager shareInstance].h5_activity = model;
            [ZZActivityUrlNetManager shareInstance].h5_activity.tipStr = sanChatTip;

        
        }
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        }
    }];
}

/**
 服务器开启的h5的活动
 
 @param name 控制器的名
 */
+ (void)loadH5ActiveWithViewController:(UIViewController *)viewController isHaveReceived:(BOOL)isHaveReceived callBack:(void(^)(void))CallBack {
    if (isHaveReceived) {
        if (CallBack) {
            CallBack();
        }
        return;
    }
    NSString *currentVCName = NSStringFromClass([viewController class]);
    ZZActivityUrlModel *model = [ZZActivityUrlNetManager shareInstance].h5_activity.h5_activityDic[currentVCName];
    if (model&&model.isopen) {
        if (model.once) {
            NSString *urlKey = [NSString stringWithFormat:@"%@%@",model.h5_url,[ZZUserHelper shareInstance].loginer.uid];
            NSString *urlValue =  [ZZKeyValueStore  getValueWithKey:urlKey];
            if (urlValue) {
                if (CallBack) {
                    CallBack();
                }
                return;
            }else{
                [self loadH5ActiveDataUIWithModel:model ViewController:viewController];
                [ZZKeyValueStore saveValue:urlKey key:urlKey];
            }
            return;
        }else{
            [self loadH5ActiveDataUIWithModel:model ViewController:viewController];
        }
    }else{
        if (CallBack) {
            CallBack();
        }
    }
}
+ (void)loadH5ActiveDataUIWithModel:(ZZActivityUrlModel *)model ViewController:(UIViewController *)viewController{
    [ZZGenericGuide showAlertH5ActiveViewWithModel:model viewController:viewController];
}
@end
