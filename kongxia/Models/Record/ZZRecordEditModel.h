//
//  ZZRecordEditModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ZZRecordEditStytle) {
  ZZRecordEditStytleLocale,//地点
  ZZRecordEditStytleTopic,//话题
};
@interface ZZRecordEditModel : NSObject
/**
 类型
 */
@property (nonatomic,assign) ZZRecordEditStytle typeStytle;

/**
 高度
 */
@property (nonatomic,assign,readonly) float showHeight;

/**
 标题
 */
@property (nonatomic,strong) NSString *modelTitle;


/**
 是否选中
 */
@property (nonatomic,assign) BOOL isSelect;
@end
