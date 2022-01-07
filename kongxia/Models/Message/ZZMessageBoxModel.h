//
//  ZZMessageBoxModel.h
//  zuwome
//
//  Created by angBiu on 2017/6/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZMessageBoxDetailModel : JSONModel

@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *latest_at_text;

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *boxId;

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;


/**
 视屏挂断会多这个字段
 */
@property(nonatomic,strong) NSString *videoMessageType;
@end

@interface ZZMessageBoxModel : JSONModel

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) ZZMessageBoxDetailModel *say_hi_total;
@property (nonatomic, strong) ZZMessageBoxDetailModel *say_hi;

+ (void)getMessageBoxList:(NSDictionary *)param next:(requestCallback)next;
+ (void)sayHiWithUid:(NSString *)uid param:(NSDictionary *)param next:(requestCallback)next;

@end
