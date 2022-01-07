//
//  ZZRecordLabelModel.h
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRecordLabelModel : JSONModel

@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at_text;

+ (void)getLabelList:(requestCallback)next;

@end
