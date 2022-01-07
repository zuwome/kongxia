//
//  ZZOrderOptionModel.h
//  zuwome
//
//  Created by angBiu on 16/9/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ZZOrderOptionModel

@end

@interface ZZOrderOptionModel : JSONModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double percent;

@end

@interface ZZOrderRefundModel : JSONModel

@property (nonatomic, strong) NSMutableArray<ZZOrderOptionModel> *mine;//我的原因
@property (nonatomic, strong) NSMutableArray<ZZOrderOptionModel> *yours;//对方的原因
@property (nonatomic, strong) NSString *illegal_to;//达人查看的违规手册
@property (nonatomic, strong) NSString *illegal_from;//用户查看的违规手册
@property (nonatomic, strong) NSArray <ZZOrderOptionModel>*reason;//拒绝退款的理由
@property (nonatomic, strong) NSArray *data;//达人接受邀约后,取消邀约

@end
