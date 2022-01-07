//
//  ZZMessageDynamicModel.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaModel.h"
#import "ZZSKModel.h"

@interface ZZMessageDynamicDetailModel : JSONModel

@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) ZZMMDModel *mmd;
@property (nonatomic, strong) ZZSKModel *sk;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type; //"mmd_tip" => 么么答打赏 "following" => 关注 "mmd_like"  =>点赞 "sk"  =>时刻
@property (nonatomic, copy) NSString *to;
@end

@interface ZZMessageDynamicModel : JSONModel

@property (nonatomic, strong) ZZMessageDynamicDetailModel *message;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, assign) NSInteger pd;
@property (nonatomic, copy) NSString *pid;

/**
 *  动态－我的
 *
 *  @param param 分页： sort_value
 *  @param next  回调
 */
+ (void)getMyDynamicList:(NSDictionary *)param next:(requestCallback)next;

@end
