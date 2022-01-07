//
//  ZZUpdateModel.h
//  zuwome
//
//  Created by angBiu on 16/5/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class ZZVersionModel;

@interface ZZUpdateModel : JSONModel

@property (nonatomic, assign) NSInteger haveNewVersion;
@property (nonatomic, strong) ZZVersionModel *version;

@end

@interface ZZVersionModel : JSONModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) NSInteger __v;

@end
