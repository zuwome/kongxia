//
//  ZZMessageBoxConfigModel.h
//  zuwome
//
//  Created by angBiu on 2017/6/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZMessageBoxConfigModel : JSONModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger user_count;
@property (nonatomic, strong) NSString *latest_at;
@property (nonatomic, strong) NSString *latest_at_text;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *videoMessageType;



@end
