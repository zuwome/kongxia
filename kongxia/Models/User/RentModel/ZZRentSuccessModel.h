//
//  ZZRentSuccessModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRentSuccessModel : JSONModel

/**
 <#Description#>
 */
@property(nonatomic,strong) NSString *title;
/**
 Description
 */
@property(nonatomic,strong) NSString *desc;
/**
 <#Description#>
 */
@property(nonatomic,strong) NSString *detail;


/**
 返回开通成功的结果

 @param next
 */
+ (void )getRentSuccessCallBack:(void(^)(ZZRentSuccessModel *rentSuccessModel))next;



@end
