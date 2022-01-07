//
//  ZZActivityUrlModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@protocol ZZActivityUrlModel
@end
@interface ZZActivityUrlModel : JSONModel

/**
 首页闪聊小条子上的文案
 */
@property (nonatomic, copy) NSString *tipStr;//请求的ApI的接口

@property (nonatomic, strong) NSArray <ZZActivityUrlModel >* h5_activity;

/**
 活动的字典
 */
@property (nonatomic, strong) NSDictionary<ZZActivityUrlModel>*h5_activityDic;
/**
 活动网址
 */
@property(nonatomic,strong) NSString *h5_url;
/**
 活动网址
 */
@property(nonatomic,strong) NSString *detailUrl;
/**
 活动的名称
 */
@property(nonatomic,strong) NSString *h5_name;
/**
 当前的 controllerName
 */
@property(nonatomic,strong) NSDictionary *viewControllerName;


/**
 是否只是弹一次
 */
@property(nonatomic,assign) BOOL once;


/**
 当前活动是否需要打开
 */
@property(nonatomic,assign) BOOL isopen;
@end
