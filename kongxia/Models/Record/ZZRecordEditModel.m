//
//  ZZRecordEditModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRecordEditModel.h"

@implementation ZZRecordEditModel

- (float)showHeight {
        CGRect currentSize = [self.modelTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 ]} context:nil];
    return currentSize.size.width;
}
@end
