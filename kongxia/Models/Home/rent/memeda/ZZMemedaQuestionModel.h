//
//  ZZMemedaQuestionModel.h
//  zuwome
//
//  Created by angBiu on 16/8/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaTopicModel.h"

@interface ZZMemedaQuestionModel : JSONModel

@property (nonatomic, strong) NSString *questionID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray<ZZMemedaTopicModel> *groups;

/**
 *  获取么么答问题列表
 *
 *  @param next 回调
 */
+ (void)getMemedaQuestions:(NSDictionary *)param next:(requestCallback)next;

@end
