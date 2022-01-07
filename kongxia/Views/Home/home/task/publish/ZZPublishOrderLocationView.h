//
//  ZZPublishOrderLocationView.h
//  zuwome
//
//  Created by angBiu on 2017/7/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPublishOrderLocationView : UIView

@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (nonatomic, strong) NSString *noLimitStr;
@property (nonatomic, strong) NSString *nearStr;
- (void)show:(NSString *)location;

@property (nonatomic, copy) void(^chooseTime)(NSString *showString);

@end
