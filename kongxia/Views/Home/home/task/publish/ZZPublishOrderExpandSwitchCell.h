//
//  ZZPublishOrderExpandSwitchCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPublishOrderExpandSwitchCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, copy) NSString *isExpand;     //1自动扩充 0不自动扩充

@property (nonatomic, copy) void (^expandSwitchBlock)(NSString *expand);    //1自动扩充 0不自动扩充

@end
