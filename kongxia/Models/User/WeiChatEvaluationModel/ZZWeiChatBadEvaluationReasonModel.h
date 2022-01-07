//
//  ZZWeiChatBadEvaluationReasonModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZWeiChatBadEvaluationReasonModel : JSONModel

/**
 差评原因
 */
@property (nonatomic,strong)NSString * reason;


/**
 当前差评理由是否已经被选中
 */
@property(nonatomic,assign) BOOL isSelect;

@end
