//
//  ZZMemedaTopicModel.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ZZMemedaTopicModel
@end

@interface ZZMemedaTopicModel : JSONModel

@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *desc;

/**
 *  获取么么答标签列表
 *
 *  @param next 回调
 */
- (void)getMemedaTopics:(requestCallback)next;

/**
 *  获取某个标签的么么答列表
 *
 *  @param topicId 标签id
 *  @param next    回调
 */
- (void)getTopicMemedaListParam:(NSDictionary *)param topicId:(NSString *)topicId next:(requestCallback)next;

@end

