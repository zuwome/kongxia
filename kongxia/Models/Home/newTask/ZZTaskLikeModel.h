//
//  ZZTaskLikeModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Foundation/Foundation.h>

@interface ZZTaskLikeModel : JSONModel

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, strong) ZZUser *like_user;

@property (nonatomic, copy) NSString *pd;

@property (nonatomic, assign) NSInteger __v;

@property (nonatomic, copy) NSString *created_at;

@end

