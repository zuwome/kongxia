//
//  ZZAbroadLocationModel.h
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZAbroadGeometryLocationModel : JSONModel

@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;

@end

@interface ZZAbroadGeometryModel : JSONModel

@property (nonatomic, strong) ZZAbroadGeometryLocationModel *location;

@end

@interface ZZAbroadLocationResultModel : JSONModel

@property (nonatomic, strong) ZZAbroadGeometryModel *geometry;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *vicinity;

@end

@interface ZZAbroadLocationModel : JSONModel

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableArray <ZZAbroadLocationResultModel *> *results;
@property (nonatomic, strong) NSString *next_page_token;

@end
