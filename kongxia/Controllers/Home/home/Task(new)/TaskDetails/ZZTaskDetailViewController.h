//
//  ZZTaskDetailViewController.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTasks.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskModel;
@class ZZTaskDetailViewController;

@protocol ZZTaskDetailViewControllerDelegate <NSObject>

- (void)viewController:(ZZTaskDetailViewController *)viewController taskInfoChanged:(ZZTaskModel *)task atIndexPath:(NSIndexPath *)indexPath;

- (void)viewController:(ZZTaskDetailViewController *)viewController deleteTaskFromList:(ZZTaskModel *)task atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZZTaskDetailViewController : ZZViewController

@property (nonatomic, weak) id<ZZTaskDetailViewControllerDelegate> delegate;

- (instancetype)initWithTask:(ZZTaskModel *)task indexPath:(NSIndexPath *)taskIndexPath listType:(TaskListType)listType taskType:(TaskType)taskType;

- (instancetype)initWithTaskID:(NSString *)taskID;

@end


@interface ZZTaskDetailBottomView : UIView

@property (nonatomic, strong) UIButton *pickBtn;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *pickedLabel;

- (void)configurePriceWithTask:(ZZTaskModel *)task;

@end
