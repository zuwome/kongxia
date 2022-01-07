//
//  ZZUrlSchemaModel.h
//  zuwome
//
//  Created by angBiu on 16/7/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZUrlSchemaModel : JSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;

@end
