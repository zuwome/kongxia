//
//  ZZMyKTVController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"


@interface ZZMyKTVController : ZZViewController

@end


@class ZZMyKTVControllerHeaderView;
@protocol ZZMyKTVControllerHeaderViewDelegate <NSObject>

- (void)header:(ZZMyKTVControllerHeaderView *)header select:(NSInteger)index;

@end

@interface ZZMyKTVControllerHeaderView : UIView

@property (nonatomic, weak) id<ZZMyKTVControllerHeaderViewDelegate> delegate;

- (void)offetSet:(CGFloat)offsetX;

@end
