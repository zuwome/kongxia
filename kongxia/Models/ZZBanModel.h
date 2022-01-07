//
//  ZZBanModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/19.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "JSONModel.h"
@protocol ZZBanModel

@end

@interface ZZBanModel : JSONModel

@property (nonatomic,assign) BOOL     friends;

@property (nonatomic,strong) NSString *start_at;

@property (nonatomic,strong) NSString *expire;

@property (nonatomic,strong) NSString *reason;

@property (nonatomic,strong) NSString *cate; // 封禁的天数

@property (nonatomic,assign) BOOL     forever; // 是否永久封禁

@property (nonatomic, assign) BOOL    read;

@end
