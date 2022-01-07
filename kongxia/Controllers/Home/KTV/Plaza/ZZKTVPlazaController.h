//
//  ZZKTVPlazaController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZKTVPlazaController : ZZViewController

@end


@class ZZKTVPlazaHeaderView;
@protocol ZZKTVPlazaHeaderViewDelegate <NSObject>

- (void)header:(ZZKTVPlazaHeaderView *)header select:(NSInteger)index;

@end

@interface ZZKTVPlazaHeaderView : UIView

@property (nonatomic, weak) id<ZZKTVPlazaHeaderViewDelegate> delegate;

- (void)offetSet:(CGFloat)offsetX;

@end
