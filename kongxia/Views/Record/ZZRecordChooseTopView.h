//
//  ZZRecordChooseTopView.h
//  zuwome
//
//  Created by angBiu on 2017/2/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 录像--选择滤镜头部view
 */
@interface ZZRecordChooseTopView : UIView

@property (nonatomic, copy) void(^touchIndex)(NSInteger index);

@end
