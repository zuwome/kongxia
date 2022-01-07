//
//  ZZTaskLikesViewModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTasks.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskLikesViewModel;

@protocol ZZTaskLikesViewModelDelegate <NSObject>

- (void)viewModel:(ZZTaskLikesViewModel *)model showUserInfoWith:(ZZUser *)user;

@end

@interface ZZTaskLikesViewModel : NSObject

@property (nonatomic, weak) id<ZZTaskLikesViewModelDelegate> delegate;

- (instancetype)initWithTaskID:(NSString *)taskID tableView:(UITableView *)tableView;

@end

