//
//  ZZUserBlackModel.h
//  zuwome
//
//  Created by angBiu on 16/9/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZUserBlackDetailModel : JSONModel

@property (nonatomic, strong) NSString *blackId;
@property (nonatomic, strong) ZZUser *beUser;
@property (nonatomic, strong) NSString *created_at;

@end

@interface ZZUserBlackModel : JSONModel

@property (nonatomic, strong) ZZUserBlackDetailModel *black;
@property (nonatomic, strong) NSString *sort_value;

- (void)getBlackList:(NSDictionary *)aDict next:(requestCallback)next;

@end
