//
//  ZZCommentModel.h
//  zuwome
//
//  Created by angBiu on 16/8/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZReplyModel : JSONModel

@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger media_type;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) ZZReplyModel *reply_which_reply;

@end

@protocol ZZCommentModel
@end

@interface ZZCommentModel : JSONModel

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) ZZReplyModel *reply;

@end
