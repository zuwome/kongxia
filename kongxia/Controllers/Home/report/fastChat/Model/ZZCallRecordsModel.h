//
//  ZZCallRecordsModel.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRoomModel : JSONModel

@property (nonatomic, copy) NSString *id;//记录单号
@property (nonatomic, copy) NSString *created_at_text;//距离多少时间
@property (nonatomic, copy) NSString *time_text;//本次通话时长、未接听文案
@property (nonatomic, strong) ZZUser *admin;//发起人(自己)
@property (nonatomic, strong) ZZUser *user;//对方

@end

@interface ZZCallRecordsModel : JSONModel

@property (nonatomic, strong) ZZRoomModel *room;
@property (nonatomic, copy) NSString *sort_value;

@end
