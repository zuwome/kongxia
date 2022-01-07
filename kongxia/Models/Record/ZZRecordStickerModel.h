//
//  ZZRecordStickerModel.h
//  zuwome
//
//  Created by angBiu on 2016/12/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRecordStickerModel : JSONModel

@property (nonatomic, strong) NSString *stickerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *down_link;
@property (nonatomic, strong) NSString *created_at_text;

+ (void)getStickersList:(requestCallback)next;

@end
