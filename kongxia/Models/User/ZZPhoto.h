//
//  ZZPhoto.h
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"
@protocol ZZPhoto
@end

@interface ZZPhoto : JSONModel
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *url;

// 0:表示不通过 1:待审核 2:审核通过
@property (assign, nonatomic) NSInteger status;

// 1:代表人脸未比对 2:代表人脸有比对但不通过  3:代表人脸有比对通过
@property (assign, nonatomic) NSInteger face_detect_status;

@property (nonatomic, strong) UIImage *image;

- (void)add:(requestCallback)next;
- (void)remove:(requestCallback)next;

@end
