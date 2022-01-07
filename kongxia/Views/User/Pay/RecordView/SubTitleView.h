//
//  SubTitleView.h
//
//  Created by app on 2016/12/28.
//  Copyright © 2016年 潘杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubTitleView;

@protocol SubTitleViewDelegate <NSObject>

- (void)subTitleViewDidSelected:(SubTitleView *)titleView atIndex:(NSInteger)index title:(NSString *)title;

@end


@interface SubTitleView : UIView

@property (nonatomic, weak) id <SubTitleViewDelegate> delegate;

/**
 *  标题数据源
 **/
@property (nonatomic, strong) NSArray *titleArray;

/**
 当前选中的
 */
@property (nonatomic, assign) NSInteger selectTag;

/**
 *  切换到子视图中
 **/
- (void)transToShowAtIndex:(NSInteger)index;

@end
