//
//  ZZWeiChatEvaluationModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatEvaluationModel.h"

@implementation ZZWeiChatEvaluationModel

-(BOOL)isBuy {
    if (_type == PaymentTypeIDPhoto) {
        return  self.user.can_see_real_id_photo;
    }
    else {
        return  self.user.can_see_wechat_no;
    }
    
}

-(BOOL)isPingJia {
    if (_type == PaymentTypeIDPhoto) {
        return NO;
    }
    else {
        return self.user.have_commented_wechat_no;
    }
    
}
- (NSInteger)wechat_comment_score {
    if (_type == PaymentTypeIDPhoto) {
        return 0;
    }
    else {
        return self.user.wechat_comment_score;
    }
}

- (NSInteger)lookNumber {
    if (_type == PaymentTypeIDPhoto) {
        return 0;
    }
    else {
        return self.user.wechat.good_comment_count;
    }
}

- (NSString *)userIphoneNumber{
    return [ZZUserHelper shareInstance].loginer.phone;
}

@end
