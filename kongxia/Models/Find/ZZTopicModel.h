//
//  ZZTopicModel.h
//  zuwome
//
//  Created by angBiu on 2017/4/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZTopicGroupModel : JSONModel

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger browser_count;
@property (nonatomic, assign) NSInteger video_count;
@property (nonatomic, assign) BOOL hot;
@property (nonatomic, strong) NSString *created_at_text;

@end

@interface ZZTopicModel : JSONModel

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) ZZTopicGroupModel *group;

+ (void)getTopicsWithParam:(NSDictionary *)param next:(requestCallback)next;

+ (void)getSKTopicWithParam:(NSDictionary *)param next:(requestCallback)next;

+ (void)getTopicDetail:(NSString *)groupId next:(requestCallback)next;

@end
