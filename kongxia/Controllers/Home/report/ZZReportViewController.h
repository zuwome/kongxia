//
//  ZZReportViewController.h
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTasks.h"
/**
 *  举报
 */
@class ZZReportViewController;
@protocol ZZReportViewControllerDelegate <NSObject>

- (void)viewController:(ZZReportViewController *)viewController reportSuccess:(BOOL)isSuccess;

@end


@interface ZZReportViewController : ZZViewController
@property (nonatomic, weak) id<ZZReportViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isFromTask;
@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, copy) NSString *pd_user;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, assign) BOOL isUser;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *skId;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSString *sk_rid;

@end
