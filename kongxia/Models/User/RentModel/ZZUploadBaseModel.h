//
//  ZZUploadBaseModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 上传证据的基类 model
 */
@interface ZZUploadBaseModel : JSONModel

/**
 用户上传证据的理由
 */
@property(nonatomic,strong) NSString *remarks;

/**
 用户上传的图片证据
 */
@property(nonatomic,strong) NSArray  *photos;

/**
 达人上传证据的理由
 */
@property(nonatomic,strong) NSString *refuse_reason;

/**
 达人拒绝的上传图片证据
 */
@property(nonatomic,strong) NSArray  *refuse_photos;


/**
 订单的状态  appealing  代表申诉中
 */
@property (nonatomic,strong) NSString *status;

/**
用户的
 */
@property (nonatomic,strong) NSString *userName;

/**
达人的
 */
@property (nonatomic,strong) NSString *doyenNickName;


@end
