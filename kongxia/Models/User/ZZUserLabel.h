//
//  ZZUserLabel.h
//  zuwome
//
//  Created by angBiu on 16/6/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@protocol ZZUserLabel
@end

@interface ZZUserLabel : JSONModel

@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSString *content,*alias;
- (void)getData:(NSString *)url next:(requestCallback)next;
- (void)updateDataWithParam:(NSDictionary *)param next:(requestCallback)next;

@end
