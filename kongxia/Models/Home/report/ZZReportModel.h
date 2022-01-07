//
//  ReportModel.h
//  zuwome
//
//  Created by angBiu on 16/5/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@interface ZZReportModel : JSONModel

+ (void)reportWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;

@end
