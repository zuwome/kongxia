//
//  ZZRentMemedaTopicView.h
//  zuwome
//
//  Created by angBiu on 16/8/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页么么答 话题view
 */
@interface ZZRentMemedaTopicView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *questionTV;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSMutableArray *topicArray;

@property (nonatomic, copy) dispatch_block_t touchTopic;
@property (nonatomic, copy) dispatch_block_t touchRandom;
@property (nonatomic, copy) dispatch_block_t touchTopicInfo;
@property (nonatomic, copy) void(^removeIndex)(NSInteger index);
@property (nonatomic, copy) dispatch_block_t touchEditType;
@property (nonatomic, copy) dispatch_block_t beginEdit;
@property (nonatomic, copy) dispatch_block_t endEdit;

@property (nonatomic, assign) BOOL isPublic;//是否是公开提问
@property (nonatomic, assign) BOOL isEdit;//是否是自己编辑的内容
@property (nonatomic, assign) BOOL isAnonymous;//是否是匿名提问

- (void)addTopic:(NSString *)topic;
- (void)setQuestion:(NSString *)question;
- (void)privateStatus;
- (void)publicStatus;

@end
