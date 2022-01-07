//
//  ZZRecordTopicView.h
//  zuwome
//
//  Created by angBiu on 2017/4/26.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopicModel.h"

@interface ZZRecordTopicView : UIView

@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void(^selectedTopic)(ZZTopicGroupModel *model);
@property (nonatomic, strong) dispatch_block_t closeClickCallBack;//关闭按钮的回调

- (void)show;
- (void)hide;

@end
