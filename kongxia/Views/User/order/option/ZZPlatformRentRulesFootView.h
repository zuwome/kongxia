//
//  ZZPlatformRentRules.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 平台审核规则
 */
@interface ZZPlatformRentRulesFootView : UIView
/**
 点击帮助详情
 */
@property (nonatomic, copy) dispatch_block_t touchHead;
/**
 服务端返回的常见违规行为的

 @param ruleString <#ruleString description#>
 */
- (void)setRentRulesString:(NSString*)ruleString;



@end
