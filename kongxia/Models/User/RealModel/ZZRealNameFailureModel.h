//
//  ZZRealNameFailureModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/7/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 认证失败的
 */
@interface ZZRealNameFailureModel : JSONModel

/**
 状态
 */
@property(nonatomic,assign) int  status;


/**
 name
 */
@property(nonatomic,strong) NSString *name;

/**
 code 身份证
 */
@property(nonatomic,strong) NSString *code;
/**
 上传认证时间
 */
@property(nonatomic,strong) NSString *updated_at;
@end
