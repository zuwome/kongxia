//
//  ZZChatBoxGreetingEditView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GreetingEditType) {
    GreetingEditTypeEdit = 0,
    GreetingEditTypeAdd,
};

@interface ZZChatBoxGreetingEditView : UIView

@property (nonatomic, assign) GreetingEditType type;
@property (nonatomic, copy) void(^clickSave)(NSString *greeting);
@property (nonatomic, copy) void(^clickSend)(NSString *greeting);

@property (nonatomic) UITextView *textView;
@property (nonatomic) UILabel *countLab;

@end
