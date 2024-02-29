//
//  ZZSKModel.h
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaModel.h"
//#import "ZZUserLabel.m"

@protocol ZZSKModel
@end

@interface ZZSKModel : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray<ZZMemedaTopicModel> *groups;
@property (nonatomic, strong) ZZMMDVideoModel *video;
@property (nonatomic, assign) NSInteger browser_count;
@property (nonatomic, assign) NSInteger reply_count;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger tip_count;
@property (nonatomic, assign) NSInteger share_count;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) NSString *loc_name;
@property (nonatomic,assign) float loca_name_height;//地理定位的高度
@property (nonatomic, assign) BOOL is_base_sk;

+ (void)zanSkWithModel:(ZZSKModel *)model next:(requestCallback)next;
+ (void)unzanSkWithModel:(ZZSKModel *)model next:(requestCallback)next;
+ (void)getSKDetail:(NSString *)skId params:(NSDictionary *)params next:(requestCallback)next;
+ (void)getSKCommentList:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next;
+ (void)commentMememdaParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next;
+ (void)dashangSkWithParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next;
+ (void)deleteSKWithSkId:(NSString *)skId param:(NSDictionary *)param next:(requestCallback)next;
+ (void)deleteComentWithSkId:(NSString *)skId replyId:(NSString *)replyId next:(requestCallback)next;

@end

@interface ZZSKDetailModel : JSONModel

@property (nonatomic, assign) BOOL like_status;
@property (nonatomic, strong) ZZSKModel *sk;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *sk_tips;//悬赏榜（3个人）

@end
