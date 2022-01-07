//
//  ZZInvitationModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZInvitationModel.h"

@implementation ZZInvitationModel
-(BOOL)isResponsible{
    if ([self.title isEqualToString:@"对方的原因"]) {
        return NO;
    }
    return YES;
}
@end
