//
//  ZZMessageCommentModel.h
//  zuwome
//
//  Created by angBiu on 16/9/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZCommentModel.h"
#import "ZZMemedaModel.h"
#import "ZZSKModel.h"

@interface ZZMessageCommentDetailModel : JSONModel

@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, strong) ZZMMDModel *mmd;
@property (nonatomic, strong) ZZSKModel *sk;
@property (nonatomic, strong) ZZReplyModel *reply;
@property (nonatomic, strong) ZZReplyModel *sk_reply;
@property (nonatomic, strong) NSString *type;

//红包消息用的
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;

@end

@interface ZZMessageCommentModel : JSONModel

@property (nonatomic, strong) ZZMessageCommentDetailModel *message;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, assign) NSInteger read;//0代表未读 1已读（新增）

@end
