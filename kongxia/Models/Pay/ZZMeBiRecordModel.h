//
//  ZZMeBiRecordModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//@protocol ZZMeBiRecordModel
//@end
@interface ZZMeBiRecordModel : JSONModel


/**
 么币的数组
 */
@property(nonatomic,strong) NSDictionary *mcoin_record;
/**
么币的id
 */
@property(nonatomic,strong)NSString *meBiRecordId;
/**
 么币额度
 */
@property(nonatomic,copy) NSString  *amount;
/**
 么币的用途
 */
@property(nonatomic,strong)NSString *type_text;
/**
 么币的用途类型
 */
@property(nonatomic,strong)NSString *type;

/**
 么币的使用时间
 */
@property(nonatomic,strong)NSString *created_at_text;

/**
 么币的分页加载
 */
@property(nonatomic,copy) NSString *sort_value;


@end
