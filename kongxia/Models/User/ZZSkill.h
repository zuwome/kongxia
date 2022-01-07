//
//  ZZSkill.h
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRequest.h"
#import "ZZPhoto.h"

#import <JSONModel/JSONModel.h>


@protocol ZZSkillDetail
@end
@interface ZZSkillDetail :JSONModel

@property (nonatomic, assign) NSInteger status;     //0=>审核不通过 1=>待审核 2=>已审核
@property (nonatomic, copy) NSString *content;

- (instancetype)initIfNotfound;  //服务端未返回时

@end

@protocol ZZSkillTag
@end
@interface ZZSkillTag : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tagname;
@end

@protocol ZZSkill
@end

@interface ZZSkill : JSONModel
@property (nonatomic, copy) NSString *id;           //技能id
@property (nonatomic, copy) NSString *skillID; 
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int type;// 1线下技能  2线上技能
@property (nonatomic, assign) BOOL pass;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *selected_img;
@property (nonatomic, copy) NSString *normal_img;

//2018.8.8  新版出租添加字段
@property (nonatomic, copy) NSDictionary *catalog;
@property (nonatomic, strong) ZZSkillDetail *detail;
@property (nonatomic, assign) NSInteger classify;   //主题类型：0休闲，1运动，2时尚，3生活
@property (nonatomic, assign) NSInteger oldType;
//@property (nonatomic ,copy) NSString *_id;
@property (nonatomic ,assign) NSInteger __v;
@property (nonatomic ,assign) NSInteger oldId;
@property (nonatomic ,assign) NSInteger topicStatus;//审核状态：0=>审核不通过 1=>待审核 2=>已审核 3=>待确认 4默认通过
@property (nonatomic ,strong) NSArray<ZZPhoto> *photo;//主题图片

/**
 *  档期（空闲时间）
 *  工作日 上午1，下午2，晚上3，深夜4
 *  节假日 上午5，下午6，晚上7，深夜8
 */
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *price;        //技能主题价格
@property (nonatomic, copy) NSString *pid;          //主题id

@property (nonatomic, copy) NSString *content;      //主题介绍(用于选择系统主题时显示)
@property (nonatomic, copy) NSString *url;          //主题图片地址(用于选择系统主题时显示)
@property (nonatomic, strong) NSArray<ZZSkillTag> *tags;
@property (nonatomic, copy) NSString *defaultPhotoUrl;  //系统主题图片

- (void)add:(requestCallback)next;

+ (void)syncWithParams:(NSDictionary *)params next:(requestCallback)next;

@end


