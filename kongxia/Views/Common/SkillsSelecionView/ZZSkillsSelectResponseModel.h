//
//  ZZSkillsSelectResponseModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSkill.h"

@interface ZZSkillsSelectResponseModel : JSONModel

@property (nonatomic, copy) NSDictionary *text;

@property (nonatomic, copy) NSString *ionic_text;

@property (nonatomic, copy) NSArray<ZZSkill *><ZZSkill> *skills;


@end

