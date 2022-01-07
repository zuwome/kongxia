//
//  ESBannerModel.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESBannerModel : NSObject

@property (nonatomic, copy) NSString *bannerImage;

@property (nonatomic, copy) NSString *backImage;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
