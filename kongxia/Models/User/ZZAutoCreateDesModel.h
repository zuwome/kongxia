//
//  ZZAutoCreateDesModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/5/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 一键生成技能文字介绍模型
 */

@class ZZAutoCreateDimensionModel;
@class ZZAutoCreatetemplateModel;

@protocol ZZAutoCreateDimensionModel;
@protocol ZZAutoCreatetemplateModel;

@interface ZZAutoCreateDesModel: NSObject

@property (nonatomic, copy) NSArray<ZZAutoCreateDimensionModel *> *dimension;


@property (nonatomic, copy) NSArray<ZZAutoCreatetemplateModel *> *templateLists;

- (BOOL)didHaveSkills;

@end

@interface ZZAutoCreateDimensionModel: NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *tip;

@property (nonatomic, copy) NSArray *item;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *inputContent;

@end

@interface ZZAutoCreatetemplateModel: NSObject

@property (nonatomic, copy) NSString *catalogId;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSArray *name;

@end
