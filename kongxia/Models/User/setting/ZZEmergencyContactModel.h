//
//  ZZEmergencyContactModel.h
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ZZEmergencyContactModel
@end

/**
 紧急联系人
 */
@interface ZZEmergencyContactModel : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

@end
